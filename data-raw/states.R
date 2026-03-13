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
# TIGER REST API: land area, water area, and centroids
# Areas in response are square meters; convert to square miles (/2589988)

tiger_url <- paste0(
  "https://tigerweb.geo.census.gov/arcgis/rest/services/TIGERweb/",
  "State_County/MapServer/0/query",
  "?where=1%3D1&outFields=STUSAB,AREALAND,AREAWATER,CENTLAT,CENTLON",
  "&returnGeometry=false&f=json&resultRecordCount=60"
)
tiger_raw <- jsonlite::fromJSON(tiger_url)
area <- as_tibble(tiger_raw$features$attributes) %>%
  mutate(
    area_land  = round(as.numeric(AREALAND)  / 2589988, 2),
    area_water = round(as.numeric(AREAWATER) / 2589988, 2),
    lat        = round(as.numeric(CENTLAT), 4),
    long       = round(as.numeric(CENTLON), 4)
  ) %>%
  select(abb = STUSAB, area_land, area_water, lat, long)

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

# IPUMS ICP codes ---------------------------------------------------------
# STATEICP codes from IPUMS USA: https://usa.ipums.org/usa-action/variables/STATEICP
# Stored as zero-padded 2-digit strings, parallel to fips.

icp_codes <- tribble(
  ~name,                  ~icp,
  "Connecticut",          "01",
  "Maine",                "02",
  "Massachusetts",        "03",
  "New Hampshire",        "04",
  "Rhode Island",         "05",
  "Vermont",              "06",
  "Delaware",             "11",
  "New Jersey",           "12",
  "New York",             "13",
  "Pennsylvania",         "14",
  "Illinois",             "21",
  "Indiana",              "22",
  "Michigan",             "23",
  "Ohio",                 "24",
  "Wisconsin",            "25",
  "Iowa",                 "31",
  "Kansas",               "32",
  "Minnesota",            "33",
  "Missouri",             "34",
  "Nebraska",             "35",
  "North Dakota",         "36",
  "South Dakota",         "37",
  "Virginia",             "40",
  "Alabama",              "41",
  "Arkansas",             "42",
  "Florida",              "43",
  "Georgia",              "44",
  "Louisiana",            "45",
  "Mississippi",          "46",
  "North Carolina",       "47",
  "South Carolina",       "48",
  "Texas",                "49",
  "Kentucky",             "51",
  "Maryland",             "52",
  "Oklahoma",             "53",
  "Tennessee",            "54",
  "West Virginia",        "56",
  "Arizona",              "61",
  "Colorado",             "62",
  "Idaho",                "63",
  "Montana",              "64",
  "Nevada",               "65",
  "New Mexico",           "66",
  "Utah",                 "67",
  "Wyoming",              "68",
  "California",           "71",
  "Oregon",               "72",
  "Washington",           "73",
  "Alaska",               "81",
  "Hawaii",               "82",
  "Puerto Rico",          "83",
  "District of Columbia", "98"
)

# state_ids ---------------------------------------------------------------
# All naming/coding systems for each state.
# ISO 3166-2 is simply "US-" + USPS abbreviation for all entries.

state_ids <- all_states %>%
  select(name, abb, fips) %>%
  left_join(ap_abbrevs, by = "name") %>%
  mutate(iso = paste0("US-", abb)) %>%
  left_join(icp_codes, by = "name") %>%
  select(name, abb, fips, icp, ap, iso)

usethis::use_data(state_ids, overwrite = TRUE)
write_csv(state_ids, "data-raw/state_ids.csv")

# state_geo ---------------------------------------------------------------
# Geographic and classificatory properties for each state.
# Keyed by abb to join with state_ids.

# Peak elevations in feet (USGS / state high point records)
peak_elev <- tribble(
  ~abb, ~peak_elev,
  "AL",  2405L,
  "AK", 20237L,
  "AZ", 12633L,
  "AR",  2753L,
  "CA", 14494L,
  "CO", 14433L,
  "CT",  2380L,
  "DE",   448L,
  "FL",   345L,
  "GA",  4784L,
  "HI", 13796L,
  "ID", 12662L,
  "IL",  1235L,
  "IN",  1257L,
  "IA",  1670L,
  "KS",  4039L,
  "KY",  4139L,
  "LA",   535L,
  "ME",  5267L,
  "MD",  3360L,
  "MA",  3487L,
  "MI",  1979L,
  "MN",  2301L,
  "MS",   806L,
  "MO",  1772L,
  "MT", 12799L,
  "NE",  5424L,
  "NV", 13140L,
  "NH",  6288L,
  "NJ",  1803L,
  "NM", 13161L,
  "NY",  5344L,
  "NC",  6684L,
  "ND",  3506L,
  "OH",  1549L,
  "OK",  4973L,
  "OR", 11239L,
  "PA",  3213L,
  "RI",   812L,
  "SC",  3560L,
  "SD",  7242L,
  "TN",  6643L,
  "TX",  8749L,
  "UT", 13528L,
  "VT",  4393L,
  "VA",  5729L,
  "WA", 14410L,
  "WV",  4861L,
  "WI",  1951L,
  "WY", 13804L,
  "DC",   409L,
  "PR",  4390L
)

# Landlocked: no coastline on an ocean, gulf, or Great Lake.
# Great Lakes states (not landlocked): IL, IN, MI, MN, NY, OH, PA, WI
landlocked_abbs <- c(
  "AZ", "AR", "CO", "DC", "ID", "IA", "KS", "KY", "MO", "MT",
  "NE", "NV", "NM", "ND", "OK", "SD", "TN", "UT", "VT", "WV", "WY"
)

state_geo <- all_states %>%
  select(abb, region, division, area_land, area_water, lat, long) %>%
  mutate(
    contiguous = !abb %in% c("AK", "HI", "PR"),
    landlocked = abb %in% landlocked_abbs
  ) %>%
  left_join(peak_elev, by = "abb") %>%
  select(abb, region, division, area_land, area_water, lat, long,
         contiguous, landlocked, peak_elev)

usethis::use_data(state_geo, overwrite = TRUE)
write_csv(state_geo, "data-raw/state_geo.csv")

# legacy dot-notation vectors ---------------------------------------------
# These overwrite datasets::state.* on library(usa) for backwards compat.
# They are derived from state_ids / state_geo for the 52 rows.

state.abb <- state_ids$abb
class(state.abb) == class(datasets::state.abb)
usethis::use_data(state.abb, overwrite = TRUE)
write_lines(state.abb, "data-raw/state-abb.csv")

state.area <- state_geo$area_land
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
