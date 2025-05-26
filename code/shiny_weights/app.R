# This is a Shiny web application. You can run the application in RStudio
# by clicking the 'Run App' button at the top right of the editor pane.

library(shiny)
library(shinyjs)
library(ggplot2)
library(reshape2)
library(magrittr)

if (file.exists(".Renviron")) {
  readRenviron(".Renviron")
}

source("code/shiny_weights/utilities.R")

source("code/shiny_weights/app_setup.R")

###################################### UI ######################################

source("code/shiny_weights/ui.R", local = TRUE)

#################################### Server ####################################

source("code/shiny_weights/server.R", local = TRUE)


# Run the application
shinyApp(
  ui = weights_ui("weights"),
  server = function(input, output, session) {
    moduleServer("weights", weights_server)
  }
)
