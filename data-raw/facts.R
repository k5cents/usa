## code to prepare `facts` dataset goes here
library(tidyverse)
library(lubridate)
library(magrittr)
library(readxl)
library(rvest)
library(rgdal)
library(fs)
library(sp)

abb_fips <- select(read_csv("data-raw/states.csv"), fips, abb)
abb_name <- select(read_csv("data-raw/states.csv"), name, abb)

# population --------------------------------------------------------------

# Table 2. Resident Population for the 50 States, the District of Columbia, and Puerto Rico
# https://www.census.gov/data/tables/2020/dec/2020-apportionment-data.html
pop_url <- "https://www2.census.gov/programs-surveys/decennial/2020/data/apportionment/apportionment-2020-table02.xlsx"
pop_xls <- file_temp(ext = path_ext(pop_url))
download.file(pop_url, pop_xls)
st_pop <- read_excel(
  path = pop_xls,
  range = "A4:B55"
)

st_pop <- st_pop %>%
  rename(population = `RESIDENT POPULATION (APRIL 1, 2020)`) %>%
  inner_join(abb_name, by = c("AREA" = "name")) %>%
  select(abb, population)

# income ------------------------------------------------------------------

# MEDIAN INCOME IN THE PAST 12 MONTHS (IN 2019 INFLATION-ADJUSTED DOLLARS)
# https://data.census.gov/cedsci/table?tid=ACSST1Y2019.S1903
st_income <- get_acs(
  geography = "state",
  variables = "S1903_C03_001E",
  year = 2019
)

st_income <- st_income %>%
  rename(income = estimate) %>%
  inner_join(abb_name, by = c("NAME" = "name")) %>%
  select(abb, income)

# gdp ---------------------------------------------------------------------

# Gross Domestic Product by State: Second Quarter 2019
gdp_url <- "https://www.bea.gov/system/files/2019-11/qgdpstate1119.xlsx"
gdp_file <- file_temp(ext = "xlsx")
download.file(gdp_url, gdp_file)
gdp <- read_excel(
  path = gdp_file,
  sheet = "Table 3",
  range = "A5:G65"
)

gdp <- gdp %>%
  select(name = 1, gdp = 7) %>%
  add_row(name = "Puerto Rico", gdp = 99913) %>%
  inner_join(abb_name) %>%
  select(abb, gdp)

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
    read_excel(fbi_file, range = "A4:G203") %>%
    fill(Area) %>%
    filter(Year == "2018") %>%
    select(name = Area, murder = 7) %>%
    mutate(
      name = str_remove_all(name, "\\d"),
      murder = round(as.numeric(murder), 2)
    ) %>%
    inner_join(abb_name, by = "name") %>%
    select(abb, murder)

# education ---------------------------------------------------------------

# https://data.census.gov/cedsci/table?tid=ACSST1Y2018.S1501
# EDUCATIONAL ATTAINMENT
# TableID: S1501
# Survey/Program: American Community Survey
# Product: 2018 ACS 1-Year Estimates Subject Tables
edu_zip <- dir_ls("data-raw/", regexp = "S1501")
edu_list <- unzip(edu_zip, list = TRUE)
edu_file <- unzip(
  zipfile = edu_zip,
  files = edu_list$Name[which.max(edu_list$Length)],
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
    college = (S1501_C01_005E + S1501_C01_015E)/pop
  ) %>%
  inner_join(abb_name, by = "name") %>%
  mutate_if(is.numeric, round, 4) %>%
  select(abb, college)

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

# get DC stations
# read Dc polygon
url <- "https://opendata.arcgis.com/datasets/7241f6d500b44288ad983f0942b39663_10.kml"
tmp <- file_temp(ext = "kml")
download.file(url, tmp)
dc_shape <- readOGR(tmp)

# find points in polygon
in_dc <- point.in.polygon(
  point.x = allstations$long,
  point.y = allstations$lat,
  pol.x = dc_shape@polygons[[1]]@Polygons[[1]]@coords[, 1],
  pol.y = dc_shape@polygons[[1]]@Polygons[[1]]@coords[, 2]
)

allstations$state[which(as.logical(in_dc))] <- "DC"

# annual cooling degree days
degree_days <- read_fwf(
  file = "ftp://ftp.ncdc.noaa.gov/pub/data/normals/1981-2010/products/temperature/ann-cldd-normal.txt",
  col_positions = fwf_cols(
    id = c(1, 11),
    days = c(19, 23),
    flag = c(24)
  )
)

# invalid negative days
sum(degree_days$days < 0)
sum(degree_days$days == -7777L)
degree_days$days[degree_days$days < 0] <- NA


temp <- degree_days %>%
  left_join(allstations, by = "id") %>%
  group_by(abb = state) %>%
  summarise(heat = round(mean(days, na.rm = TRUE)/(2010 - 1981), 2)) %>%
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


# electoral college -------------------------------------------------------

url <- "https://www.archives.gov/electoral-college/allocation"
ec <- read_html(url) %>%
  html_node("table") %>%
  html_table() %>%
  as_vector() %>%
  enframe(name = NULL) %>%
  separate(value, c("name", "votes"), "\\s-\\s") %>%
  mutate(across(votes, parse_number))

# join --------------------------------------------------------------------

facts <- populations %>%
  left_join(ec) %>%
  left_join(admission) %>%
  left_join(income, by = "abb") %>%
  left_join(life, by = "abb") %>%
  left_join(murder, by = "abb") %>%
  left_join(edu, by = "abb") %>%
  left_join(degree_days, by = "abb") %>%
  left_join(abb_name) %>%
  select(name, everything()) %>%
  arrange(name) %>%
  select(-abb)

# save --------------------------------------------------------------------

use_data(facts, overwrite = TRUE)
write_csv(facts, "data-raw/facts.csv")

state.x19 <- facts %>%
  mutate(admission = 2020 - year(admission)) %>%
  rename(age = admission) %>%
  column_to_rownames("name") %>%
  as.matrix()
use_data(state.x19, overwrite = TRUE)
