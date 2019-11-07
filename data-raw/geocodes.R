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
    reg_id = region,
    div_id = division,
    fips = state_fips
  ) %>%
  add_row(
    fips = "72",
    name = "Puerto Rico Commonwealth"
  )

# create subset of regions
regions <- geocodes %>%
  filter(div_id == "0") %>%
  select(reg_id, region = name) %>%
  mutate(region = as_factor(str_remove(region, "\\sRegion$")))

# create subset of divisions
divisions <- geocodes %>%
  filter(div_id != "0", fips == "00") %>%
  select(div_id, division = name) %>%
  mutate(division = as_factor(str_remove(division, "\\sDivision$")))

# create subset of states
states <- geocodes %>%
  filter(fips != "00") %>%
  rename(state = name) %>%
  arrange(fips)

# read abbreviations
abbs <- read_delim(
  file = "https://www2.census.gov/geo/docs/reference/state.txt",
  delim = "|"
)

# rename abbs for consistency
abbs <- abbs %>%
  rename(
    fips = STATE,
    abb = STUSAB,
    state = STATE_NAME,
    ansi = STATENS
  )

# join abbs to states
states <- left_join(states, abbs, by = c("fips", "state"))

# test that all join back
states %>%
  left_join(regions) %>%
  left_join(divisions)

# write raw csv
write_csv(regions, "data-raw/regions.csv")
write_csv(divisions, "data-raw/divisions.csv")
write_csv(states, "data-raw/fips.csv")

# write object rda
use_data(regions, overwrite = TRUE)
use_data(divisions, overwrite = TRUE)
use_data(states, overwrite = TRUE)
