#' R6 Class for DuckDuckGo Search
#'
#' @description
#' A class that provides methods to perform DuckDuckGo text and news searches via HTML and JSON endpoints.
DuckDuckGoSearch <- R6::R6Class(
  "DuckDuckGoSearch",
  public = list(
    #' @field headers Named list of headers used for requests.
    headers = NULL,

    #' @field proxy Optional proxy URL (e.g., "http://localhost:8080").
    proxy = NULL,

    #' @field timeout Request timeout in seconds.
    timeout = 10,

    #' @field sleep_timestamp Internal timestamp used to throttle requests.
    sleep_timestamp = 0,

    #' @description
    #' Initialize a new DuckDuckGoSearch object.
    #' @param headers Optional headers (named list).
    #' @param proxy Optional proxy URL.
    #' @param timeout Timeout for HTTP requests (in seconds).
    #' @return A new `DuckDuckGoSearch` object.
    initialize = function(headers = NULL,
                          proxy = NULL,
                          timeout = 10) {
      self$headers <- headers %||% list(`User-Agent` = "duckduckgo-search-r")
      self$proxy <- proxy
      self$timeout <- timeout
    },

    #' @description
    #' Sleep to avoid rate-limiting between requests.
    #' @param sleeptime Duration to sleep (default: 0.75 seconds).
    sleep = function(sleeptime = 0.75) {
      now <- as.numeric(Sys.time())
      if (self$sleep_timestamp > 0 &&
          (now - self$sleep_timestamp < 20)) {
        Sys.sleep(sleeptime)
      }
      self$sleep_timestamp <- now
    },

    #' @description
    #' Make an HTTP request with appropriate parameters.
    #' @param method HTTP method ("GET" or "POST").
    #' @param url Target URL.
    #' @param params Optional query parameters.
    #' @param body Optional body for POST requests.
    #' @param headers Optional headers (overrides default).
    #' @return The HTTP response object.
    get_url = function(method,
                       url,
                       params = NULL,
                       body = NULL,
                       headers = NULL) {
      self$sleep()
      req <- httr2::request(url)
      req <- httr2::req_method(req, method)
      req <- httr2::req_timeout(req, self$timeout)
      req <- httr2::req_headers(req, !!!(headers %||% self$headers))
      if (!is.null(self$proxy)) {
        req <- httr2::req_options(req, proxy = self$proxy)
      }
      if (!is.null(params)) {
        req <- httr2::req_url_query(req, !!!params)
      }
      if (!is.null(body)) {
        req <- httr2::req_body_form(req, !!!body)
      }
      resp <- httr2::req_perform(req)
      resp
    },

    #' @description
    #' Get a `vqd` token needed for JSON-based DuckDuckGo news search.
    #' @param keywords Search query string.
    #' @return A `vqd` token as a character string.
    get_vqd = function(keywords) {
      resp <- self$get_url("GET", "https://duckduckgo.com", params = list(q = keywords))
      html <- httr2::resp_body_string(resp)
      match <- stringr::str_match(html, "vqd=\\s*['\"]?([\\d-]+)['\"]?")
      vqd <- match[, 2]
      if (is.na(vqd))
        stop("Failed to extract vqd token")
      vqd
    },

    #' @description
    #' Search DuckDuckGo using the HTML endpoint.
    #' @param keywords Query string.
    #' @param region Optional region code (default: "wt-wt").
    #' @param timelimit Optional time filter (e.g., "d" = day, "w" = week).
    #' @param max_results Max number of results to return.
    #' @return A list of search results.
    search_text_html = function(keywords,
                                region = "wt-wt",
                                timelimit = NULL,
                                max_results = NULL) {
      stopifnot(nzchar(keywords))
      body <- list(q = keywords, kl = region)
      if (!is.null(timelimit))
        body$df <- timelimit

      headers <- c(self$headers,
                   Referer = "https://html.duckduckgo.com/",
                   `Sec-Fetch-User` = "?1")

      results <- list()
      seen <- character()

      for (i in 1:5) {
        resp <- self$get_url(
          "POST",
          "https://html.duckduckgo.com/html",
          body = body,
          headers = headers
        )
        content <- httr2::resp_body_string(resp)
        if (stringr::str_detect(content, "No results."))
          return(results)

        html <- xml2::read_html(content)
        divs <- rvest::html_elements(html, xpath = "//div[h2]")

        for (div in divs) {
          href <- rvest::html_attr(rvest::html_element(div, "a"), "href")
          if (is.na(href) ||
              href %in% seen)
            next
          seen <- c(seen, href)

          title <- rvest::html_text2(rvest::html_element(div, "h2 a"))
          body_text <- paste(rvest::html_text2(rvest::html_elements(div, "a")), collapse = " ")

          results[[length(results) + 1]] <- list(
            title = stringr::str_trim(title),
            href = stringr::str_trim(href),
            body = stringr::str_trim(body_text)
          )

          if (!is.null(max_results) &&
              length(results) >= max_results) {
            return(results)
          }
        }

        np <- rvest::html_elements(html, xpath = "//div[@class='nav-link']//input[@type='hidden']")
        if (length(np) == 0 ||
            is.null(max_results))
          break
        body <- setNames(rvest::html_attr(np, "value"),
                         rvest::html_attr(np, "name"))
      }

      results
    },

    #' @description
    #' Search DuckDuckGo news using the JSON endpoint.
    #' @param keywords Query string.
    #' @param region Region code.
    #' @param safesearch Safe search level: "on", "moderate", or "off".
    #' @param timelimit Optional time constraint.
    #' @param max_results Max number of results.
    #' @return A list of news result entries.
    search_news = function(keywords,
                           region = "wt-wt",
                           safesearch = "moderate",
                           timelimit = NULL,
                           max_results = NULL) {
      stopifnot(nzchar(keywords))
      vqd <- self$get_vqd(keywords)

      payload <- list(
        l = region,
        o = "json",
        noamp = "1",
        q = keywords,
        vqd = vqd,
        p = switch(
          tolower(safesearch),
          on = "1",
          moderate = "-1",
          off = "-2",
          "-1"
        )
      )
      if (!is.null(timelimit)) {
        payload$df <- timelimit
      }

      results <- list()
      seen <- character()

      for (i in 1:5) {
        resp <- self$get_url("GET", "https://duckduckgo.com/news.js", params = payload)
        json <- jsonlite::fromJSON(httr2::resp_body_string(resp), simplifyVector = FALSE)
        page_data <- json[["results"]]

        for (row in page_data) {
          if (row$url %in% seen)
            next
          seen <- c(seen, row$url)

          date_iso <- tryCatch(
            as.character(as.POSIXct(
              row$date, origin = "1970-01-01", tz = "UTC"
            )),
            error = function(e)
              NA
          )

          results[[length(results) + 1]] <- list(
            date = date_iso,
            title = row$title,
            body = stringr::str_trim(row$excerpt),
            url = row$url,
            image = row$image %||% NULL,
            source = row$source
          )

          if (!is.null(max_results) &&
              length(results) >= max_results) {
            return(results)
          }
        }

        if (is.null(json[["next"]]) ||
            is.null(max_results))
          break
        payload$s <- stringr::str_match(json[["next"]], "s=(\\d+)")[, 2]
      }

      results
    }
  )
)


#' Internal utility: Provide a default value if the first argument is NULL
#'
#' @param a First value to check for NULL
#' @param b Value to return if `a` is NULL
#' @return `a` if not NULL, otherwise `b`
#' @keywords internal
#'
#' @examples \dontrun{
#' NULL %||% "default"
#' 5 %||% "default"
#' }
`%||%` <- function(a, b) if (!is.null(a)) a else b

#' Tool to search DuckDuckGo for text and return results
#'
#' @export
tool_duckduckgo_search <- ellmer::tool(
  DuckDuckGoSearch$new()$search_text_html,
  "Search DuckDuckGo for text and return results.",
  keywords = ellmer::type_string(
    "The search keywords",
    required = TRUE
  )
)

#' Tool to search DuckDuckGo for news articles and return results
#'
#' @export
tool_duckduckgo_news <- ellmer::tool(
  DuckDuckGoSearch$new()$search_news,
  "Search DuckDuckGo for news articles and return results.",
  keywords = ellmer::type_string(
    "The search keywords",
    required = TRUE
  )
)
