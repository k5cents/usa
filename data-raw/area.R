## code to prepare `area` dataset goes here
library(tidyverse)
library(magrittr)
library(rvest)

# List of U.S. states and territories by area
areas <-
  read_html("https://w.wiki/Bdw") %>%
  html_node(".wikitable") %>%
  html_table(fill = TRUE, header = FALSE) %>%
  slice(-(1:2), -c(59:62)) %>%
  as_tibble() %>%
  select(
    state = X1,
    area = X3,
    land = X8
  ) %>%
  mutate(
    area = parse_number(area) %>% round(2),
    land = parse_number(land) %>% divide_by(100) %>% round(4)
  ) %>%
  inner_join(states, by = "state") %>%
  select(fips, area, land) %>%
  arrange(desc(area))

write_csv(
  x = areas,
  path = "data-raw/areas.csv"
)

usethis::use_data(areas, overwrite = TRUE)
