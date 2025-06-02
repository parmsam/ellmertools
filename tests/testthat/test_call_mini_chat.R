test_that("call_mini_chat returns a string", {
  skip_if_offline()
  res <- call_mini_chat("Say hello!")
  expect_true(is.character(res))
  expect_true(grepl("hello", tolower(res)))
})
