library(testthat)
library(usa)

x <- c("ID", "new mexico", 2)
test_that("conversion to abbreviation", {
  expect_equal(state_convert(x, "abb"), c("ID", "NM", "AK"))
})

test_that("conversion to abbreviation", {
  expect_equal(state_convert(x, "fips"), c("16", "35", "02"))
})

test_that("conversion to full name", {
  expect_equal(state_convert(x, "names"), c("Idaho", "New Mexico", "Alaska"))
})
