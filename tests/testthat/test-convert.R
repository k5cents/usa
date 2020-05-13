library(testthat)
library(usa)

x <- c("ID", "Vermont", 6)
test_that("conversion to abbreviation", {
  expect_equal(state_convert(x, "abb"), c("ID", "VT", "CA"))
})

test_that("conversion to abbreviation", {
  expect_equal(state_convert(x, "fips"), c("16", "50", "06"))
})

test_that("conversion to full name", {
  expect_equal(state_convert(x, "names"), c("Idaho", "Vermont", "California"))
})
