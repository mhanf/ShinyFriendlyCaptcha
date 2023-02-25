
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ShinyFriendlyCaptcha <a href="https://mhanf.github.io/ShinyFriendlyCaptcha/"><img src="man/figures/logo.png" align="right" height="139" /></a>

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/ShinyFriendlyCaptcha)](https://CRAN.R-project.org/package=ShinyFriendlyCaptcha)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R
badge](https://img.shields.io/badge/Build%20with-♥%20and%20R-blue)](https://github.com/mhanf/ShinyFriendlyCaptcha)
[![R-CMD-check](https://github.com/mhanf/ShinyFriendlyCaptcha/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/mhanf/ShinyFriendlyCaptcha/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of ShinyFriendlyCaptcha is to provide [Friendly
Captcha](https://friendlycaptcha.com/) to Shiny apps.

## Features

Friendly Captcha is an European alternative to Google Recaptcha. It
allow to protect websites against spam and bots in a privacy-embedded
design.

Friendly Captcha features :

-   Cryptographic bot protection
-   No labeling tasks for users
-   No tracking and cookies
-   Fully accessible
-   Guaranteed availability with SLA
-   GDPR compliance agreements

ShinyFriendlyCaptcha additional features :

-   Theme optimized for Bootstrap 5 delivered by the
    [bslib](https://rstudio.github.io/bslib/) package.
-   Compatible with server validation of inputs based on
    [shinyvalidate](https://rstudio.github.io/shinyvalidate/) package.

## Installation

You can install the development version of ShinyFriendlyCaptcha from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("mhanf/ShinyFriendlyCaptcha")
```

## Setup

In order to use the ShinyFriendlyCaptcha library, you’ll need to
subscribe a friendly Captcha plan to obtain valid `SITEKEY` and `SECRET`
strings. A free plan is proposed to developers for non-commercial use
(protection of 1 website with up to 1,000 requests/month). For more
details go to their [website](https://friendlycaptcha.com/).

ShinyFriendlyCaptcha exports two main functions: `sfc_output()` and
`sfc_server()`.

The `sfc_output()` function accept the following parameters :

-   **id:** Module id
-   **sitekey:** Friendly Captcha sitekey
-   **lang:** Language attribute for he Friendly Captcha input.
    Available values are “en”, “fr”, “de”, “it”, “nl”, “pt”, “es”, “ca”,
    “da”, “ja”, “ru”, “sv”, “el”, “uk”, “bg”, “cs”, “sk”, “no”, “fi”,
    “lt”, “lt”, “pl”, “et”, “hr”, “sr”, “sl”, “hu”, or “ro” for
    English,French, German, Italian, Dutch, Portuguese, Spanish,
    Catalan, Danish, Japanese, Russian, Swedish,Greek, Ukrainian,
    Bulgarian, Czech, Slovak, Norwegian, Finnish, Latvian, Lithuanian,
    Polish, Estonian, Croatian, Serbian, Slovenian, Hungarian, and
    Romanian respectively.
-   **dark_mode:** logical. Enable dark mode (FALSE or TRUE)
-   **eu_endpoint:** Logical. Use the EU endpoint (FALSE or TRUE). Only
    for Professional Plans.
-   **theme_bs5:** Logical. Use a theme compatible with Bootstrap 5
    (FALSE or TRUE).

It is also possible to use a personalized theme. As specified on the
Friendly Captcha website, You can create your own stylesheet for the
Friendly Captcha widget. The [existing
css](https://github.com/FriendlyCaptcha/friendly-challenge/blob/master/src/styles.css)
file is probably a good start. To use your own custom theme you could
add the following to the ui part of your shiny App:

``` r
 tags$link(rel="stylesheet", id="frc-style", href="www/my-custom-widget-theme.css")
```

The `sfc_server()` function accept the following parameters :

-   **id:** Module id
-   **sitekey:** Friendly Captcha sitekey
-   **secret:** The Friendly Captcha secret
-   **eu_endpoint:** Logical. Use the EU endpoint (FALSE or TRUE). Only
    for Professional Plans.

## Example

A minimalist Shiny app example using these functions can be created as
follows:

``` r
# libraries
library(shiny)
library(ShinyFriendlyCaptcha)
library(bslib)
library(shinyjs)
library(shinyvalidate)
# simple card function
card_template <- function(id, title, body){
  # card
  div(
    class = "card", 
    id = id,
    # card header
    div(class = "card-header text-center", title),
    # card body
    div(class = "card-body", body)
  )
}
# UI
ui <- fluidPage(
  theme = bs_theme(version=5, bootswatch = "flatly"),
  useShinyjs(),
  br(),
  fluidRow(
    column(width = 3, class = "mx-auto",
           # hidden final message
           hidden(
             h4(
               id ="final-msg", 
               class = "text-primary text-center", "Thank you !"
               )
           ),
           # contact form
           card_template(
             id = "form-contact",
             title = "Contact form",
             body = tagList(
               textInput(
                 inputId = "name",
                 label = "Name",
                 width = "100%"
               ),
               textInput(
                 inputId = "surname",
                 label = "Surname",
                 width = "100%"
               ),
               textInput(
                 inputId = "mail",
                 label = "Mail",
                 width = "100%"
               ),
               textAreaInput(
                  inputId = "msg",
                 label = "Message",
                 width = "100%",
                 height = "150px"
               ),
               sfc_output(
                 id = "test",
                 sitekey = Sys.getenv("captcha_sitekey"),
                 lang = "en",
                 dark_mode = FALSE,
                 eu_endpoint = FALSE,
                 theme_bs5 = TRUE
               ),
               br(),
               actionButton(
                 inputId = "ok",
                 label= "Submit",
                 width = "100%",
                 class="bg-primary"
               )
             )
           )
    )
  )
)
# Server
server <- function(input, output) {
  # shinyvalidate
  iv <- InputValidator$new()
  iv$add_rule("name", sv_required())
  iv$add_rule("surname", sv_required())
  iv$add_rule("mail", sv_required())
  iv$add_rule("mail", sv_email())
  iv$add_rule("msg", sv_required())
  iv$add_rule(
    "test-captchaId", 
    sv_equal(TRUE,message_fmt ="Captcha validation required")
    )
  # captcha response
  captcha_result <- sfc_server(
    id = "test",
    secret = Sys.getenv("captcha_secret"),
    sitekey = Sys.getenv("captcha_sitekey"),
    eu_endpoint = FALSE
  )
  # action on button click
  observeEvent(input$ok,{
    iv$enable()
    req(iv$is_valid())
    #req(captcha_result()$success)
    hide(id = "form-contact")
    show(id="final-msg")
  })
}
# Run the application
shinyApp(ui = ui, server = server)
```

## Contributions

The developer and maintainer of ShinyFriendlyCaptcha is
[mhanf](https://github.com/mhanf). External contributions are welcome.
Please keep in mind that I am not a professional R developer but an
enthusiastic R data scientist who plays with shiny and javascript as a
pretext to learn new stuffs. Unfortunately, so is my code. Please note
that the ShinyFriendlyCaptcha project is released with a [Contributor
Code of
Conduct](https://mhanf.github.io/ShinyFriendlyCaptcha/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

## License

The ShinyFriendlyCaptcha package as a whole is licensed under the
[MIT](https://opensource.org/licenses/mit-license.php) license.
