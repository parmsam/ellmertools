#' Internal: Get a Wikipedia page (summary or html)
#'
#' @param endpoint Wikipedia API endpoint (e.g., "summary" or "html")
#' @param title Page title
#' @param revision Optional revision id
#' @param app_name App name for user agent
#' @return Parsed content or error object
#' @keywords internal
wikipedia_get_page <- function(endpoint = "summary", title, revision = NULL, app_name = "wikipediar") {
  # Input validation
  stopifnot(
    is.character(endpoint), length(endpoint) == 1, nchar(endpoint) > 0,
    is.character(title), length(title) == 1, nchar(title) > 0
  )

  encoded_title <- utils::URLencode(gsub(" ", "_", title), reserved = TRUE)

  path <- paste0("https://en.wikipedia.org/api/rest_v1/page/", endpoint, "/", encoded_title)

  if (!is.null(revision)) {
    path <- paste0(path, "/", revision)
  }

  req <- httr2::request(path) |>
    httr2::req_user_agent(app_name)

  result <- tryCatch(
    {
      resp <- httr2::req_perform(req)
      content_type <- httr2::resp_content_type(resp)
      content <- if (grepl("json", content_type)) {
        jsonlite::fromJSON(httr2::resp_body_string(resp))
      } else {
        httr2::resp_body_string(resp)
      }
      attr(content, "status") <- "OK"
      attr(content, "source") <- path
      content
    },
    error = function(e) {
      structure(
        list(),
        attributes = make_error_object(
          path,
          list(
            message = e$message,
            type = if (inherits(e, "httr2_http_error")) "http_error" else "json_parse_error",
            http_status = if (inherits(e, "httr2_http_error")) e$response$status else NULL
          )
        )
      )
    }
  )
  result
}

#' Get a Wikipedia page summary
#'
#' Retrieves the summary of a Wikipedia page by title using the Wikipedia REST API.
#'
#' @param title The title of the Wikipedia page to summarize.
#' @param revision (Optional) The revision ID of the page.
#' @param app_name App name for user agent (default: "wikipediar").
#' @return A list containing the summary information for the page.
#' @examples
#' \dontrun{
#' wikipedia_get_page_summary("Albert Einstein")
#' }
#' @export
wikipedia_get_page_summary <- function(title, revision = NULL, app_name = "wikipediar") {
  wikipedia_get_page("summary", title, revision, app_name)
}

#' Get a Wikipedia page as Markdown
#'
#' Retrieves the full content of a Wikipedia page as Markdown using the Wikipedia REST API.
#'
#' @param title The title of the Wikipedia page to retrieve.
#' @param revision (Optional) The revision ID of the page.
#' @param app_name App name for user agent (default: "wikipediar").
#' @return A character string containing the page content in Markdown format.
#' @examples
#' \dontrun{
#' wikipedia_get_page_html("Albert Einstein")
#' }
#' @export
wikipedia_get_page_html <- function(title, revision = NULL, app_name = "wikipediar") {
  x <- wikipedia_get_page("html", title, revision, app_name)
  html_string_as_markdown(x)
}

#' Internal: Convert HTML string to Markdown
#'
#' @param x HTML string
#' @return Markdown string
#' @keywords internal
html_string_as_markdown <- function(x){
  file_path <- tempfile()
  writeLines(x, file_path)
  ragnar::read_as_markdown(file_path)
}

#' Tool to get a Wikipedia page summary
#'
#' @export
tool_wikipedia_get_page_summary <- ellmer::tool(
  function(title){
    wikipedia_get_page_summary(title)[["extract"]]
  },
  "Get a summary of a Wikipedia page by title.",
  title = ellmer::type_string(
    "The title of the Wikipedia page to summarize. This should be the exact title as it appears on Wikipedia, including spaces and special characters. For example, 'Albert Einstein' or 'Python (programming language)'.",
    required = TRUE
  )
)

#' Tool to get a full Wikipedia page
#'
#' @export
tool_wikipedia_get_page_markdown <- ellmer::tool(
  function(title){
    wikipedia_get_page_html(title)
  },
  "Get the full content of a Wikipedia page in Markdown format.",
  title = ellmer::type_string(
    "The title of the Wikipedia page to retrieve. This should be the exact title as it appears on Wikipedia, including spaces and special characters. For example, 'Albert Einstein' or 'Python (programming language)'.",
    required = TRUE
  )
)
