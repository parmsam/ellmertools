test_that("pluck_existing_fields returns only present fields", {
  x <- list(a = 1, b = 2)
  expect_equal(pluck_existing_fields(x, c("a", "b", "c")), list(a = 1, b = 2))
  expect_equal(names(pluck_existing_fields(x, c("a", "c"))), "a")
})

test_that("get_current_location returns a list with lat/lon fields from ipinfo.io", {
  skip_if_offline()
  res <- get_current_location()
  expect_true(is.list(res))
  expect_true(any(c("lat", "lon", "loc") %in% names(res)))
})