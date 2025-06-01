#' Get NWS Forecast from Latitude and Longitude
#'
#' Retrieves weather forecast data (either general or hourly) from the
#' National Weather Service (NWS) API for a given latitude and longitude.
#'
#' @param lat Numeric. Latitude of the location (e.g., 40.886).
#' @param lon Numeric. Longitude of the location (e.g., -81.416).
#' @param forecast_type Character. Forecast frequency granularity which can be either `"daily"` (default) or `"hourly"`.
#' @param forecast_detail Character. Forecast level of detail which can be a concise summary or a full description. It can be either `"short"` (default) or `"detailed"`.
#'
#' @return A list containing the forecast data as returned by the NWS API.
#' @export
#'
#' @examples
#' \dontrun{
#' get_nws_forecast(40.8860529, -81.4164969, "general", "short")
#' get_nws_forecast(40.8860529, -81.4164969, "hourly", "detailed")
#' }
get_nws_forecast <- function(lat, lon, forecast_type = "general", forecast_detail = "short") {
  stopifnot(is.numeric(lat), is.numeric(lon))
  forecast_type <- rlang::arg_match(forecast_type, c("general", "hourly"))
  forecast_detail <- rlang::arg_match(forecast_detail, c("detailed", "short"))

  forecast_detail <- paste0(forecast_detail, "Forecast")
  user_agent_str <- "nws-r-client"

  # Build base request
  base_req <- httr2::request("https://api.weather.gov/") |>
    httr2::req_user_agent(user_agent_str)

  # Get metadata for forecast URLs
  latlon_path <- paste0("points/", lat, ",", lon)
  meta_resp <- base_req |>
    httr2::req_url_path_append(latlon_path) |>
    httr2::req_perform() |>
    httr2::resp_check_status() |>
    httr2::resp_body_json()

  # Choose forecast URL
  forecast_url <- if (forecast_type == "hourly") {
    meta_resp$properties$forecastHourly
  } else {
    meta_resp$properties$forecast
  }

  # Retrieve forecast
  forecast_resp <- httr2::request(forecast_url) |>
    httr2::req_user_agent(user_agent_str) |>
    httr2::req_perform() |>
    httr2::resp_check_status() |>
    httr2::resp_body_json()

  # Grab detailed forecasts in the response as a list of detailed forecasts
  forecast_resp <- forecast_resp |>
    purrr::pluck('properties', 'periods') |>
    purrr::map(
      \(x) {
        tibble::tibble(
          time = x |> purrr::pluck('startTime'),
          temp_F = x |> purrr::pluck('temperature'),
          rain_prob = x |> purrr::pluck('probabilityOfPrecipitation', 'value'),
          forecast = x |> purrr::pluck(forecast_detail)
        )
      }
    ) |>
    purrr::list_rbind()

  return(forecast_resp)
}

#' Tools to help register the `get_nws_forecast` function with ellmer
#'
#' @export
tool_get_nws_forecast <- ellmer::tool(
  get_nws_forecast,
  "Fetches weather forecast data from the National Weather Service
based on latitude and longitude.",
  lat = ellmer::type_number(
    "Latitude in decimal degrees of the location (e.g., 40.886).",
    required = TRUE
  ),
  lon = ellmer::type_number(
    "Longitude in decimal degrees of the location (e.g., -81.416).",
    required = TRUE
  ),
  forecast_type = ellmer::type_string(
    "Forecast frequency granularity which can be either 'general' (default) or 'hourly'.",
    required = FALSE
  ),
  forecast_detail = ellmer::type_string(
    "Forecast level of detail which can be a concise summary or a full description. It can be either 'short' (default) or 'detailed'.",
    required = FALSE
  )
)

#' Get current temperature and wind speed from Open-Meteo
#'
#' Retrieves the current temperature and wind speed at 2 meters above ground
#' for a given latitude and longitude using the Open-Meteo API.
#'
#' @param latitude Numeric. Latitude of the location.
#' @param longitude Numeric. Longitude of the location.
#'
#' @return A list containing current weather data (e.g., temperature, wind speed).
#' @export
#'
#' @examples
#' \dontrun{
#' get_current_temperature(40.886, -81.416)
#' }
get_current_temperature <- function(latitude, longitude) {
  stopifnot(is.numeric(latitude), is.numeric(longitude))

  base_url <- "https://api.open-meteo.com/v1/forecast"

  req <- httr2::request(base_url) |>
    httr2::req_url_query(
      latitude = latitude,
      longitude = longitude,
      current = "temperature_2m,wind_speed_10m",
      hourly = "temperature_2m,relative_humidity_2m,wind_speed_10m"
    ) |>
    httr2::req_user_agent("openmeteo-r-client (https://example.org)") |>
    httr2::req_perform()

  resp <- httr2::resp_body_json(req)

  return(resp$current)
}


#' Tools to help register the `get_current_temperature` function with ellmer
#'
#' @export
tool_get_current_temperature <- ellmer::tool(
  get_current_temperature,
  "Fetches current temperature and wind speed at 2 meters above ground for a given latitude and longitude using the Open-Meteo API.",
  latitude = ellmer::type_number(
    "Latitude in decimal degrees of the location.",
    required = TRUE
  ),
  longitude = ellmer::type_number(
    "Longitude in decimal degrees of the location.",
    required = TRUE
  )
)
