## code to prepare `info` dataset goes here
library(tidyverse)
library(magrittr)
library(readxl)
library(rvest)
library(fs)

abb_fips <- select(read_csv("data-raw/states.csv"), fips, abb)
abb_name <- select(read_csv("data-raw/states.csv"), name, abb)

# population --------------------------------------------------------------

url <- "https://www2.census.gov/programs-surveys/popest/datasets/2010-2018/state/detail/SCPRC-EST2018-18+POP-RES.csv"
populations <- read_csv(
  file = url,
  na = "X",
  col_types = cols(
    SUMLEV = col_character(),
    REGION = col_character(),
    DIVISION = col_character(),
    STATE = col_character(),
    NAME = col_character(),
    POPESTIMATE2018 = col_double(),
    POPEST18PLUS2018 = col_double(),
    PCNT_POPEST18PLUS = col_double()
  )
)

populations <- populations %>%
  rename(fips = STATE, population = POPESTIMATE2018) %>%
  filter(fips != "00") %>%
  left_join(y = abb_fips, by = "fips") %>%
  select(abb, population) %>%
  arrange(desc(population))

# income ------------------------------------------------------------------

# http://factfinder.census.gov/bkmk/table/1.0/en/ACS/17_1YR/R1901.US01PRF
# MEDIAN HOUSEHOLD INCOME (IN 2017 INFLATION-ADJUSTED DOLLARS) - United States -- States; and Puerto Rico
# Source:  U.S. Census Bureau, 2017 American Community Survey 1-Year Estimates
zip_file <- "data-raw/ACS_17_1YR_R1901.US01PRF.zip"
R1901 <- unzip(zip_file, "ACS_17_1YR_R1901.US01PRF.csv", exdir = "data-raw")
income <-
  read_csv(file = R1901) %>%
  select(fips = 5, income = EST) %>%
  left_join(abb_fips, by = "fips") %>%
  filter(!is.na(abb)) %>%
  select(abb, income)

file_delete(R1901)


# gdp ---------------------------------------------------------------------

# Gross Domestic Product by State: Second Quarter 2019
gdp_url <- "https://www.bea.gov/system/files/2019-11/qgdpstate1119.xlsx"
gdp_file <- file_temp(ext = "xlsx")
download.file(gdp_url, gdp_file)
gdp <- read_excel(
  path = gdp_file,
  sheet = "Table 3",
  range = "A4:G65"
)

gdp <- gdp %>%
  select(name = 1, gdp = 7) %>%
  inner_join(abb_name) %>%
  select(abb, gdp) %>%
  mutate_at(vars(gdp), parse_integer) %>%
  bind_rows(
    tribble(
      ~abb, ~gdp,
      "AS", 608L, # BEA
      "GU", 5920L, # BEA
      "MP", 1323L, # BEA
      "PR", 99913L, # IMF
      "VI", 3984L, # BEA
    )
  )

# literacy ----------------------------------------------------------------

# https://nces.ed.gov/naal/estimates/StateEstimates.aspx
literacy <-
  read_csv("data-raw/ExportedData.csv") %>%
  select(
    fips = `FIPS code`,
    literacy = `Prose literacy skills`
  ) %>%
  mutate(
    fips = str_sub(str_pad(fips, width = 5, pad = "0"), end = 2),
    literacy = round(literacy/100, 4)
  ) %>%
  arrange(desc(literacy))

# life expect -------------------------------------------------------------

# List of U.S. states and territories by life expectancy
# Institute for Health Metrics and Evaluation for the states (2017 data), and
# from the CIA World Factbook for the territories (2018 data)
# http://www.healthdata.org/united-states-alabama
# https://www.cia.gov/library/publications/the-world-factbook/geos/aq.html
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

fbi_url <- "https://ucr.fbi.gov/crime-in-the-u.s/2018/crime-in-the-u.s.-2018/tables/table-4/table-4.xls/output.xls"
fbi_file <- file_temp(ext = "xls")
download.file(fbi_url, fbi_file)
murder <-
    read_excel("data-raw/table-4.xls", range = "A4:G203") %>%
    fill(Area) %>%
    filter(Year == "2018") %>%
    select(name = Area, murder = 7) %>%
    mutate(
      name = str_remove_all(name, "\\d"),
      murder = round(as.numeric(murder), 2)
    ) %>%
    inner_join(abb_name, by = "name") %>%
    select(abb, murder) %>%
    arrange(desc(murder))

# education ---------------------------------------------------------------

# https://factfinder.census.gov/bkmk/table/1.0/en/ACS/17_1YR/S1501
# https://data.census.gov/cedsci/table?q=S1501
# S1501 EDUCATIONAL ATTAINMENT
# Source:  U.S. Census Bureau, 2018 American Community Survey 1-Year Estimates
edu_zip <- dir_ls(path_temp(), regexp = "S1501")
edu_file <- unzip(edu_zip, list = TRUE)$Name[3]
edu_file <- unzip(
  zipfile = edu_zip,
  files = edu_file,
  exdir = path_temp()
)

edu <-
  read_csv(
    file = edu_file,
    col_types = cols(.default = "c")
  ) %>%
  slice(-1) %>%
  na_if("(X)") %>%
  mutate_all(parse_guess) %>%
  transmute(
    # combine cols for 18 to 24 and over 25
    name = NAME,
    # Populations
    pop = S1501_C01_001E + S1501_C01_006E,
    # High school graduate or higher
    high = ((S1501_C01_001E - S1501_C01_002E) + S1501_C01_014E)/pop,
    # Bachelor's degree or higher
    bach = (S1501_C01_005E + S1501_C01_015E)/pop
  ) %>%
  inner_join(abb_name, by = "name") %>%
  mutate_if(is.numeric, round, 4) %>%
  select(abb, high, bach) %>%
  arrange(desc(high))

# temperature -------------------------------------------------------------

allstations <- read_fwf(
  file = "ftp://ftp.ncdc.noaa.gov/pub/data/normals/1981-2010/station-inventories/allstations.txt",
  col_positions = fwf_cols(
    id = c(1, 11),
    lat = c(13, 20),
    long = c(22, 30),
    elev = c(32, 37),
    state = c(39, 40),
    name = c(42, 71),
    gsn = c(73, 75),
    hsn = c(77, 79),
    wmoid = c(81, 85),
    method = c(87, 99)
  )
)

# annual cooling degree days
degree_days <-
  read_fwf(
    file = "ftp://ftp.ncdc.noaa.gov/pub/data/normals/1981-2010/products/temperature/ann-cldd-normal.txt",
    col_positions = fwf_cols(
      id = c(1, 11),
      days = c(19, 23),
      flag = c(24)
    )
  ) %>%
  left_join(allstations, by = "id") %>%
  group_by(abb = state) %>%
  summarise(heat = round(mean(days)/(2010 - 1981), 2)) %>%
  arrange(desc(heat))

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

# join --------------------------------------------------------------------

info <- populations %>%
  left_join(admission)
  left_join(income, by = "abb") %>%
  left_join(life, by = "abb") %>%
  left_join(murder, by = "abb") %>%
  left_join(edu, by = "abb") %>%
  left_join(degree_days, by = "abb") %>%
  left_join(abb_name) %>%
  arrange(name) %>%
  select(-name)

# save --------------------------------------------------------------------

use_data(info, overwrite = TRUE)
write_csv(info, "data-raw/info.csv")

state.x19 <- as.matrix(column_to_rownames(info, "abb"))
use_data(state.x19, overwrite = TRUE)
