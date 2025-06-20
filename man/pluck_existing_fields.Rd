% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_current_location.R
\name{pluck_existing_fields}
\alias{pluck_existing_fields}
\title{Pluck only existing fields from a list}
\usage{
pluck_existing_fields(x, fields, default = NA)
}
\arguments{
\item{x}{A list (e.g., API response)}

\item{fields}{Character vector of field names to extract}

\item{default}{Default value to return if a field does not exist in `x`}
}
\value{
A named list of only the existing fields
}
\description{
Pluck only existing fields from a list
}
\keyword{internal}
