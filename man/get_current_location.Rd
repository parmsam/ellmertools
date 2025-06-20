% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_current_location.R
\name{get_current_location}
\alias{get_current_location}
\title{Get current approximate location based on IP}
\usage{
get_current_location(api_endpoint = "https://ipinfo.io/json")
}
\arguments{
\item{api_endpoint}{The API endpoint to use for fetching the current location.}
}
\value{
A named numeric vector with `lat` and `lon`
}
\description{
Uses ipinfo.io to return latitude and longitude based on public IP address.
}
\examples{
\dontrun{
get_current_location()
get_current_location("https://ipinfo.io/json")
get_current_location("http://ip-api.com/json")
}
}
