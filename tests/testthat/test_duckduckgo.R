# Tests for DuckDuckGoSearch R6 class search functions

test_that("DuckDuckGoSearch$search_text_html returns results for a simple query", {
  skip_if_offline()
  dds <- DuckDuckGoSearch$new()
  res <- dds$search_text_html("R programming")
  expect_true(is.list(res))
  if (length(res) > 0) {
    expect_true(all(c("title", "href", "body") %in% names(res[[1]])))
  }
})

test_that("DuckDuckGoSearch$search_news returns news results for a topic", {
  skip_if_offline()
  dds <- DuckDuckGoSearch$new()
  res <- dds$search_news("SpaceX")
  expect_true(is.list(res))
  if (length(res) > 0) {
    expect_true(all(c("title", "url", "body") %in% names(res[[1]])))
  }
})
