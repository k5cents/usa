## code to prepare `info` dataset goes here
library(tidyverse)
library(magrittr)
library(readxl)
library(rvest)
library(vroom)

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
  select(
    fips = STATE,
    population = POPESTIMATE2018,
    adult = PCNT_POPEST18PLUS
  ) %>%
  filter(fips != "00") %>%
  mutate(adult = round(adult/100, digits = 3)) %>%
  arrange(desc(population))

# income ------------------------------------------------------------------


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

life <-
  read_html("https://w.wiki/BeA") %>%
  html_node(".wikitable") %>%
  html_table(fill = TRUE, header = FALSE) %>%
  na_if("") %>%
  slice(-(1)) %>%
  as_tibble() %>%
  filter(!is.na(X1)) %>%
  select(
    name = X2,
    life = X3
  ) %>%
  mutate_at(vars(life), parse_number) %>%
  inner_join(state_names) %>%
  select(fips, life) %>%
  arrange(desc(life))

# murder ------------------------------------------------------------------

# https://ucr.fbi.gov/crime-in-the-u.s/2017/crime-in-the-u.s.-2017/topic-pages/tables/table-4
murder <-
  read_excel("data-raw/table-4.xls", range = "A4:G203") %>%
  fill(Area) %>%
  filter(Year == "2017") %>%
  select(
    state = Area,
    murder = 7
  ) %>%
  mutate(
    name = str_remove_all(state, "\\d"),
    murder = round(as.numeric(murder), 2)
  ) %>%
  inner_join(state_names) %>%
  select(fips, murder) %>%
  arrange(desc(murder))

# education ---------------------------------------------------------------

education <-
  read_html("https://w.wiki/Bd$") %>%
  html_node(".wikitable") %>%
  html_table(fill = TRUE, header = FALSE) %>%
  slice(-(1:2)) %>%
  as_tibble() %>%
  select(
    name = X1,
    high = X2,
    bach = X4,
    grad = X6
  ) %>%
  mutate_at(
    .vars = c(2:4),
    .funs = function(x) parse_number(x)/100
  ) %>%
  inner_join(state_names) %>%
  select(fips, high, bach, grad) %>%
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
degree_days <- read_fwf(
  file = "ftp://ftp.ncdc.noaa.gov/pub/data/normals/1981-2010/products/temperature/ann-cldd-normal.txt",
  col_positions = fwf_cols(
    id = c(1, 11),
    days = c(19, 23),
    flag = c(24)
  )
)

years <- 2010 - 1981

degree_days %>%
  left_join(allstations, by = "id") %>%
  group_by(state) %>%
  summarise(mean = mean(days)/years) %>%
  arrange(desc(mean)) %>%
  left_join(abbs, by = c("state" = "abb"))
