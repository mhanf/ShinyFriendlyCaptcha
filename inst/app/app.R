
library(shiny)
library(ShinyFriendlyCaptcha)
library(bslib)
library(thematic)

thematic::thematic_shiny(font = "auto")
theme_bslib<-bslib::bs_theme(version=5,bootswatch = "zephyr")
# theme_bslib<-bslib::bs_theme_update(theme_bslib,
#                                     primary = "#4195db",
#                                     secondary="#80b3d0",
#                                     success="#005859",
#                                     light = "#f4f4f4",
#                                     dark = "#02424a",
#                                     info="#57bdc0",
#                                     warning="#da7067",
#                                     danger="#a72842",
#                                     base_font = bslib::font_google("Quicksand"),
#                                     heading_font = bslib::font_google("Zilla Slab")
# )

# Define UI for application that draws a histogram
ui <- bootstrapPage(
  theme = theme_bslib,
  br(),
  div("exemple de texte pour tester la police"),
  sfc_output(id = "test",
             sitekey = Sys.getenv("captcha_sitekey"),
             lang = "fr",
             dark_mode = FALSE,
             eu_endpoint = FALSE,
             theme_bs5 = TRUE
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
    sitekey = Sys.getenv("captcha_sitekey"),
    eu_endpoint = FALSE
    )

  observe({
    output$success <- renderText(essai()$success)
    output$errors <- renderText(essai()$errors)
  })

}

# Run the application
shinyApp(ui = ui, server = server)
