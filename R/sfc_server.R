#' Friendly Captcha input for usage in Shiny Server
#'
#' @param id The Friendly Captcha input id
#' @param secret The Friendly Captcha secret
#' @param sitekey The Friendly Captcha sitekey
#' @param eu_endpoint Logical. Use the EU endpoint (FALSE or TRUE). Only for Professional Plans.
#' @importFrom shiny moduleServer observe reactive isTruthy observeEvent updateCheckboxInput
#' @importFrom httr POST content
#' @importFrom jsonlite fromJSON
#' @return  Friendly Captcha input for usage in Shiny Server.
#' @export

sfc_server <- function(id,
                       secret = Sys.getenv("captcha_secret"),
                       sitekey = NULL,
                       eu_endpoint = FALSE) {
  moduleServer(id, function(input, output, session) {
    # session ns
    ns <- session$ns
    # URL definition
    url <- "https://api.friendlycaptcha.com/api/v1/siteverify"
    if (eu_endpoint == TRUE) {
      url <- "https://eu-api.friendlycaptcha.eu/api/v1/siteverify"
    }
    # status definition
    status <- reactive({
      # POST request
      if (isTruthy(input$captcha_response)) {
        resp <- httr::POST(
          url,
          body = list(
            secret = secret,
            solution = input$captcha_response,
            sitekey = sitekey
          )
        )
        jsonlite::fromJSON(httr::content(resp, "text", encoding = "UTF-8"))
      } else {
        list(
          success = FALSE,
          errors = ""
        )
      }
    })
    # update of hidden checkbox
    observeEvent(status()$success,
      ignoreInit = TRUE,
      ignoreNULL = TRUE,
      {
        updateCheckboxInput(
          session = session,
          inputId = "captchaId",
          value = status()$success
        )
      }
    )

    return(status)
  })
}
