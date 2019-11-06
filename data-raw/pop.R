## code to prepare `state2` dataset goes here
## https://www2.census.gov/programs-surveys/popest/tables/2010-2018/state/totals/nst-est2018-01.xlsx

library(tidyverse)

url <- "https://www2.census.gov/programs-surveys/popest/datasets/2010-2018/state/detail/SCPRC-EST2018-18+POP-RES.csv"
pop <- read_csv(
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

pop <- pop %>%
  select(
    sumlev = SUMLEV,
    region = REGION,
    division = DIVISION,
    fips = STATE,
    state = NAME,
    pop = POPESTIMATE2018,
    adult = PCNT_POPEST18PLUS
  ) %>%
  filter(fips != "00") %>%
  mutate(adult = adult/100)

write_csv(
  x = pop,
  path = "data-raw/pop.csv"
)

usethis::use_data(pop, overwrite = TRUE)
