library(testthat)
library(state2)

test_that("Population data has 52 rows of 7 variables", {
  expect_equal(nrow(pop), 52)
  expect_equal(ncol(pop), 7)
})
