% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sfc_output.R
\name{sfc_output}
\alias{sfc_output}
\title{Create a Friendly Captcha input}
\usage{
sfc_output(
  id,
  sitekey = Sys.getenv("captcha_sitekey"),
  lang = "en",
  eu_endpoint = FALSE,
  theme_bs5 = FALSE,
  dark_mode = FALSE
)
}
\arguments{
\item{id}{The Friendly Captcha input id}

\item{sitekey}{The Friendly Captcha sitekey}

\item{lang}{Language attribute for he Friendly Captcha input. Available values are "en",
"fr", "de", "it", "nl", "pt", "es", "ca", "da", "ja", "ru", "sv", "el", "uk", "bg", "cs",
"sk", "no", "fi", "lt", "lt", "pl", "et", "hr", "sr", "sl", "hu", "ro", "zh", "zh_TW",
and "vi" for English, French, German, Italian, Dutch, Portuguese, Spanish, Catalan, Danish,
Japanese, Russian, Swedish, Greek, Ukrainian, Bulgarian, Czech, Slovak, Norwegian, Finnish,
Latvian, Lithuanian, Polish, Estonian, Croatian, Serbian, Slovenian, Hungarian, Romanian,
Chinese (Simplified), Chinese (Traditional), and Vietnamese respectively.}

\item{eu_endpoint}{Logical. Use the EU endpoint (FALSE or TRUE). Only for Professional Plans.}

\item{theme_bs5}{Logical. Use a Bootstrap 5 theme (FALSE or TRUE).}

\item{dark_mode}{logical. Enable dark mode (FALSE or TRUE)}
}
\value{
A Friendly Captcha input for usage in Shiny UI.
}
\description{
Create a Friendly Captcha input for usage in a Shiny UI.
}
\examples{
if (interactive()) {
  library(shiny)
  library(ShinyFriendlyCaptcha)

  ui <- fluidPage(
    sfc_output("captcha",
    sitekey = Sys.getenv("captcha_sitekey"),
    lang = "en",
    eu_endpoint = FALSE,
    theme_bs5 = FALSE,
    dark_mode = FALSE
    ),
    shiny::textOutput("result")
  )
  server <- function(input, output, session) {

  captcha_result <- sfc_server(
  id = "captcha",
  secret = Sys.getenv("captcha_secret"),
  sitekey = Sys.getenv("captcha_sitekey"),
  eu_endpoint = FALSE
  )
    shiny::observe({
      output$result <- shiny::renderText(paste0("Captcha result: ",captcha_result()$success))
    })
  }
  shiny::shinyApp(ui, server)
}
}
