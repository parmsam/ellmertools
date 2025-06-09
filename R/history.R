#' Read chat history from a markdown file
#'
#' Reads the contents of the chat history markdown file as a character string.
#' @param path Path to the chat history markdown file. Default is "history.md" in the working directory.
#' @return Character string with the contents of the history file, or "" if not found.
#' @export
history_read <- function(path = "history.md") {
  if (!file.exists(path)) return("")
  paste0(readLines(path, warn = FALSE), collapse = "\n")
}

#' Write chat history to a markdown file (overwrite)
#'
#' Writes the given content to the chat history markdown file, overwriting any existing content.
#' @param content Character string to write.
#' @param path Path to the chat history markdown file. Default is "history.md".
#' @export
history_write <- function(content, path = "history.md") {
  writeLines(content, path)
  invisible(TRUE)
}

#' Append a new entry to the chat history markdown file
#'
#' Appends a new markdown entry to the chat history file, with an optional timestamp.
#' @param entry Character string to append.
#' @param path Path to the chat history markdown file. Default is "history.md".
#' @param timestamp Logical; if TRUE, prepends a timestamp to the entry. Default: TRUE.
#' @export
history_append <- function(entry, path = "history.md", timestamp = TRUE) {
  if (timestamp) {
    entry <- paste0("## ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n", entry)
  }
  cat(entry, file = path, sep = "\n\n", append = TRUE)
  invisible(TRUE)
}

#' Tool to read chat history from a markdown file
#'
#' Registers `history_read()` as an ellmer tool to retrieve the contents of the chat history markdown file.
#'
#' @export
tool_history_read <- ellmer::tool(
  history_read,
  "Read the contents of the chat history markdown file.",
  path = ellmer::type_string(
    "Path to the chat history markdown file. Defaults to 'history.md' in the working directory.",
    required = FALSE
  )
)

#' Tool to write chat history to a markdown file (overwrite)
#'
#' Registers `history_write()` as an ellmer tool to overwrite the chat history markdown file.
#'
#' @export
tool_history_write <- ellmer::tool(
  history_write,
  "Write content to the chat history markdown file, overwriting any existing content.",
  content = ellmer::type_string(
    "The content to write to the chat history file.",
    required = TRUE
  ),
  path = ellmer::type_string(
    "Path to the chat history markdown file. Defaults to 'history.md'.",
    required = FALSE
  )
)

#' Tool to append a new entry to the chat history markdown file
#'
#' Registers `history_append()` as an ellmer tool to append a new entry to the chat history markdown file.
#'
#' @export
tool_history_append <- ellmer::tool(
  history_append,
  "Append a new markdown entry to the chat history file, with an optional timestamp.",
  entry = ellmer::type_string(
    "The entry to append to the chat history file.",
    required = TRUE
  ),
  path = ellmer::type_string(
    "Path to the chat history markdown file. Defaults to 'history.md'.",
    required = FALSE
  ),
  timestamp = ellmer::type_boolean(
    "Whether to prepend a timestamp to the entry. Defaults to TRUE.",
    required = FALSE
  )
)
