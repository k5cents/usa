library(testthat)
library(usa)

test_that("underscore vectors have correct classes", {
  expect_type(state_abbs, "character")
  expect_type(state_names, "character")
  expect_type(state_areas, "double")
  expect_s3_class(state_divisions, "factor")
  expect_s3_class(state_regions, "factor")
  expect_type(state_centers, "list")
  expect_named(state_centers, c("x", "y"))
})

test_that("underscore vectors have 51 entries (50 states + DC)", {
  expect_length(state_abbs, 51)
  expect_length(state_names, 51)
  expect_length(state_areas, 51)
  expect_length(state_divisions, 51)
  expect_length(state_regions, 51)
  expect_length(state_centers$x, 51)
  expect_length(state_centers$y, 51)
})

test_that("underscore vectors cover DC but not PR", {
  expect_true("DC" %in% state_abbs)
  expect_false("PR" %in% state_abbs)
  expect_true("District of Columbia" %in% state_names)
  expect_false("Puerto Rico" %in% state_names)
})

test_that("territory vectors have correct length (6: AS, GU, MP, PR, UM, VI)", {
  expect_length(territory_abbs, 6)
  expect_length(territory_names, 6)
  expect_length(territory_areas, 6)
  expect_length(territory_centers$x, 6)
})

test_that("PR is in territory vectors", {
  expect_true("PR" %in% territory_abbs)
  expect_true("Puerto Rico" %in% territory_names)
})

test_that("dot-notation objects are NOT exported", {
  expect_false("state.abb" %in% ls("package:usa"))
  expect_false("state.name" %in% ls("package:usa"))
})
