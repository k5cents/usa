library(tidyverse)
library(janitor)
library(readxl)
library(fs)

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
  rename(
    rid = region,
    did = division,
    fips = state_fips
  ) %>%
  add_row(
    fips = "72",
    name = "Puerto Rico Commonwealth"
  )

# create subset of regions
regions <- geocodes %>%
  filter(did == "0") %>%
  select(rid, region = name) %>%
  mutate(region = as_factor(str_remove(region, "\\sRegion$")))

# create subset of divisions
divisions <- geocodes %>%
  filter(did != "0", fips == "00") %>%
  select(did, division = name) %>%
  mutate(division = as_factor(str_remove(division, "\\sDivision$")))

# create subset of fips
fips <- geocodes %>%
  filter(fips != "00") %>%
  select(-name)

# read abbreviations
codes <- read_delim(
  file = "https://www2.census.gov/geo/docs/reference/state.txt",
  delim = "|"
)

# create abbs from codes
abbs <- select(codes, fips = STATE, abb = STUSAB)

# create names from codes
states <- select(codes, fips = STATE, state = STATE_NAME)

# create ansi from codes
ansi <- select(codes, fips = STATE, ansi = STATENS)

# test that all join back
states %>%
  inner_join(abbs) %>%
  inner_join(fips) %>%
  left_join(regions) %>%
  left_join(divisions) %>%
  inner_join(ansi) %>%
  select(-ends_with("id"))

# write raw csv
write_csv(regions, "data-raw/regions.csv")
write_csv(divisions, "data-raw/divisions.csv")
write_csv(states, "data-raw/states.csv")
write_csv(fips, "data-raw/fips.csv")
write_csv(abbs, "data-raw/abbs.csv")
write_csv(ansi, "data-raw/ansi.csv")

# write object rda
use_data(regions, overwrite = TRUE)
use_data(divisions, overwrite = TRUE)
use_data(states, overwrite = TRUE)
use_data(fips, overwrite = TRUE)
use_data(abbs, overwrite = TRUE)
use_data(ansi, overwrite = TRUE)

# overwrite vectors
state.name <- states$state
usethis::use_data(state.name, overwrite = TRUE)

state.abb <- abbs$abb
usethis::use_data(state.abb, overwrite = TRUE)

state.division <- divisions$division
usethis::use_data(state.division, overwrite = TRUE)

state.region <- regions$region
usethis::use_data(state.region, overwrite = TRUE)
