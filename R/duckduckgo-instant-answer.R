#' Call DuckDuckGo Instant Answer API
#'
#' Makes a synchronous API call to the DuckDuckGo Instant Answer API.
#'
#' @param query the query string
#' @param no_redirect TRUE to skip HTTP redirects (for !bang commands)
#' @param no_html TRUE to remove html from results
#' @param skip_disambig TRUE to skip disambiguation (D) Type.
#' @param app_name the appname used to identify your application.
#'
#' @return A list. Includes parsed response or error details as attributes.
#' @export
duckduckgo_answer <- function(query, no_redirect = FALSE,
                            no_html = FALSE, skip_disambig = FALSE,
                            app_name = "duckduckr") {

  # Input validation
  stopifnot(
    length(app_name) == 1, nchar(app_name) > 0, is.character(app_name),
    length(query) == 1, is.character(query),
    is.logical(no_redirect), is.logical(no_html), is.logical(skip_disambig)
  )

  base_url <- "https://api.duckduckgo.com/"
  query_params <- list(
    q = query,
    no_redirect = as.integer(no_redirect),
    no_html = as.integer(no_html),
    format = "json",
    skip_disambig = as.integer(skip_disambig),
    t = app_name
  )

  req <- httr2::request(base_url) |>
    httr2::req_url_query(!!!query_params) |>
    httr2::req_user_agent(app_name)

  # Extract full URL with query string
  full_url <- paste0(base_url, "?", httr2::req_url_query(req))

  result <- tryCatch(
    {
      resp <- httr2::req_perform(req)
      json <- httr2::resp_body_string(resp)
      parsed_response <- jsonlite::fromJSON(
        json,
        simplifyVector = TRUE,
        simplifyDataFrame = TRUE,
        simplifyMatrix = TRUE
      )
      attr(parsed_response, "status") <- "OK"
      attr(parsed_response, "source") <- full_url
      parsed_response
    },
    error = function(e) {
      structure(
        list(),
        attributes = make_error_object(
          full_url,
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

#' Tool to call DuckDuckGo Instant Answer API
#'
#' @export
tool_duckduckgo_answer <- ellmer::tool(
  function(query) {
    duckduckgo_answer(query)[["Abstract"]]
  },
  "Call DuckDuckGo Instant Answer API",
  query = ellmer::type_string(
    "The DuckDuckGo Search query string",
    required = TRUE
  )
)
