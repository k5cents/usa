## code to prepare `zipcodes` dataset goes here

library(tidyverse)
library(fs)

# download and read archives {zipcodes} package data
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
zip.code <- zipcodes$zip
usethis::use_data(zip.code, overwrite = TRUE)
write_lines(zip.code, "data-raw/zip.code.csv")

# save coordinates as vector
zip.center <- list(x = zipcodes$lat, y = zipcodes$long)
usethis::use_data(zip.center, overwrite = TRUE)
write_lines(zip.center, "data-raw/zip.center.csv")

# save cities as vector
city.name <- sort(unique(zipcodes$city))
usethis::use_data(city.name, overwrite = TRUE)
write_lines(city.name, "data-raw/city.name.csv")
