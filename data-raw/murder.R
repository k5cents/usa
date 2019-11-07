## code to prepare `murder` dataset goes here
library(tidyverse)
library(readxl)

# https://ucr.fbi.gov/crime-in-the-u.s/2017/crime-in-the-u.s.-2017/topic-pages/tables/table-4
murder <-
  read_excel("data-raw/table-4.xls", range = "A4:G203") %>%
  fill(Area) %>%
  filter(Year == "2017") %>%
  select(
    state = Area,
    murder = 7
  ) %>%
  mutate(
    state = str_remove_all(state, "\\d"),
    murder = round(as.numeric(murder), 2)
  ) %>%
  inner_join(states) %>%
  select(fips, murder) %>%
  arrange(desc(murder))

unlink("data-raw/table-4.xls")

write_csv(
  x = murder,
  path = "data-raw/murder.csv"
)

usethis::use_data(murder, overwrite = TRUE)
