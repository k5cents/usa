library(tidyverse)
library(janitor)
library(readxl)
library(fs)

# Get Census Bureau Regions and Divisions by FIPS -------------------------

# download USCB geocodes file
download.file(
  url = "https://www2.census.gov/programs-surveys/popest/geographies/2018/state-geocodes-v2018.xlsx",
  destfile = "data-raw/state-geocodes-v2018.xlsx"
)

# read sheet range
geocodes <- read_excel(
  path = "data-raw/state-geocodes-v2018.xlsx",
  range = "A6:D70",
  .name_repair = make_clean_names
)

# delete the USCB file
file_delete("data-raw/state-geocodes-v2018.xlsx")

# rename for split
geocodes <- geocodes %>%
  select(
    fips = state_fips,
    name,
    rid = region,
    did = division
  )

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

# add regions to fips
# replaces `state.region` factor vector
state_regions <- geocodes %>%
  filter(fips != "00") %>%
  left_join(regions) %>%
  select(fips, region) %>%
  arrange(fips)

# add divisions to fips
# replaces `state.division` factor vector
state_divisions <- geocodes %>%
  filter(fips != "00") %>%
  left_join(divisions) %>%
  select(fips, division) %>%
  arrange(fips)

# read various USCB codes
codes <- read_delim(
  file = "https://www2.census.gov/geo/docs/reference/state.txt",
  delim = "|"
)

# create abbs from codes
# replaces `state.abb` character vector
state_abbs <- select(codes, fips = STATE, abb = STUSAB)

# create names from codes
# replaces `state.name` character vector
state_names <- select(codes, fips = STATE, name = STATE_NAME)

# create ansi from codes
state_ansi <- select(codes, fips = STATE, ansi = STATENS)

# test that all join back
state_names %>%
  inner_join(state_abbs) %>%
  inner_join(state_ansi) %>%
  left_join(state_regions) %>%
  left_join(state_divisions) %>%
  left_join(state_centers) -> states

# write raw csv
write_csv(states,          "data-raw/states.csv")
write_csv(state_regions,   "data-raw/state_regions.csv")
write_csv(state_divisions, "data-raw/state_divisions.csv")
write_csv(state_names,     "data-raw/state_names.csv")
write_csv(state_abbs,      "data-raw/state_abbs.csv")
write_csv(state_ansi,      "data-raw/state_ansi.csv")

# write object rda
use_data(states,          overwrite = TRUE)
use_data(state_regions,   overwrite = TRUE)
use_data(state_divisions, overwrite = TRUE)
use_data(state_names,     overwrite = TRUE)
use_data(state_abbs,      overwrite = TRUE)
use_data(state_ansi,      overwrite = TRUE)

# overwrite vectors
state.name <- state_names$name
usethis::use_data(state.name, overwrite = TRUE)

state.abb <- state_abbs$abb
usethis::use_data(state.abb, overwrite = TRUE)

state.division <- state_divisions$division
usethis::use_data(state.division, overwrite = TRUE)

state.region <- state_regions$region
usethis::use_data(state.region, overwrite = TRUE)
