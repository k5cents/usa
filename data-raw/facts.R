## code to prepare `state_facts` dataset goes here
library(tidyverse)
library(tidycensus)
library(lubridate)
library(readxl)
library(rvest)
library(httr)
library(httr2)
library(sf)
library(tigris)
library(fs)
library(usethis)

abb_fips <- select(read_csv("data-raw/states.csv"), fips, abb)
abb_name <- select(read_csv("data-raw/states.csv"), name, abb)

# population --------------------------------------------------------------

# 2020 Decennial Census PL 94-171 file, variable P1_001N (total population).
# geography = "state" returns all 52 rows: 50 states + DC + PR.
st_pop <- get_decennial(
  geography = "state",
  variables = "P1_001N",
  year = 2020,
  sumfile = "pl"
) %>%
  inner_join(abb_name, by = c("NAME" = "name")) %>%
  select(abb, population = value)

# income ------------------------------------------------------------------

# Per capita income, 2022 ACS 1-year.
# B19301_001 = Per capita income in the past 12 months (inflation-adjusted dollars)
st_income <- get_acs(
  geography = "state",
  variables = "B19301_001",
  year = 2022,
  survey = "acs1"
) %>%
  inner_join(abb_name, by = c("NAME" = "name")) %>%
  select(abb, income = estimate)

# gdp ---------------------------------------------------------------------

# SQGDP2 Gross domestic product (GDP) by state
gdp_get <- GET(
  url = "https://apps.bea.gov/api/data",
  query = list(
    UserID = Sys.getenv("BEA_API_KEY"),
    method = "GetData",
    datasetname = "Regional",
    TableName = "SQGDP2",
    GeoFIPS = "STATE",
    LineCode = 1,
    Year = 2020,
    ResultFormat = "json"
  )
)

gdp_dat <- content(a, as = "parsed", simplifyDataFrame = TRUE)
gdp_dat$BEAAPI$Results$UTCProductionTime
st_income <- gdp_dat$BEAAPI$Results$Data %>%
  filter(TimePeriod == "2020Q1") %>%
  select(name = GeoName, gdp = DataValue) %>%
  mutate(across(gdp, parse_number)) %>%
  inner_join(abb_name, by = "name") %>%
  as_tibble()

# life expect -------------------------------------------------------------

# List of U.S. states and territories by life expectancy
# Institute for Health Metrics and Evaluation for the states (2017 data), and
# from the CIA World Factbook for the territories (2018 data)
# http://www.healthdata.org/united-states-alabama
# https://web.archive.org/web/20190109030048/https://www.cia.gov/library/publications/the-world-factbook/fields/355rank.html
life <-
  read_html("https://w.wiki/BeA") %>%
  html_node(".wikitable") %>%
  html_table(fill = TRUE, header = FALSE) %>%
  na_if("") %>%
  slice(-(1)) %>%
  as_tibble() %>%
  filter(!is.na(X1)) %>%
  select(name = X2, life_exp = X3) %>%
  mutate_at(vars(life_exp), parse_number) %>%
  inner_join(y = abb_name, by = "name") %>%
  select(abb, life_exp) %>%
  arrange(desc(life_exp))

# murder ------------------------------------------------------------------

# FBI Crime Data Explorer API: annual homicide rate per 100,000 (2022 NIBRS).
# The API returns monthly rates; summing 12 months gives the annual figure.
# PR has no NIBRS coverage and will return NA.
murder <- map_dfr(abb_name$abb, function(st) {
  resp <- tryCatch(
    request("https://api.usa.gov/crime/fbi/cde") |>
      req_url_path_append("summarized", "state", st, "homicide") |>
      req_url_query(from = "01-2022", to = "12-2022", API_KEY = Sys.getenv("GOV_API_KEY")) |>
      req_throttle(rate = 2) |>
      req_perform() |>
      resp_body_json(),
    error = function(e) NULL
  )
  if (is.null(resp) || is.null(resp$offenses$rates)) {
    return(tibble(abb = st, murder = NA_real_))
  }
  rate_names  <- names(resp$offenses$rates)
  offense_key <- rate_names[grepl("Offenses", rate_names) & !grepl("United States", rate_names)]
  if (!length(offense_key)) return(tibble(abb = st, murder = NA_real_))
  monthly <- unlist(resp$offenses$rates[[offense_key]])
  tibble(abb = st, murder = round(sum(monthly, na.rm = TRUE), 2))
})

# education ---------------------------------------------------------------

# Percent with bachelor's degree or higher (population 25+), 2022 ACS 1-year.
# S1501_C02_015 = Percent; Population 25 years and over -- Bachelor's degree or higher
edu <- get_acs(
  geography = "state",
  variables = "S1501_C02_015",
  year = 2022,
  survey = "acs1"
) %>%
  inner_join(abb_name, by = c("NAME" = "name")) %>%
  mutate(college = round(estimate / 100, 4)) |>
  select(abb, college)

