#' Tool to read URL content as Markdown
#'
#' @export
tool_retrieve_url_content <- ellmer::tool(
  \(url) ragnar::read_as_markdown(path = url),
  name = "retrieve_url_content",
  description = "Read in URL content as Markdown",
  arguments = list(
    url = ellmer::type_string(
        "The URL to read content from. The content will be returned as a Markdown string.",
        required = TRUE
    )
  )
)
