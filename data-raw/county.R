## code to prepare `county` dataset goes here
library(tidyverse)
library(janitor)
library(rvest)

page <- read_html("https://www.nrcs.usda.gov/wps/portal/nrcs/detail/national/home/?cid=nrcs143_013697")
counties <- page %>%
  html_node(".data") %>%
  html_table() %>%
  as_tibble() %>%
  clean_names() %>%
  mutate_at(
    vars(fips),
    str_pad,
    width = 5,
    side = "left",
    pad = "0"
  )

# save data as tibble
usethis::use_data(counties, overwrite = TRUE)
write_csv(counties, "data-raw/counties.csv")

# save codes as vector
county.code <- counties$fips
usethis::use_data(zip.code, overwrite = TRUE)
write_lines(zip.code, "data-raw/zip.code.csv")

# save cities as vector
zip.city <- sort(unique(zipcodes$city))
usethis::use_data(zip.city, overwrite = TRUE)
write_lines(zip.city, "data-raw/zip.city.csv")

# save coordinates as vector
zip.center <- list(x = zipcodes$lat, y = zipcodes$long)
usethis::use_data(zip.center, overwrite = TRUE)
write_lines(zip.center, "data-raw/zip.center.csv")
