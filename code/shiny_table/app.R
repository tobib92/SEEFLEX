# This is a Shiny web application. You can run the application in RStudio
# by clicking the 'Run App' button at the top right of the editor pane.

library(shiny)
library(shinyjs)
library(ggplot2)
library(reshape2)
library(magrittr)
library(DT)
library(tidyverse)

if (file.exists(".Renviron")) {
  readRenviron(".Renviron")
}

source("code/shiny_table/utilities.R")

source("code/shiny_table/app_setup.R")

###################################### UI ######################################

source("code/shiny_table/ui.R", local = TRUE)

#################################### Server ####################################

source("code/shiny_table/server.R", local = TRUE)


# Run the application
shinyApp(
  ui = table_ui("table"),
  server = function(input, output, session) {
    moduleServer("table", table_server)
  }
)

