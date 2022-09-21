#' Create a Friendly Captcha input
#' @description Create a Friendly Captcha input for usage in a Shiny UI.
#' @importFrom shiny NS tagList div tags HTML
#' @importFrom htmltools tagAppendAttributes
#'
#' @param id The Friendly Captcha input id
#' @param lang Language attribute for he Friendly Captcha input. Available values are "en",
#' "fr", "de", "it", "nl", "pt", "es", "ca", "da", "ja", "ru", "sv", "el", "uk", "bg", "cs",
#' "sk", "no", "fi", "lt", "lt", "pl", "et", "hr", "sr", "sl", "hu", or "ro" for English,
#' French, German, Italian, Dutch, Portuguese, Spanish, Catalan, Danish, Japanese,
#' Russian, Swedish,Greek, Ukrainian, Bulgarian, Czech, Slovak, Norwegian, Finnish,
#' Latvian, Lithuanian, Polish, Estonian, Croatian, Serbian, Slovenian, Hungarian,
#' and Romanian respectively.
#' @param sitekey The Friendly Captcha sitekey
#' @param dark_mode logical. Enable dark mode (FALSE or TRUE)
#' @param eu_endpoint Logical. Use the EU endpoint (FALSE or TRUE). Only for Professional Plans.
#' @param theme_bs5 Logical. Use a Bootstrap 5 theme (FALSE or TRUE).
#'
#' @return A Friendly Captcha input for usage in Shiny UI.
#' @export

sfc_output <- function(id,
                       sitekey = Sys.getenv("captcha_sitekey"),
                       lang = "en",
                       eu_endpoint = FALSE,
                       theme_bs5 = FALSE,
                       dark_mode = FALSE) {

  # bootstrap 5 theme
  bs5_dep <- NULL
  if (isTRUE(theme_bs5)) {
    # load dependency
    bs5_dep <- htmltools::htmlDependency(
      name = "bs5_dep",
      version = "0.0.1",
      package = "ShinyFriendlyCaptcha",
      src = "assets",
      stylesheet = c(file = "bs5_style.css")
    )
    # add necessary frc-style id
    bs5_dep <- tags$style(id = "frc-style", bs5_dep)
  }
  # shiny module name spacing
  ns <- NS(id)
  # test lang parameter
  language <- c(
    "en", "fr", "de", "it", "nl", "pt", "es", "ca", "da", "ja",
    "ru", "sv", "el", "uk", "bg", "cs", "sk", "no", "fi", "lt",
    "lt", "pl", "et", "hr", "sr", "sl", "hu", "ro"
  )
  match.arg(
    arg = lang,
    choices = language,
    several.ok = FALSE
  )
  # javascript dependency 1
  captcha_js1 <- tags$script(
    type = "module",
    src = "https://unpkg.com/friendly-challenge@0.9.7/widget.module.min.js",
    async = NA,
    defer = NA
  )
  # javascript dependency 2
  captcha_js2 <- tags$script(
    nomodule = NA,
    src = "https://unpkg.com/friendly-challenge@0.9.7/widget.min.js",
    async = NA,
    defer = NA
  )
  # javascript dependency 3
  captcha_js3 <- tags$script(
    paste0("shinyCaptcha = function(response) {
      Shiny.onInputChange('", ns("captcha_response"), "', response);
             }")
  )
  # class definition
  captcha_class <- "frc-captcha"
  if (isTRUE(dark_mode)) {
    captcha_class <- "frc-captcha dark"
  }
  # capcha tag definition
  captcha <- div(
    class = captcha_class,
    `data-lang` = lang,
    `data-sitekey` = sitekey,
    `data-callback` = I("shinyCaptcha")
  )
  # eu endpoint
  if (isTRUE(eu_endpoint)) {
    captcha <- tagAppendAttributes(
      captcha,
      "data-puzzle-endpoint" = "https://eu-api.friendlycaptcha.eu/api/v1/puzzle"
    )
  }
  # attach dependencies
  captcha <- tagList(bs5_dep, captcha_js1, captcha_js2, captcha_js3, captcha)
  # return
  return(captcha)
}