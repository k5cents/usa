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

# save counties as vector
county.name <- sort(unique(counties$name))
usethis::use_data(county.name, overwrite = TRUE)
write_lines(county.name, "data-raw/county.name.csv")
