library(shiny)
library(magrittr)

source("../shiny_scatterplot/app_setup.R")
source("../shiny_scatterplot/ui.R")
source("../shiny_scatterplot/server.R")

source("../shiny_weights/app_setup.R")
source("../shiny_weights/ui.R")
source("../shiny_weights/server.R")

ui <- fluidPage(
  tabsetPanel(
    id = "tabset",
    tabPanel("Scatterplots of latent dimensions", scatterplot_ui("scatter")),
    tabPanel("Feature weights and contributions", weights_ui("weights"))
  )
)

server <- function(input, output, session) {
  callModule(scatterplot_server, "scatter")
  callModule(weights_server, "weights")
}

shinyApp(ui, server)
