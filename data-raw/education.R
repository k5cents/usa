## code to prepare `education` dataset goes here
library(tidyverse)
library(magrittr)
library(rvest)

# List of U.S. states and territories by area
education <-
  read_html("https://w.wiki/Bd$") %>%
  html_node(".wikitable") %>%
  html_table(fill = TRUE, header = FALSE) %>%
  slice(-(1:2)) %>%
  as_tibble() %>%
  select(
    name = X1,
    high = X2,
    bach = X4,
    grad = X6
  ) %>%
  mutate_at(
    .vars = c(2:4),
    .funs = function(x) parse_number(x)/100
  ) %>%
  inner_join(state_names) %>%
  select(fips, high, bach, grad) %>%
  arrange(desc(high))

write_csv(
  x = education,
  path = "data-raw/education.csv"
)
