test_that("extract_r_code_chunks extracts code correctly", {
  md <- paste(
    "```{r}",
    "x <- 1",
    "y <- x + 1",
    "```",
    "",
    "```r",
    "print(y)",
    "```",
    sep = "\n"
  )
  chunks <- extract_r_code_chunks(md)
  expect_length(chunks, 2)
  expect_true(any(grepl("x <- 1", chunks)))
  expect_true(any(grepl("print\\(y\\)", chunks)))
})

test_that("extract_r_code_chunks ignores empty chunks", {
  md <- "```{r}\n```\n"
  expect_length(extract_r_code_chunks(md), 0)
})

test_that("extract_r_code_chunks works", {
    markdown_text <- "## Test 1
```
print(5)
```

## Test 2
```
```

## Test 3
```
print(10)
```

## Test 4

```r
print(15)
```"
    expected <- c("print(5)", "print(10)", "print(15)")
    result <- extract_r_code_chunks(markdown_text)
    expect_equal(result, expected)
})
