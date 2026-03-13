## code to prepare various state datasets goes here
library(tidyverse)
library(readxl)
library(rvest)
library(fs)

# get state id codes ------------------------------------------------------

# read various census codes
codes <- read_delim(
  file = "https://www2.census.gov/geo/docs/reference/state.txt",
  delim = "|"
)

# reorder and rename
codes <- codes %>%
  select(
    name = STATE_NAME,
    abb = STUSAB,
    fips = STATE
  )

# AP style abbreviations --------------------------------------------------
# 8 states have no AP abbreviation (Alaska, Hawaii, Idaho, Iowa, Maine, Ohio,
# Texas, Utah) — use NA for these.
# Source: AP Stylebook state abbreviations

ap_abbrevs <- tribble(
  ~name,                  ~ap,
  "Alabama",              "Ala.",
  "Alaska",               "Alaska",
  "Arizona",              "Ariz.",
  "Arkansas",             "Ark.",
  "California",           "Calif.",
  "Colorado",             "Colo.",
  "Connecticut",          "Conn.",
  "Delaware",             "Del.",
  "District of Columbia", "D.C.",
  "Florida",              "Fla.",
  "Georgia",              "Ga.",
  "Hawaii",               "Hawaii",
  "Idaho",                "Idaho",
  "Illinois",             "Ill.",
  "Indiana",              "Ind.",
  "Iowa",                 "Iowa",
  "Kansas",               "Kan.",
  "Kentucky",             "Ky.",
  "Louisiana",            "La.",
  "Maine",                "Maine",
  "Maryland",             "Md.",
  "Massachusetts",        "Mass.",
  "Michigan",             "Mich.",
  "Minnesota",            "Minn.",
  "Mississippi",          "Miss.",
  "Missouri",             "Mo.",
  "Montana",              "Mont.",
  "Nebraska",             "Neb.",
  "Nevada",               "Nev.",
  "New Hampshire",        "N.H.",
  "New Jersey",           "N.J.",
  "New Mexico",           "N.M.",
  "New York",             "N.Y.",
  "North Carolina",       "N.C.",
  "North Dakota",         "N.D.",
  "Ohio",                 "Ohio",
  "Oklahoma",             "Okla.",
  "Oregon",               "Ore.",
  "Pennsylvania",         "Pa.",
  "Puerto Rico",          "P.R.",
  "Rhode Island",         "R.I.",
  "South Carolina",       "S.C.",
  "South Dakota",         "S.D.",
  "Tennessee",            "Tenn.",
  "Texas",                "Texas",
  "Utah",                 "Utah",
  "Vermont",              "Vt.",
  "Virginia",             "Va.",
  "Washington",           "Wash.",
  "West Virginia",        "W.Va.",
  "Wisconsin",            "Wis.",
  "Wyoming",              "Wyo."
)

# get geography codes -----------------------------------------------------

# download census region file
geo_url <- "https://www2.census.gov/programs-surveys/popest/geographies/2018/state-geocodes-v2018.xlsx"
geo_path <- path_temp(basename(geo_url))
download.file(geo_url, geo_path)

# read region sheet range
geocodes <- read_excel(
  path = geo_path,
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
area <- tiger %>%
  html_node("table") %>%
  html_table(header = TRUE) %>%
  as_tibble(.name_repair = "unique") %>%
  mutate(
    area = round(AREALAND / 2589988, 2),
    lat  = round(CENTLAT, 4),
    long = round(CENTLON, 4)
  ) %>%
  select(abb = STUSAB, area, lat, long)

# build full joined table -------------------------------------------------

all_states <- codes %>%
  left_join(geocodes, by = c("name", "fips")) %>%
  left_join(regions, by = "rid") %>%
  left_join(divisions, by = "did") %>%
  select(-rid, -did) %>%
  left_join(area, by = "abb") %>%
  arrange(name)

# filter to the 52 (50 states + DC + PR)
all_states <- all_states %>%
  filter(name %in% c(datasets::state.name, "District of Columbia", "Puerto Rico"))

# state_ids ---------------------------------------------------------------
# All naming/coding systems for each state.
# ISO 3166-2 is simply "US-" + USPS abbreviation for all entries.

state_ids <- all_states %>%
  select(name, abb, fips) %>%
  left_join(ap_abbrevs, by = "name") %>%
  mutate(iso = paste0("US-", abb)) %>%
  select(name, abb, fips, ap, iso)

usethis::use_data(state_ids, overwrite = TRUE)
write_csv(state_ids, "data-raw/state_ids.csv")

# state_geo ---------------------------------------------------------------
# Geographic and classificatory properties for each state.
# Keyed by abb to join with state_ids.

state_geo <- all_states %>%
  select(abb, region, division, area, lat, long)

usethis::use_data(state_geo, overwrite = TRUE)
write_csv(state_geo, "data-raw/state_geo.csv")

# legacy dot-notation vectors ---------------------------------------------
# These overwrite datasets::state.* on library(usa) for backwards compat.
# They are derived from state_ids / state_geo for the 52 rows.

state.abb <- state_ids$abb
class(state.abb) == class(datasets::state.abb)
usethis::use_data(state.abb, overwrite = TRUE)
write_lines(state.abb, "data-raw/state-abb.csv")

state.area <- state_geo$area
class(state.area) == class(datasets::state.area)
usethis::use_data(state.area, overwrite = TRUE)
write_lines(state.area, "data-raw/state-area.csv")

state.center <- list(x = state_geo$long, y = state_geo$lat)
class(state.center) == class(datasets::state.center)
usethis::use_data(state.center, overwrite = TRUE)
write_csv(as.data.frame(state.center), "data-raw/state-center.csv")

state.division <- state_geo$division
class(state.division) == class(datasets::state.division)
usethis::use_data(state.division, overwrite = TRUE)
write_lines(state.division, "data-raw/state-division.csv")

state.name <- state_ids$name
class(state.name) == class(datasets::state.name)
usethis::use_data(state.name, overwrite = TRUE)
write_lines(state.name, "data-raw/state-name.csv")

state.region <- state_geo$region
class(state.region) == class(datasets::state.region)
usethis::use_data(state.region, overwrite = TRUE)
write_lines(state.region, "data-raw/state-region.csv")

# territory data ----------------------------------------------------------

territory <- codes %>%
  left_join(area, by = "abb") %>%
  filter(!(name %in% c(datasets::state.name, "District of Columbia", "Puerto Rico"))) %>%
  arrange(name)

usethis::use_data(territory, overwrite = TRUE)
write_csv(territory, "data-raw/territory.csv")

territory.abb <- territory$abb
usethis::use_data(territory.abb, overwrite = TRUE)
write_lines(territory.abb, "data-raw/territory-abb.csv")

territory.area <- territory$area
usethis::use_data(territory.area, overwrite = TRUE)
write_lines(territory.area, "data-raw/territory-area.csv")

territory.center <- list(x = territory$long, y = territory$lat)
usethis::use_data(territory.center, overwrite = TRUE)
write_csv(as.data.frame(territory.center), "data-raw/territory-center.csv")

territory.name <- territory$name
usethis::use_data(territory.name, overwrite = TRUE)
write_lines(territory.name, "data-raw/territory-name.csv")
