#' Read memory from a markdown file
#'
#' Reads the contents of the memory markdown file as a character string.
#' @param path Path to the memory markdown file. Default is "memory.md" in the working directory.
#' @return Character string with the contents of the memory file, or "" if not found.
#' @export
memory_read <- function(path = "memory.md") {
  if (!file.exists(path)) return("")
  paste0(readLines(path, warn = FALSE), collapse = "\n")
}

#' Write memory to a markdown file (overwrite)
#'
#' Writes the given content to the memory markdown file, overwriting any existing content.
#' @param content Character string to write.
#' @param path Path to the memory markdown file. Default is "memory.md".
#' @export
memory_write <- function(content, path = "memory.md") {
  writeLines(content, path)
  invisible(TRUE)
}

#' Append a new entry to the memory markdown file
#'
#' Appends a new markdown entry to the memory file, with an optional timestamp.
#' @param entry Character string to append.
#' @param path Path to the memory markdown file. Default is "memory.md".
#' @param timestamp Logical; if TRUE, prepends a timestamp to the entry. Default: TRUE.
#' @export
memory_append <- function(entry, path = "memory.md", timestamp = TRUE) {
  if (timestamp) {
    entry <- paste0("## ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n", entry)
  }
  cat(entry, file = path, sep = "\n\n", append = TRUE)
  invisible(TRUE)
}

#' Tool to read memory from a markdown file
#'
#' Registers `memory_read()` as an ellmer tool to retrieve the contents of the memory markdown file.
#'
#' @export
tool_memory_read <- ellmer::tool(
  memory_read,
  "Read the contents of the memory markdown file.",
  path = ellmer::type_string(
    "Path to the memory markdown file. Defaults to 'memory.md' in the working directory.",
    required = FALSE
  )
)

#' Tool to write memory to a markdown file (overwrite)
#'
#' Registers `memory_write()` as an ellmer tool to overwrite the memory markdown file.
#'
#' @export
tool_memory_write <- ellmer::tool(
  memory_write,
  "Write content to the memory markdown file, overwriting any existing content.",
  content = ellmer::type_string(
    "The content to write to the memory file.",
    required = TRUE
  ),
  path = ellmer::type_string(
    "Path to the memory markdown file. Defaults to 'memory.md'.",
    required = FALSE
  )
)

#' Tool to append a new entry to the memory markdown file
#'
#' Registers `memory_append()` as an ellmer tool to append a new entry to the memory markdown file.
#'
#' @export
tool_memory_append <- ellmer::tool(
  memory_append,
  "Append a new markdown entry to the memory file, with an optional timestamp.",
  entry = ellmer::type_string(
    "The entry to append to the memory file.",
    required = TRUE
  ),
  path = ellmer::type_string(
    "Path to the memory markdown file. Defaults to 'memory.md'.",
    required = FALSE
  ),
  timestamp = ellmer::type_boolean(
    "Whether to prepend a timestamp to the entry. Defaults to TRUE.",
    required = FALSE
  )
)
