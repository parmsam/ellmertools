#' Gets the current time in the given time zone.
#'
#' @param tz The time zone to get the current time in.
#' @return The current time in the given time zone.
get_current_time <- function(tz = "UTC") {
  format(Sys.time(), tz = tz, usetz = TRUE)
}

#' Tool to help register the `get_current_time` function with ellmer
#'
#' @export
tool_get_current_time <- ellmer::tool(
  get_current_time,
  "Gets the current time in the given time zone.",
  tz = ellmer::type_string(
    "The time zone to get the current time in. Defaults to `\"UTC\"`.",
    required = FALSE
  )
)
