library(testthat)
library(usa)

expect_same_class <- function(object, expected) {
  expect_equal(class(object), class(expected))
}

test_that("new objects share class type with old data", {
  expect_same_class(usa::state.abb, datasets::state.abb)
  expect_same_class(usa::state.area, datasets::state.area)
  expect_same_class(usa::state.center, datasets::state.center)
  expect_same_class(usa::state.division, datasets::state.division)
  expect_same_class(usa::state.name, datasets::state.name)
  expect_same_class(usa::state.region, datasets::state.region)
})

detach("package:usa", unload = TRUE)
test_that("package produces custom message on attach", {
  expect_message(library(usa))
})
