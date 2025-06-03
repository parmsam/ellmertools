#' Tool to read and write clipboard content
#'
#' @export
tool_read_clipboard <- ellmer::tool(
  function() clipr::read_clip(),
  "Reads the current content of the system clipboard."
)

#' Tool to help register the `tool_read_clipboard` function with ellmer
#'
#' @export
tool_write_to_clipboard <- ellmer::tool(
  clipr::write_clip,
  "Writes the given content to the clipboard.",
  content = ellmer::type_string(
    "The content to write to the system clipboard.",
    required = TRUE
  )
)
