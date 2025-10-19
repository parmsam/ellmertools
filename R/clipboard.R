#' Tool to read and write clipboard content
#'
#' @export
tool_read_clipboard <- ellmer::tool(
  \() {
    content <- clipr::read_clip(allow_non_interactive = TRUE)
    # Convert to UTF-8, replacing invalid bytes
    content <- iconv(content, from = "", to = "UTF-8", sub = "byte")
    return(content)
  },
  name = "read_clipboard",
  description = "Reads the current content of the system clipboard."
)

#' Tool to help register the `tool_read_clipboard` function with ellmer
#'
#' @export
tool_write_to_clipboard <- ellmer::tool(
  \(content) clipr::write_clip(content = content, allow_non_interactive = T),
  name = "write_to_clipboard",
  description = "Writes the given content to the clipboard.",
  arguments = list(
    content = ellmer::type_string(
      "The content to write to the system clipboard.",
      required = TRUE
    )
  )
)
