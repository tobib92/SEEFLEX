# This is a Shiny web application. You can run the application in RStudio
# by clicking the 'Run App' button at the top right of the editor pane.

library(shiny)
library(shinyjs)
library(scatterD3)
library(htmlwidgets) # for saveWidget()
library(magrittr)

if (file.exists(".Renviron")) {
  readRenviron(".Renviron")
}

source("code/shiny_scatterplot/app_setup.R")

###################################### UI ######################################

source("code/shiny_scatterplot/ui.R", local = TRUE)

#################################### Server ####################################

source("code/shiny_scatterplot/server.R", local = TRUE)


# Run the application
shinyApp(
  ui = scatterplot_ui("scatter"),
  server = function(input, output, session) {
    moduleServer("scatter", scatterplot_server)
  }
)
