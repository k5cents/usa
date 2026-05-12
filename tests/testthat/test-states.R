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

test_that("underscore vectors have 52 entries", {
  expect_length(state_abbs, 52)
  expect_length(state_names, 52)
  expect_length(state_areas, 52)
  expect_length(state_divisions, 52)
  expect_length(state_regions, 52)
  expect_length(state_centers$x, 52)
  expect_length(state_centers$y, 52)
})

test_that("underscore vectors cover DC and PR beyond base R", {
  expect_true("DC" %in% state_abbs)
  expect_true("PR" %in% state_abbs)
  expect_true("District of Columbia" %in% state_names)
  expect_true("Puerto Rico" %in% state_names)
})

test_that("territory vectors have correct length", {
  expect_length(territory_abbs, 5)
  expect_length(territory_names, 5)
  expect_length(territory_areas, 5)
  expect_length(territory_centers$x, 5)
})

test_that("dot-notation objects are NOT exported", {
  expect_false("state.abb" %in% ls("package:usa"))
  expect_false("state.name" %in% ls("package:usa"))
})
