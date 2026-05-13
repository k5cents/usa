## code to prepare state_capitals dataset
library(tidyverse)
library(tidycensus)
library(tigris)

options(tigris_use_cache = TRUE)

# Only the state -> capital name relationship is hardcoded.
# This is static factual data that won't change.
# Population and coordinates are pulled from the Census API.
#
# match_name: Census place NAME prefix used for lookup. Differs from capital
# where the Census name diverges from the common name:
#   HI: "Urban Honolulu" (no "Honolulu city" exists; it is a CDP)
#   MN: "St. Paul" (Census abbreviates Saint -> St.)

capital_names <- tribble(
  ~abb,  ~capital,          ~match_name,
  "AL",  "Montgomery",      "Montgomery",
  "AK",  "Juneau",          "Juneau",
  "AZ",  "Phoenix",         "Phoenix",
  "AR",  "Little Rock",     "Little Rock",
  "CA",  "Sacramento",      "Sacramento",
  "CO",  "Denver",          "Denver",
  "CT",  "Hartford",        "Hartford",
  "DE",  "Dover",           "Dover",
  "FL",  "Tallahassee",     "Tallahassee",
  "GA",  "Atlanta",         "Atlanta",
  "HI",  "Honolulu",        "Urban Honolulu",
  "ID",  "Boise",           "Boise",
  "IL",  "Springfield",     "Springfield",
  "IN",  "Indianapolis",    "Indianapolis",
  "IA",  "Des Moines",      "Des Moines",
  "KS",  "Topeka",          "Topeka",
  "KY",  "Frankfort",       "Frankfort",
  "LA",  "Baton Rouge",     "Baton Rouge",
  "ME",  "Augusta",         "Augusta",
  "MD",  "Annapolis",       "Annapolis",
  "MA",  "Boston",          "Boston",
  "MI",  "Lansing",         "Lansing",
  "MN",  "Saint Paul",      "St. Paul",
  "MS",  "Jackson",         "Jackson",
  "MO",  "Jefferson City",  "Jefferson City",
  "MT",  "Helena",          "Helena",
  "NE",  "Lincoln",         "Lincoln",
  "NV",  "Carson City",     "Carson City",
  "NH",  "Concord",         "Concord",
  "NJ",  "Trenton",         "Trenton",
  "NM",  "Santa Fe",        "Santa Fe",
  "NY",  "Albany",          "Albany",
  "NC",  "Raleigh",         "Raleigh",
  "ND",  "Bismarck",        "Bismarck",
  "OH",  "Columbus",        "Columbus",
  "OK",  "Oklahoma City",   "Oklahoma City",
  "OR",  "Salem",           "Salem",
  "PA",  "Harrisburg",      "Harrisburg",
  "RI",  "Providence",      "Providence",
  "SC",  "Columbia",        "Columbia",
  "SD",  "Pierre",          "Pierre",
  "TN",  "Nashville",       "Nashville",
  "TX",  "Austin",          "Austin",
  "UT",  "Salt Lake City",  "Salt Lake City",
  "VT",  "Montpelier",      "Montpelier",
  "VA",  "Richmond",        "Richmond",
  "WA",  "Olympia",         "Olympia",
  "WV",  "Charleston",      "Charleston",
  "WI",  "Madison",         "Madison",
  "WY",  "Cheyenne",        "Cheyenne",
  "DC",  "Washington",      "Washington"
)

# Fetch place geometries and internal point coordinates from TIGER.
# tigris::places() returns INTPTLAT/INTPTLON (pre-computed internal points).
# Match on exact Census-style names (city/town/CDP/village suffix) to avoid
# ambiguous prefix matches (e.g. "Columbus Grove" vs "Columbus city").
# Sort by LSAD so incorporated cities (25) rank before CDPs (57).

match_place <- function(st, match_name) {
  # Case-insensitive prefix match; sort by LSAD then name length so that
  # incorporated cities (00/25) beat CDPs (57) and exact names beat longer ones
  # (e.g. "St. Paul city" before "St. Paul Park city").
  places(state = st, year = 2020, progress_bar = FALSE) %>%
    sf::st_drop_geometry() %>%
    filter(str_starts(tolower(NAME), tolower(match_name))) %>%
    arrange(LSAD, nchar(NAME)) %>%
    slice(1)
}

capital_geo <- map2_dfr(
  capital_names$abb,
  capital_names$match_name,
  function(st, mn) {
    match_place(st, mn) %>%
      transmute(
        abb  = st,
        lat  = round(as.numeric(INTPTLAT), 4),
        long = round(as.numeric(INTPTLON), 4)
      )
  }
)

# Fetch 2020 Decennial Census population for each capital city (place level).

capital_pop <- map2_dfr(
  capital_names$abb,
  capital_names$match_name,
  function(st, mn) {
    suffixes <- c("city", "town", "CDP", "village", "borough", "municipality")
    candidates <- c(mn, paste(mn, suffixes))
    get_decennial(
      geography = "place",
      state     = st,
      variables = "P1_001N",
      year      = 2020,
      key       = Sys.getenv("CENSUS_API_KEY")
    ) %>%
      filter(str_starts(tolower(str_remove(NAME, ",.*")), tolower(mn))) %>%
      arrange(nchar(NAME)) %>%
      slice(1) %>%
      transmute(abb = st, population = as.integer(value))
  }
)

# Join and finalise

state_capitals <- capital_names %>%
  left_join(capital_geo, by = "abb") %>%
  left_join(capital_pop, by = "abb") %>%
  select(abb, capital, lat, long, population)  # drop match_name

stopifnot(nrow(state_capitals) == 51, sum(is.na(state_capitals)) == 0)

usethis::use_data(state_capitals, overwrite = TRUE)
write_csv(state_capitals, "data-raw/state_capitals.csv")
