## code to prepare `literacy` dataset goes here
library(tidyverse)

# https://nces.ed.gov/naal/estimates/StateEstimates.aspx
literacy <-
  read_csv("data-raw/ExportedData.csv") %>%
  select(
    fips = `FIPS code`,
    literacy = `Prose literacy skills`
  ) %>%
  mutate(
    fips = str_sub(str_pad(fips, width = 5, pad = "0"), end = 2),
    literacy = round(literacy/100, 4)
  ) %>%
  arrange(desc(literacy))

unlink("data-raw/ExportedData.csv")

write_csv(
  x = literacy,
  path = "data-raw/literacy.csv"
)

usethis::use_data(literacy, overwrite = TRUE)
