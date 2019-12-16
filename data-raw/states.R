## code to prepare various code datasets goes here
library(tidyverse)
library(readxl)
library(rvest)

# get state id codes ------------------------------------------------------

# read various census codes
codes <- read_delim(
  file = "https://www2.census.gov/geo/docs/reference/state.txt",
  delim = "|"
)

# reorder and rename
codes <- codes %>%
  select(
    abb = STUSAB,
    name = STATE_NAME,
    fips = STATE,
    ansi = STATENS
  )

# get geography codes -----------------------------------------------------

# download census region file
download.file(
  url = "https://www2.census.gov/programs-surveys/popest/geographies/2018/state-geocodes-v2018.xlsx",
  destfile = "data-raw/state-geocodes-v2018.xlsx"
)

# read region sheet range
geocodes <- read_excel(
  path = "data-raw/state-geocodes-v2018.xlsx",
  range = "A6:D70"
)

# reorder and rename
geocodes <- geocodes %>%
  select(
    fips = `State (FIPS)`,
    rid = Region,
    did = Division,
    name = Name
  )

# delete the census region file
file_delete("data-raw/state-geocodes-v2018.xlsx")

# join and filter to sub codes --------------------------------------------

# create subset of regions
regions <- geocodes %>%
  filter(did == "0") %>%
  select(rid, region = name) %>%
  arrange(rid) %>%
  mutate(region = as_factor(str_remove(region, "\\sRegion$")))

# create subset of divisions
divisions <- geocodes %>%
  filter(did != "0", fips == "00") %>%
  select(did, division = name) %>%
  mutate(division = as_factor(str_remove(division, "\\sDivision$")))

# get area and location data ----------------------------------------------

tiger <- read_html("https://tigerweb.geo.census.gov/tigerwebmain/Files/acs19/tigerweb_acs19_state_us.html")
# html_node(tiger, "table") %>% html_attr("summary")
# This table containing the U.S. States - Current/ACS19 - Data as of January 1,
# 2019, gives the data (headers) for each States record (rows). For the record
# layout, please reference back to the Record Layout link on the TIGERweb
# State-Based Tabular Data Files page for the given record type.
area <- tiger %>%
  html_node("table") %>%
  html_table(header = TRUE) %>%
  as_tibble(.name_repair = "unique") %>%
  mutate(
    area = round(AREALAND/2589988, 2),
    lat = round(CENTLAT, 4),
    long = round(CENTLON, 4)
  ) %>%
  select(
    abb = STUSAB,
    area,
    lat,
    long
  )

# join data ---------------------------------------------------------------

states <- codes %>%
  left_join(geocodes, by = c("name", "fips")) %>%
  left_join(regions, by = "rid") %>%
  left_join(divisions, by = "did") %>%
  select(-rid, -did) %>%
  left_join(area, by = "abb")

# write data --------------------------------------------------------------

# save new tibble
usethis::use_data(states, overwrite = TRUE)
write_csv(states, "data-raw/states.csv")

# overwrite dataset objects
state.abb <- states$abb
class(state.abb) == class(datasets::state.abb)
usethis::use_data(state.area, overwrite = TRUE)
write_lines(state.area, "data-raw/state-abb.csv")

# overwrite datasets::state.center
state.area <- states$area
class(state.area) == class(datasets::state.area)
usethis::use_data(state.area, overwrite = TRUE)
write_lines(state.area, "data-raw/state-area.csv")

# overwrite datasets::state.center
state.center <- list(x = states$long, y = states$lat)
class(state.center) == class(datasets::state.center)
usethis::use_data(state.center, overwrite = TRUE)
write_csv(as.data.frame(state.center), "data-raw/state-center.csv")

# overwrite datasets::state.division
state.division <- states$division
class(state.division) == class(datasets::state.division)
usethis::use_data(state.division, overwrite = TRUE)
write_lines(state.division, "data-raw/state-division.csv")

# overwrite datasets::state.name
state.name <- states$name
class(state.name) == class(datasets::state.name)
usethis::use_data(state.name, overwrite = TRUE)
write_lines(state.name, "data-raw/state-name.csv")

# overwrite datasets::state.region
state.region <- states$region
class(state.region) == class(datasets::state.region)
usethis::use_data(state.region, overwrite = TRUE)
write_lines(state.region, "data-raw/state-region.csv")
