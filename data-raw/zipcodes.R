## code to prepare `zipcodes` dataset goes here

library(tidyverse)
library(fs)

# download and read archives {zipcode} package data
zip_url <- "https://cran.r-project.org/src/contrib/Archive/zipcode/zipcode_1.0.tar.gz"
zip_file <- file_temp(ext = ".tar.gz")
download.file(zip_url, zip_file)
untar(zip_file, exdir = path_temp())
load(file = path_temp("zipcode/data/zipcode.rda"))

# rename as tibble
zipcodes <-
  as_tibble(zipcode) %>%
  rename(
    lat = latitude,
    long = longitude
  )


# save data as tibble
usethis::use_data(zipcodes, overwrite = TRUE)
write_csv(zipcodes, "data-raw/zipcodes.csv")

# save codes as vector
zip_codes <- zipcodes$zip
usethis::use_data(zip_codes, overwrite = TRUE)
write_lines(zip_codes, "data-raw/zip_codes.csv")

# save coordinates as vector
zip_centers <- list(x = zipcodes$lat, y = zipcodes$long)
usethis::use_data(zip_centers, overwrite = TRUE)
write_lines(zip_centers, "data-raw/zip_centers.csv")

# save cities as vector
city_names <- sort(unique(zipcodes$city))
usethis::use_data(city_names, overwrite = TRUE)
write_lines(city_names, "data-raw/city_names.csv")
