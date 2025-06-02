#' Extract R Code Chunks from Markdown Text
#'
#' Parses a Markdown string and extracts R code chunks from fenced blocks like
#' ```{r}, ```r, or plain ``` blocks. Returns a character vector of code chunks.
#' Empty code chunks are ignored.
#'
#' @param markdown_text A character string containing Markdown content.
#'
#' @return A character vector of R code chunks extracted from the Markdown input.
#' Each element represents one code chunk.
#'
#' @examples
#' md <- "
#' ```{r}
#' x <- 1
#' y <- x + 1
#' ```
#'
#' ```r
#' print(y)
#' ```"
#' extract_r_code_chunks(md)
#'
#' @export
extract_r_code_chunks <- function(markdown_text) {
  lines <- strsplit(markdown_text, "\n", fixed = TRUE)[[1]]
  chunks <- character()
  inside <- FALSE
  current_chunk <- character()

  is_code_start <- function(line) {
    grepl("^```(\\{r[^}]*\\}|r)?\\s*$", trimws(line))
  }

  is_code_end <- function(line) {
    trimws(line) == "```"
  }

  for (line in lines) {
    trimmed <- trimws(line)

    if (!inside && is_code_start(trimmed)) {
      inside <- TRUE
      current_chunk <- character()
    } else if (inside && is_code_end(trimmed)) {
      if (any(nzchar(current_chunk))) {
        chunks <- c(chunks, paste(current_chunk, collapse = "\n"))
      }
      inside <- FALSE
    } else if (inside) {
      current_chunk <- c(current_chunk, line)
    }
  }

  return(chunks)
}

#' Tool to extract R code chunks from Markdown using ellmer
#'
#' @export
tool_extract_r_code_chunks <- ellmer::tool(
  extract_r_code_chunks,
  "Extracts R code chunks from a Markdown document.",
  markdown_text = ellmer::type_string(
    "A character string of Markdown content, possibly including R code blocks.",
    required = TRUE
  )
)
