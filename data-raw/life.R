## code to prepare `life` dataset goes here
library(tidyverse)
library(rvest)

# List of U.S. states and territories by area
life <-
  read_html("https://w.wiki/BeA") %>%
  html_node(".wikitable") %>%
  html_table(fill = TRUE, header = FALSE) %>%
  na_if("") %>%
  slice(-(1)) %>%
  as_tibble() %>%
  filter(!is.na(X1)) %>%
  select(
    name = X2,
    life = X3
  ) %>%
  mutate_at(vars(life), parse_number) %>%
  inner_join(state_names) %>%
  select(fips, life) %>%
  arrange(desc(life))

write_csv(
  x = life,
  path = "data-raw/life.csv"
)
