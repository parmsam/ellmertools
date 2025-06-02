# Tests for get_current_forecast and get_current_temperature

test_that("get_current_forecast returns a tibble for valid input", {
  skip_if_offline()
  res <- get_current_forecast(40.886, -81.416)
  expect_true(tibble::is_tibble(res))
  expect_true(all(c("time", "temp_F", "rain_prob", "forecast") %in% names(res)))
})

test_that("get_current_forecast errors for invalid input", {
  skip_if_offline()
  expect_error(get_current_forecast("not_a_number", -81.416))
  expect_error(get_current_forecast(40.886, "not_a_number"))
})

test_that("get_current_temperature returns a list for valid input", {
  skip_if_offline()
  res <- get_current_temperature(40.886, -81.416)
  expect_true(is.list(res))
  expect_true("temperature_2m" %in% names(res) || "temperature" %in% names(res))
})

test_that("get_current_temperature errors for invalid input", {
  skip_if_offline()
  expect_error(get_current_temperature("not_a_number", -81.416))
  expect_error(get_current_temperature(40.886, "not_a_number"))
})
