#' Create a Friendly Captcha input
#' @description Create a Friendly Captcha input for usage in a Shiny UI.
#' @importFrom shiny NS tagList div tags
#' @importFrom htmltools tagAppendAttributes
#' @param id The Friendly Captcha input id
#' @param lang Language attribute for he Friendly Captcha input. Available values are "en",
#' "fr", "de", "it", "nl", "pt", "es", "ca", "da", "ja", "ru", "sv", "el", "uk", "bg", "cs",
#' "sk", "no", "fi", "lt", "lt", "pl", "et", "hr", "sr", "sl", "hu", or "ro" for English,
#' French, German, Italian, Dutch, Portuguese, Spanish, Catalan, Danish, Japanese,
#' Russian, Swedish, Greek, Ukrainian, Bulgarian, Czech, Slovak, Norwegian, Finnish,
#' Latvian, Lithuanian, Polish, Estonian, Croatian, Serbian, Slovenian, Hungarian,
#' and Romanian respectively.
#' @param sitekey The Friendly Captcha sitekey
#' @param dark_mode logical. Enable dark mode (FALSE or TRUE)
#' @param eu_endpoint Logical. Use the EU endpoint (FALSE or TRUE). Only for Professional Plans.
#'
#' @return A Friendly Captcha input for usage in Shiny UI.
#' @export

sfc_output <- function(id,
                       sitekey = Sys.getenv("captcha_sitekey"),
                       lang = "en",
                       eu_endpoint = FALSE,
                       bs5_theme = NULL,
                       dark_mode = FALSE
                       ){

  theme_css <- NULL

  if (is.null(bs5_theme) == FALSE){

    css <- sass(
      sass_layer(
        defaults = list(
          captcha_color = "var(--bs-warning)",
          captcha_bg = "var(--bs-warning)"
        ),
        rules = sass_file(
          input = system.file(
            "assets/styles.scss",
            package = "ShinyFriendlyCaptcha"
          )
        )
      )
    )

    theme_css <- tags$style(id="frc-style", HTML(css))

  }

  # shiny module name spacing
  ns <- NS(id)
  # test lang parameter
  language <- c("en","fr", "de", "it", "nl", "pt", "es", "ca", "da", "ja",
                "ru", "sv", "el", "uk", "bg", "cs", "sk", "no", "fi", "lt",
                "lt", "pl", "et", "hr", "sr", "sl", "hu", "ro")
  match.arg(
    arg = lang,
    choices = language,
    several.ok = FALSE
  )
  # javascript dependency 1
  captcha_js1 <- tags$script(
    type="module",
    src="https://unpkg.com/friendly-challenge@0.9.7/widget.module.min.js",
    async = NA,
    defer =NA
    )
  # javascript dependency 2
  captcha_js2 <- tags$script(
    nomodule = NA,
    src="https://unpkg.com/friendly-challenge@0.9.7/widget.min.js",
    async = NA,
    defer =NA
  )
  # javascript dependency 3
  captcha_js3 <- tags$script(
    paste0("shinyCaptcha = function(response) {
      Shiny.onInputChange('", ns("captcha_response"),"', response);
             }")
    )
  # class definition
  captcha_class <- "frc-captcha"
  if (isTRUE(dark_mode)){captcha_class <- "frc-captcha dark"}




  #capcha tag definition
  captcha <- div(class = captcha_class,
             `data-lang`= lang,
             `data-sitekey` = sitekey,
             `data-callback` = I("shinyCaptcha")
             )
  # eu endpoint
  if (isTRUE(eu_endpoint)){
    captcha <- tagAppendAttributes(
      captcha,
      'data-puzzle-endpoint' = "https://eu-api.friendlycaptcha.eu/api/v1/puzzle"
      )
  }
  # attach dependencies
  captcha <- tagList(theme_css, captcha_js1, captcha_js2, captcha_js3, captcha)
  # return
  return(captcha)
}
