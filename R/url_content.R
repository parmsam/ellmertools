#' Tool to read URL content as Markdown
#'
#' @export
tool_retrieve_url_content <- ellmer::tool(
  ragnar::read_as_markdown,
  "Read in URL content as Markdown",
  x = ellmer::type_string(
      "The URL to read content from. The content will be returned as a Markdown string.",
      required = TRUE
  )
)
