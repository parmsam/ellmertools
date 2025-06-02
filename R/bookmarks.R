#' Save or update a named bookmark with some text content
#'
#' @param name The name of the bookmark.
#' @param content The text to save in the bookmark.
#' @return A message indicating the bookmark was saved.
#'
#' @export
bookmark_save <- function(name, content) {
  bookmark_dir <- "bookmarks"
  bookmark_board <- pins::board_folder(bookmark_dir)
  pins::pin_write(bookmark_board, content, name)
  paste0("Bookmark '", name, "' has been saved.")
}

#' Tool to help register the `bookmark_save` function with ellmer
#'
#' @export
tool_bookmark_save <- ellmer::tool(
  bookmark_save,
  "Save or update a named bookmark with some text content.",
  name = ellmer::type_string(
    "The name of the bookmark",
    required = TRUE
  ),
  content = ellmer::type_string(
    "The text to save in the bookmark",
    required = TRUE
  )
)

#' List all bookmark names
#'
#' @return A character vector of bookmark names, or a message if none found.
#'
#' @export
bookmark_list <- function() {
  bookmark_dir <- "bookmarks"
  bookmark_board <- pins::board_folder(bookmark_dir)
  names <- pins::pin_list(bookmark_board)
  if (length(names) == 0) return("No bookmarks found.")
  names
}

#' Tool to help register the `bookmark_list` function with ellmer
#'
#' @export
tool_bookmark_list <- ellmer::tool(
  bookmark_list,
  "List all bookmark names."
)

#' Read the content of a specific bookmark by name
#'
#' @param name The name of the bookmark to read.
#' @return The content of the bookmark, or a message if not found.
#'
#' @export
bookmark_read <- function(name){
  bookmark_dir <- "bookmarks"
  bookmark_board <- pins::board_folder(bookmark_dir)
  if (!name %in% pins::pin_list(bookmark_board)) {
    return(paste0("Bookmark '", name, "' not found."))
  }
  content <- pins::pin_read(bookmark_board, name)
  content
}

#' Tool to help register the `bookmark_read` function with ellmer
#'
#' @export
tool_bookmark_read <- ellmer::tool(
  bookmark_read,
  "Read the content of a specific bookmark by name.",
  name = ellmer::type_string(
    "The name of the bookmark to read",
    required = TRUE
  )
)
