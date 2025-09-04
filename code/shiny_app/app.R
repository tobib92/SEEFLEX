#### Set working directory to the SEEFLEX root folder ####

library(shiny)
library(magrittr)

if (file.exists(".Renviron")) {
  readRenviron(".Renviron")
}

if (Sys.getenv("WORKING_DIR") != "") {
  setwd(Sys.getenv("WORKING_DIR"))
}

source("code/shiny_scatterplot/app_setup.R")
source("code/shiny_scatterplot/ui.R")
source("code/shiny_scatterplot/server.R")

source("code/shiny_weights/app_setup.R")
source("code/shiny_weights/ui.R")
source("code/shiny_weights/server.R")

source("code/shiny_table/app_setup.R")
source("code/shiny_table/ui.R")
source("code/shiny_table/server.R")

source("code/shiny_text/app_setup.R")
source("code/shiny_text/ui.R")
source("code/shiny_text/server.R")

ui <- fluidPage(
  tabsetPanel(
    id = "tabset",
    tabPanel("Scatterplots of latent dimensions", scatterplot_ui("scatter")),
    tabPanel("Feature weights and contributions", weights_ui("weights")),
    tabPanel("Feature values and group means", table_ui("table")),
    tabPanel("Corpus text viewer", text_ui("text"))
  )
)

server <- function(input, output, session) {
  output$isDevMode <- reactive({
    Sys.getenv("APPLICATION_MODE") == "dev"
  })
  outputOptions(output, "isDevMode", suspendWhenHidden = FALSE)

  callModule(scatterplot_server, "scatter")
  callModule(weights_server, "weights")
  callModule(table_server, "table")
  callModule(text_server, "text")
}

shinyApp(ui, server)
