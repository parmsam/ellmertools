get_current_wd <- function() {
  dir2json::json_encode_dir(getwd(), type = "text")
}


#' Tool to help register the `get_current_wd` function with ellmer
#'
#' @export
tool_get_current_wd <- tool(
  get_current_wd,
  "Encodes all the text files in the current working directory into JSON format. This is useful to read in a codebase that is located in a predefined directory."
)
