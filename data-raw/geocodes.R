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
  )

# create subset of regions
regions <- geocodes %>%
  filter(div_id == "0") %>%
  select(reg_id, region = name) %>%
  mutate(region = str_remove(region, "\\sRegion$"))

# create subset of divisions
divisions <- geocodes %>%
  filter(div_id != "0", fips == "00") %>%
  select(div_id, division = name) %>%
  mutate(division = str_remove(division, "\\sDivision$"))

# create subset of states
fips <- geocodes %>%
  filter(div_id != "0", fips != "00") %>%
  rename(state = name) %>%
  arrange(fips)

# test that all join back
fips %>%
  left_join(regions) %>%
  left_join(divisions)

# write raw csv
write_csv(regions, "data-raw/regions.csv")
write_csv(divisions, "data-raw/divisions.csv")
write_csv(fips, "data-raw/fips.csv")

# write object rda
use_data(regions)
use_data(divisions)
use_data(fips)
