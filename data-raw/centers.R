## code to prepare `centers` dataset goes here
library(tidyverse)
library(magrittr)
library(rvest)

fix_coords <- function(coord) {
  coord %>%
    str_split("/") %>%
    map(`[[`, 3) %>%
    str_remove_all("\\((.*)$") %>%
    str_trim()
}

# List of geographic centers of the United States
page <- read_html("https://w.wiki/Bpr")
state_centers <- page %>%
  html_node("table.wikitable:nth-child(10)") %>%
  html_table(fill = TRUE) %>%
  as_tibble() %>%
  select(
    name = 1,
    coords = 3
  ) %>%
  mutate(coords = fix_coords(coords)) %>%
  separate(
    col = coords,
    into = c("y", "x"),
    sep = ";\\s"
  ) %>%
  mutate_at(vars(2:3), parse_number) %>%
  left_join(state_names) %>%
  select(fips, x, y)

territory_centers <- page %>%
  html_node("table.wikitable:nth-child(13)") %>%
  html_table(fill = TRUE) %>%
  as_tibble() %>%
  select(
    name = 1,
    coords = 4
  ) %>%
  filter(coords != "") %>%
  mutate(coords = fix_coords(coords)) %>%
  separate(
    col = coords,
    into = c("y", "x"),
    sep = ";\\s"
  ) %>%
  mutate_at(vars(2:3), parse_number) %>%
  left_join(state_names) %>%
  select(fips, x, y)

state_centers <- bind_rows(
  state_centers,
  territory_centers
)

state_centers <- state_centers %>%
  mutate_at(vars(x, y), round, 3)

write_csv(
  x = state_centers,
  path = "data-raw/state_centers.csv"
)

usethis::use_data(state_centers, overwrite = TRUE)

state.center <- list(
  x = state_centers$x,
  y = state_centers$y
)
usethis::use_data(state.center, overwrite = TRUE)
