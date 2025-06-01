
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ellmertools

<!-- badges: start -->
<!-- badges: end -->

The goal of ellmertools is to provide a set of useful tool functions
that you can easily register with
[ellmer](https://ellmer.tidyverse.org/). Here’s a great explanation of
tool calling from the ellmer documentation:

> “When making a chat request to the chat model, the caller advertises
> one or more tools (defined by their function name, description, and a
> list of expected arguments), and the chat model can choose to respond
> with one or more “tool calls”. These tool calls are requests from the
> chat model to the caller to execute the function with the given
> arguments; the caller is expected to execute the functions and
> “return” the results by submitting another chat request with the
> conversation so far, plus the results. The chat model can then use
> those results in formulating its response, or, it may decide to make
> additional tool calls… Note that the chat model does not directly
> execute any external tools! It only makes requests for the caller to
> execute them.”

## Installation

You can install the development version of ellmertools from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("parmsam/ellmertools")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(ellmertools)
library(ellmer)
```

### Get weather to help you plan your day

``` r
chat <- chat_openai(model = "gpt-4o-mini")
chat$register_tool(tool_get_nws_forecast)
chat$chat("Give me a weather update for Chicago for tonight. What should I wear?")
#> For tonight in Chicago, the forecast is partly cloudy with a temperature around 
#> 54°F. There is no expected rain, so you should dress comfortably.
#> 
#> ### Suggested Outfit:
#> - A light jacket or sweater to keep warm in the cooler evening temperatures.
#> - Comfortable pants or jeans.
#> - A light scarf might be nice if you tend to get chilly in the evening. 
#> 
#> Enjoy your evening!
```

### Get your current time

``` r
chat <- chat_openai(model = "gpt-4o-mini")
chat$register_tool(tool_get_current_time)
chat$chat("What time is in New York right now? I need to know the current time.")
#> The current time in New York is 12:03 PM EDT on  June 1, 2025.
chat$chat("What day is it?")
#> Today is June 1, 2025.
```

### Get current location

``` r
chat <- chat_openai(model = "gpt-4o-mini")
chat$register_tool(tool_get_current_location)
chat$chat("Where am I right now? What is my approximate location?")
```
