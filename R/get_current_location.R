#' Get current approximate location based on IP
#'
#' Uses ipinfo.io to return latitude and longitude based on public IP address.
#'
#' @param api_endpoint The API endpoint to use for fetching the current location.
#' @return A named numeric vector with `lat` and `lon`
#' @examples
#' \dontrun{
#' get_current_location()
#' get_current_location("https://ipinfo.io/json")
#' get_current_location("http://ip-api.com/json")
#' }
#' @export
get_current_location <- function(api_endpoint = "https://ipinfo.io/json") {
  resp <- httr2::request(api_endpoint) |>
    httr2::req_perform() |>
    httr2::resp_check_status() |>
    httr2::resp_body_json()

  fields_interest <- c(
    c("city", "region", "country", "loc", "postal", "timezone"),
    c("country", "regionName", "city", "zip", "lat", "lon", "timezone")
  )

  resp <- pluck_existing_fields(
    resp,
    unique(fields_interest)
  )
  resp
}

#' Pluck only existing fields from a list
#'
#' @param x A list (e.g., API response)
#' @param fields Character vector of field names to extract
#' @param default Default value to return if a field does not exist in `x`
#' @return A named list of only the existing fields
#' @keywords internal
pluck_existing_fields <- function(x, fields, default = NA) {
  present <- fields[fields %in% names(x)]
  out <- purrr::map(present, ~ purrr::pluck(x, .x, .default = default))
  rlang::set_names(out, present)
}

#' Tool to help register the `get_current_location` function with ellmer
#'
#' @export
tool_get_current_location <- ellmer::tool(
  get_current_location,
  "Gets the current approximate location based on public IP address.",
  api_endpoint = ellmer::type_string(
    "The API endpoint to use for fetching the current location. Defaults to `\"https://ipinfo.io/json\"`.",
    required = FALSE
  )
)
