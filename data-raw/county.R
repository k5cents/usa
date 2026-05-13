## code to prepare `counties` dataset goes here
library(tidyverse)

# Census TIGER 2020 national county reference file.
# Pipe-delimited; STATEFP + COUNTYFP form the 5-digit FIPS code.
# COUNTYNAME includes a type suffix (County, Parish, Borough, etc.); strip it
# so names match the bare-name convention used throughout the package.
counties <- read_delim(
  "https://www2.census.gov/geo/docs/reference/codes2020/national_county2020.txt",
  delim = "|",
  col_types = cols_only(
    STATE      = col_character(),
    STATEFP    = col_character(),
    COUNTYFP   = col_character(),
    COUNTYNAME = col_character()
  ),
  show_col_types = FALSE
) |>
  transmute(
    fips  = paste0(STATEFP, COUNTYFP),
    name  = str_remove(COUNTYNAME, " (County|Parish|Borough|Census Area|Municipio|Municipality|city|District|Islands|Island)$"),
    state = STATE
  ) |>
  arrange(fips)

usethis::use_data(counties, overwrite = TRUE)
write_csv(counties, "data-raw/counties.csv")

county.name <- sort(unique(counties$name))
usethis::use_data(county.name, overwrite = TRUE)
write_lines(county.name, "data-raw/county.name.csv")
