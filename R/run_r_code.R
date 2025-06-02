#' Run R Code
#'
#' @description This function executes R code provided as a string and returns the result.
#' @param code_string A string containing the R code to execute.
#'
#' @return The result of the executed R code, or an error message if the execution fails.
#' @examples
#' \dontrun{
#' run_r_code("x <- 1:10; mean(x)")
#' run_r_code("stop('This will fail')")
#' }
#' @export
run_r_code <- function(code_string) {
  tryCatch({
    eval(parse(text = code_string), envir = globalenv())
  }, error = function(e) {
    paste("Error:", e$message)
  })
}

#' Tool to run R code provided as a string and return the result
#'
#' @export
tool_run_r_code <- ellmer::tool(
  run_r_code,
  "Execute R code provided as a string and return the result.",
  code_string = ellmer::type_string(
    "The R code to execute",
    required = TRUE
  )
)
