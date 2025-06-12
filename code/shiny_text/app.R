# This is a Shiny web application. You can run the application in RStudio
# by clicking the 'Run App' button at the top right of the editor pane.

library(shiny)
library(shinyjs)
library(reshape2)
library(magrittr)
library(tidyverse)
library(shinyAce)


if (file.exists(".Renviron")) {
  readRenviron(".Renviron")
}

source("code/shiny_text/app_setup.R")

###################################### UI ######################################

source("code/shiny_text/ui.R", local = TRUE)

#################################### Server ####################################

source("code/shiny_text/server.R", local = TRUE)


# Run the application
shinyApp(
  ui = text_ui("table"),
  server = function(input, output, session) {
    moduleServer("table", text_server)
  }
)

