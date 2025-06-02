test_that("bookmark_save and bookmark_list work", {
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  old_dir <- setwd(tmp_dir)
  on.exit(setwd(old_dir), add = TRUE)
  on.exit(unlink(tmp_dir, recursive = TRUE), add = TRUE)

  expect_match(bookmark_save("foo", "bar"), "Bookmark 'foo' has been saved")
  expect_true("foo" %in% bookmark_list())
})

test_that("bookmark_read returns correct content and error", {
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  old_dir <- setwd(tmp_dir)
  on.exit(setwd(old_dir), add = TRUE)
  on.exit(unlink(tmp_dir, recursive = TRUE), add = TRUE)

  bookmark_save("foo", "bar")
  expect_equal(bookmark_read("foo"), "bar")
  expect_match(bookmark_read("notfound"), "not found")
})