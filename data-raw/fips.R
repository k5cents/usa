library(tidyverse)
library(janitor)
library(readxl)
library(fs)

fips_url <- "https://www2.census.gov/programs-surveys/popest/geographies/2017/all-geocodes-v2017.xlsx"
fips_path <- path_temp(basename(fips_url))
download.file(fips_url, fips_path)
fips <- read_excel(
  path = fips_path,
  range = "A5:G43915",
  col_types = "text",
  na = c("00000", "000", "00")
)

fips <- fips %>%
  remove_empty("cols") %>%
  rename_all(
    ~ word(., 1, 2) %>%
      str_to_lower() %>%
      str_replace("\\s", "_")
  ) %>%
  unite(
    county_subdivision, place_code, consolidtated_city,
    col = city_code,
    na.rm = TRUE
  ) %>%
  na_if("")

fips.state <- fips %>%
  filter(summary_level == "040") %>%
  select(state_code, area_name)

fips.county <- fips %>%
  filter(summary_level == "050") %>%
  select(state_code, county_code, area_name)

fips.city <- fips %>%
  filter(!is.na(city_code)) %>%
  select(state_code, county_code, city_code, area_name)

fips_all <- fips.city %>%
  left_join(
    y = fips.county,
    by = c("state_code", "county_code"),
    suffix = c("_town", "_county")
  ) %>%
  left_join(
    y = fips.state,
    by = "state_code",
    suffix = c("_town", "_county")
  ) %>%
  select(
    town = area_name_town,
    county = area_name_county,
    state = area_name
  ) %>%
  arrange(state, county, town)

