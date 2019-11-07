## code to prepare `populations` dataset goes here
## https://www2.census.gov/programs-surveys/popest/tables/2010-2018/state/totals/nst-est2018-01.xlsx

library(tidyverse)

url <- "https://www2.census.gov/programs-surveys/popest/datasets/2010-2018/state/detail/SCPRC-EST2018-18+POP-RES.csv"
populations <- read_csv(
  file = url,
  na = "X",
  col_types = cols(
    SUMLEV = col_character(),
    REGION = col_character(),
    DIVISION = col_character(),
    STATE = col_character(),
    NAME = col_character(),
    POPESTIMATE2018 = col_double(),
    POPEST18PLUS2018 = col_double(),
    PCNT_POPEST18PLUS = col_double()
  )
)

populations <- populations %>%
  select(
    fips = STATE,
    state = NAME,
    population = POPESTIMATE2018,
    adult = PCNT_POPEST18PLUS
  ) %>%
  filter(fips != "00") %>%
  mutate(adult = round(adult/100, digits = 3)) %>%
  arrange(desc(population))

write_csv(
  x = populations,
  path = "data-raw/populations.csv"
)

use_data(populations, overwrite = TRUE)
