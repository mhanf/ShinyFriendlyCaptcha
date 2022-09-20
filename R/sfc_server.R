#' Friendly Captcha input for usage in Shiny Server
#'
#' @param id The Friendly Captcha input id
#' @param secret The Friendly Captcha secret
#' @param sitekey The Friendly Captcha sitekey
#' @importFrom shiny moduleServer observe reactive isTruthy
#' @importfrom httr POST content
#' @importFrom jsonlite fromJSON
#' @return  Friendly Captcha input for usage in Shiny Server.
#' @export

sfc_server <- function(
    id,
    secret = Sys.getenv("captcha_secret"),
    sitekey = Sys.getenv("captcha_sitekey")
){

  moduleServer(id, function(input, output, session){
    # session ns
    ns <- session$ns
    # observe captcha_response
    # observe({
    #   print(input$captcha_response)
    # })
    # statut compilation
    status <- reactive({
      if (isTruthy(input$captcha_response)) {
        url <- "https://api.friendlycaptcha.com/api/v1/siteverify"
        resp <- httr::POST(
          url,
          body = list(
            secret = secret,
            solution = input$captcha_response
          ))
        jsonlite::fromJSON(httr::content(resp, "text", encoding = "UTF-8"))
      } else {
        list(success = FALSE,
             errors = ""
             )
      }
    })
    return(status)
  })
}