# frost days --------------------------------------------------------------

# NCEI 1991-2020 Climate Normals: mean days per year with minimum temp < 32F.
# Variable ANN-TMIN-AVGNDS-LSTH032 from the annualseasonal by-station archive.
# Replaces 1981-2010 FTP-based cooling degree days (dead source, wrong metric).
# State assignment via spatial join with TIGER 2022 boundaries (sf + tigris),
# replacing sp::point.in.polygon + rgdal::readOGR for DC station detection.
normals_url <- paste0(
  "https://www.ncei.noaa.gov/data/normals-annualseasonal/1991-2020/archive/",
  "us-climate-normals_1991-2020_v1.0.1_annualseasonal_multivariate_by-station_c20230404.tar.gz"
)
normals_archive <- file_temp(ext = "tar.gz")
normals_dir     <- file_temp()
dir.create(normals_dir)
download.file(normals_url, normals_archive, mode = "wb", quiet = TRUE)
untar(normals_archive, exdir = normals_dir)

csv_files <- list.files(normals_dir, pattern = "\\.csv$", full.names = TRUE, recursive = TRUE)
normals <- map_dfr(csv_files, function(f) {
  tryCatch(
    read_csv(f, col_types = cols_only(
      STATION                   = col_character(),
      LATITUDE                  = col_double(),
      LONGITUDE                 = col_double(),
      `ANN-TMIN-AVGNDS-LSTH032` = col_double()
    ), show_col_types = FALSE),
    error = function(e) NULL
  )
}) |> filter(!is.na(`ANN-TMIN-AVGNDS-LSTH032`))

state_bounds <- tigris::states(year = 2022, cb = TRUE) |>
  filter(STUSPS %in% abb_name$abb) |>
  select(abb = STUSPS) |>
  st_transform(4326)

stations_sf <- st_as_sf(normals, coords = c("LONGITUDE", "LATITUDE"), crs = 4326)
temp <- st_join(stations_sf, state_bounds, join = st_within) |>
  st_drop_geometry() |>
  filter(!is.na(abb)) |>
  group_by(abb) |>
  summarise(frost = round(mean(`ANN-TMIN-AVGNDS-LSTH032`, na.rm = TRUE), 1))

# admission ---------------------------------------------------------------

# https://en.wikipedia.org/wiki/List_of_U.S._states_by_date_of_admission_to_the_Union
admission <-
  read_html("https://w.wiki/EQG") %>%
  html_node("table") %>%
  html_table(fill = TRUE) %>%
  as_tibble(.name_repair = "unique") %>%
  select(name = 2, admission = 3) %>%
  mutate(
    admission = admission %>%
      str_remove("(\\[|\\().*") %>%
      parse_date("%B %d, %Y")
  ) %>%
  left_join(abb_name) %>%
  select(abb, admission) %>%
  # https://en.wikipedia.org/wiki/Territories_of_the_United_States
  bind_rows(
    tribble(
      ~abb, ~admission,
      "DC", as.Date("1790-07-16"), # Residence Act
      "AS", as.Date("1900-04-17"), # Treaty of Cession of Tutuila
      "GU", as.Date("1898-12-10"), # Treaty of Paris
      "MP", as.Date("1976-03-24"), # Commonwealth Covenant
      "PR", as.Date("1898-12-10"), # Treaty of Paris
      "VI", as.Date("1917-03-31")  # Treaty of the Danish West Indies
    )
  ) %>%
  arrange(admission)


# electoral college -------------------------------------------------------

url <- "https://www.archives.gov/electoral-college/allocation"
ec <- read_html(url) %>%
  html_node("table") %>%
  html_table() %>%
  as_vector() %>%
  enframe(name = NULL) %>%
  separate(value, c("name", "electors"), "\\s-\\s") %>%
  mutate(across(electors, parse_number)) %>%
  inner_join(abb_name, by = "name") %>%
  select(abb, electors)

# join --------------------------------------------------------------------

state_facts <- st_pop %>%
  left_join(ec, by = "abb") %>%
  left_join(admission, by = "abb") %>%
  left_join(st_income, by = "abb") %>%
  left_join(life, by = "abb") %>%
  left_join(murder, by = "abb") %>%
  left_join(edu, by = "abb") %>%
  left_join(temp, by = "abb") %>%
  left_join(abb_name, by = "abb") %>%
  select(name, everything()) %>%
  arrange(name) %>%
  select(-abb)

# save --------------------------------------------------------------------

use_data(state_facts, overwrite = TRUE)
write_csv(state_facts, "data-raw/state_facts.csv")
