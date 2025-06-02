#' Get the current working directory as a JSON object
#'
#' @return A JSON string representing the files in the current working directory.
#' @export
get_current_wd <- function() {
  dir2json::json_encode_dir(getwd(), type = c("text"))
}

#' Tool to help register the `get_current_wd` function with ellmer
#'
#' @export
tool_get_current_wd <- ellmer::tool(
  get_current_wd,
  "Encodes all the text files in the current working directory into JSON format. This is useful to read in a codebase that is located in a predefined directory."
)
