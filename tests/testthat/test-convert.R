library(testthat)
library(usa)

x <- c("ID", "new mexico", 2)

test_that("conversion to abbreviation", {
  y <- usa::state_convert(x, "abb")
  expect_equal(y, c("ID", "NM", "AK"))
})

test_that("conversion to fips", {
  y <- usa::state_convert(x, "fips")
  expect_equal(y, c("16", "35", "02"))
})

test_that("conversion to full name", {
  y <- usa::state_convert(x, "name")
  expect_equal(y, c("Idaho", "New Mexico", "Alaska"))
})

test_that("conversion to AP abbreviation", {
  y <- usa::state_convert(x, "ap")
  expect_equal(y, c("Idaho", "N.M.", "Alaska"))  # Idaho and Alaska use full name per AP style
})

test_that("conversion to ISO 3166-2", {
  y <- usa::state_convert(x, "iso")
  expect_equal(y, c("US-ID", "US-NM", "US-AK"))
})

test_that("AP abbreviations round-trip back to abb", {
  ap_vec <- c("Ala.", "N.H.", "W.Va.")
  y <- usa::state_convert(ap_vec, "abb")
  expect_equal(y, c("AL", "NH", "WV"))
})

test_that("ISO codes round-trip back to name", {
  iso_vec <- c("US-CA", "US-TX", "US-NY")
  y <- usa::state_convert(iso_vec, "name")
  expect_equal(y, c("California", "Texas", "New York"))
})
