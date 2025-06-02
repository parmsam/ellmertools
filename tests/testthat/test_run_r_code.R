test_that("run_r_code evaluates code and returns result", {
  expect_equal(run_r_code("1 + 1"), 2)
  expect_equal(run_r_code("mean(1:4)"), 2.5)
})

test_that("run_r_code returns error message on failure", {
  res <- run_r_code("stop('fail!')")
  expect_true(grepl("Error: fail!", res))
})