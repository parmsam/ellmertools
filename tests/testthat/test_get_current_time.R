# Tests for get_current_time

test_that("get_current_time returns a string in UTC by default", {
  time_str <- get_current_time()
  expect_true(is.character(time_str))
  expect_true(grepl("UTC", time_str))
})

test_that("get_current_time returns a string in specified timezone", {
  time_str <- get_current_time("America/New_York")
  expect_true(is.character(time_str))
  expect_true(grepl("EDT|EST|America/New_York", time_str))
})
