## code to prepare `area` dataset goes here
library(tidyverse)
library(rvest)

# an area measurement providing the size, in square meters, of the land portions
# of geographic entities for which the Census Bureau tabulates and disseminates
# data.

# Area is calculated from the specific boundary recorded for each entity in the
# Census Bureau's geographic database (see "MAF/TIGER Database"). The Census
# Bureau provides area measurement data for both land area and water area...

# Land area measurements are originally recorded as whole square meters (to
# convert square meters to square kilometers, divide by 1,000,000; to convert
# square kilometers to square miles, divide by 2.58999; to convert square meters
# to square miles, divide by 2,589,988).

source <- "https://tigerweb.geo.census.gov/tigerwebmain/Files/acs19/tigerweb_acs19_state_us.html"
tiger <- read_html(source)
html_text(html_node(tiger, "title"))
# U.S. States - Current/ACS19 - Data as of January 1, 2019
html_node(tiger, "table") %>% html_attr("summary")
# This table containing the U.S. States - Current/ACS19 - Data as of January 1,
# 2019, gives the data (headers) for each States record (rows). For the record
# layout, please reference back to the Record Layout link on the TIGERweb
# State-Based Tabular Data Files page for the given record type.
area <- tiger %>%
  html_node("table") %>%
  html_table() %>%
  as_tibble(.name_repair = "unique") %>%
  mutate(
    STATE = str_pad(STATE, 2, pad = "0"),
    sqmi = round(AREALAND/2589988, 2),
    CENTLAT = round(CENTLAT, 4),
    CENTLON = round(CENTLON, 4)
  ) %>%
  select(
    state = STUSAB,
    sqmi,
    lat = CENTLAT,
    long = CENTLON,
  )

# save as rda and csv
usethis::use_data(area, overwrite = TRUE)
write_csv(area, "data-raw/area.csv")

# overwrite datasets::state.area
state.area <- area$sqmi
usethis::use_data(state.area, overwrite = TRUE)
write_lines(state.area, "data-raw/state.area.csv")

## code to prepare `centers` dataset goes here
state.center <- list(x = area$long, y = area$lat)
usethis::use_data(state.center, overwrite = TRUE)
# overwrite datasets::state.center
write_lines(state.center, "data-raw/state.center.csv")
