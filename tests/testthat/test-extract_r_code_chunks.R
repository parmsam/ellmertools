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
