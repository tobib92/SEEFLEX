#### Set working directory to the SEEFLEX root folder ####

library(shiny)
library(magrittr)

if (file.exists(".Renviron")) {
  readRenviron(".Renviron")
}

source("code/shiny_scatterplot/app_setup.R")
source("code/shiny_scatterplot/ui.R")
source("code/shiny_scatterplot/server.R")

source("code/shiny_weights/app_setup.R")
source("code/shiny_weights/ui.R")
source("code/shiny_weights/server.R")

ui <- fluidPage(
  tabsetPanel(
    id = "tabset",
    tabPanel("Scatterplots of latent dimensions", scatterplot_ui("scatter")),
    tabPanel("Feature weights and contributions", weights_ui("weights"))
  )
)

server <- function(input, output, session) {
  output$isDevMode <- reactive({
    Sys.getenv("APPLICATION_MODE") == "dev"
  })
  outputOptions(output, "isDevMode", suspendWhenHidden = FALSE)

  callModule(scatterplot_server, "scatter")
  callModule(weights_server, "weights")
}

shinyApp(ui, server)
