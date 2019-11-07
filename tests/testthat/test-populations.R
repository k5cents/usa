library(testthat)
library(state2)

test_that("Population data has 52 rows of 7 variables", {
  expect_equal(nrow(populations), 52)
  expect_equal(ncol(populations), 4)
})
