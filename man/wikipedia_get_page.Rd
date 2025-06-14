% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wikipedia.R
\name{wikipedia_get_page}
\alias{wikipedia_get_page}
\title{Internal: Get a Wikipedia page (summary or html)}
\usage{
wikipedia_get_page(
  endpoint = "summary",
  title,
  revision = NULL,
  app_name = "wikipediar"
)
}
\arguments{
\item{endpoint}{Wikipedia API endpoint (e.g., "summary" or "html")}

\item{title}{Page title}

\item{revision}{Optional revision id}

\item{app_name}{App name for user agent}
}
\value{
Parsed content or error object
}
\description{
Internal: Get a Wikipedia page (summary or html)
}
\keyword{internal}
