library(tidyverse)
library(vroom)

allstations <- read_fwf(
  file = "ftp://ftp.ncdc.noaa.gov/pub/data/normals/1981-2010/station-inventories/allstations.txt",
  col_positions = fwf_cols(
    id = c(1, 11),
    lat = c(13, 20),
    long = c(22, 30),
    elev = c(32, 37),
    state = c(39, 40),
    name = c(42, 71),
    gsn = c(73, 75),
    hsn = c(77, 79),
    wmoid = c(81, 85),
    method = c(87, 99)
  )
)

# annual cooling degree days
degree_days <- read_fwf(
  file = "ftp://ftp.ncdc.noaa.gov/pub/data/normals/1981-2010/products/temperature/ann-cldd-normal.txt",
  col_positions = fwf_cols(
    id = c(1, 11),
    days = c(19, 23),
    flag = c(24)
  )
)

years <- 2010 - 1981

degree_days %>%
  left_join(allstations, by = "id") %>%
  group_by(state) %>%
  summarise(mean = mean(days)/years) %>%
  arrange(desc(mean)) %>%
  left_join(abbs, by = c("state" = "abb"))
