
library(shiny)
library(ShinyFriendlyCaptcha)
library(bslib)



# Define UI for application that draws a histogram
ui <- bootstrapPage(
  theme = bslib::bs_theme(version = 5,bootswatch = "darkly"),
  br(),

  sfc_output(id = "test",
             sitekey = Sys.getenv("captcha_sitekey"),
             lang = "fr",
             dark_mode = FALSE,
             eu_endpoint = FALSE,
             bs5_theme = "test"
             ),
  br(),
  textOutput("success"),
  textOutput("errors")
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  essai <- sfc_server(
    id = "test",
    secret = Sys.getenv("captcha_secret"),
    sitekey = Sys.getenv("captcha_sitekey")
    )

  observe({
    output$success <- renderText(essai()$success)
    output$errors <- renderText(essai()$errors)
  })

}

# Run the application
shinyApp(ui = ui, server = server)
