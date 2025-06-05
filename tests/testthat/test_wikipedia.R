# Tests for wikipedia_get_page_summary and wikipedia_get_page_html

test_that("wikipedia_get_page_summary returns a list with expected fields", {
  skip_if_offline()
  res <- wikipedia_get_page_summary("Albert Einstein")
  expect_true(is.list(res))
  expect_true(any(c("extract", "title") %in% names(res)))
})

test_that("wikipedia_get_page_html returns a markdown string", {
  skip_if_offline()
  res <- wikipedia_get_page_html("Albert Einstein")
  expect_true(is.character(res))
  expect_true(grepl("Einstein", res, ignore.case = TRUE))
})
