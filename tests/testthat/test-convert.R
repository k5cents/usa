library(testthat)
library(usa)

x <- c("ID", "new mexico", 2)
test_that("conversion to abbreviation", {
  y <- usa::state_convert(x, "abb")
  expect_equal(y, c("ID", "NM", "AK"))
})

test_that("conversion to abbreviation", {
  y <- usa::state_convert(x, "fips")
  expect_equal(y, c("16", "35", "02"))
})

test_that("conversion to full name", {
  y <- usa::state_convert(x, "names")
  expect_equal(y, c("Idaho", "New Mexico", "Alaska"))
})
