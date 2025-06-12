library(shiny)
library(shinyBS)

#### Define tooltip text ####

tooltip_what <- HTML(
  paste(
    "<u>Features:</u> The boxplots show the standardized",
    "and log-transformed values for each text in the respective categories.<br>",
    "<u>Weighted:</u> The boxplots show the feature values above multiplied by the weights",
    "given to each feature by the Linear Discriminant Analysis (LDA).<br>",
    "<u>Contribution:</u> The boxplots show the feature values multiplied with the absolute",
    "values of the feature weights in the LDA. The (-) indicates a negative weight,",
    "which results in a negative contribution to the position on the feature space",
    "for that dimension."
  )
)

tooltip_dim <- HTML(
  paste(
    "Select the dimension of Principal Component Analysis (PCA) and",
    "the Linear Discriminant Analysis (LDA)."
  )
)

tooltip_lda_weights <- HTML(
  paste(
    "Choose between the unsupervised Principal Component Analysis (PCA) and the",
    "supervised Linear Discriminant Analysis (LDA). For the LDA, select the",
    "variable that was passed as class into the supervised LDA.<br><br>",
    "<b>NB:</b> If an error occurs (Index out of bounds), switch dimensions to reset",
    "the selection. Check dimension if Preset selection results in change of analysis!"
  )
)

tooltip_granularity_weights <- HTML(
  "Choose between the Operator 17 and Operator 25 granularity."
)

tooltip_deselect1_weights <- HTML(
  "Subset the data depending on different variables."
)

tooltip_deselect2_weights <- HTML(
  "Subset the data depending on different variables."
)

tooltip_deselect3_weights <- HTML(
  "Subset the feature set by selecting single features or setting a weights limit."
)

#### Weights UI ####

text_ui <- function(id) {
  ns <- NS(id)

  fluidPage(
    useShinyjs(),

    # Formatting for tooltip help texts
    tags$head(tags$style(HTML(".tooltip-inner { text-align: left; }"))),

    #### UI Title ####
    titlePanel("SEEFLEX: Student texts"),
    sidebarLayout(
      sidebarPanel(

        #### Text field with Neumann & Evert Reference ####
        helpText(
          "NB: This part of the app was published in",
          tags$a(href = "https://github.com/tobib92/SEEFLEX", "Pauls (2025).")
        ),

        tags$hr(style = "height: 2px; background: #DDD;"),

        #### Search bar ####
        textInput(
          ns("search_box"),
          "Enter student ID:",
          value = ""
          ),

        actionButton(
          ns("search_button"),
          "Search Files"
          ),

        br(),
        br(),

        selectInput(
          ns("selected_file"),
          "Select a file:",
          choices = NULL,
          multiple = FALSE,
          selectize = TRUE
          ),

        actionButton(
          ns("load_button"),
          "Load File"
          ),

        tags$hr(style = "height: 2px; background: #DDD;"), # horizontal line

        radioButtons(
          ns("viewMode"),
          "Display Mode:",
          choices = c("xml", "txt"),
          selected = "xml",
          inline = TRUE
          ),

        tags$hr(style = "height: 2px; background: #DDD;"), # horizontal line

        width = 3
      ),

      mainPanel(
        verticalLayout(

          verbatimTextOutput(ns("debugOutput")),

          h3("Text metadata"),
          tags$br(),

          uiOutput(ns("values_output")),

          tags$hr(style = "height: 2px; background: #DDD;"),
          tags$br(),

          h3("Text content"),
          tags$br(),

          # "Raw XML" uses the Ace Editor which supports syntax highlighting and word wrap
          conditionalPanel(
            condition = paste0("input['", ns("viewMode"), "'] == 'xml'"),
            aceEditor(
              outputId = ns("xmlEditor"),
              mode = "xml",
              theme = "textmate",
              wordWrap = TRUE,      # Enable word wrap to confine text within the window
              readOnly = TRUE,
              height = "500px",
              fontSize = 14,
              highlightActiveLine = TRUE,
              placeholder = "No file selected..."
            )
          ),

          # "Text Content" shows the XML with all nodes removed in a verbatim text output
          conditionalPanel(
            condition = paste0("input['", ns("viewMode"), "'] == 'txt'"),
            verbatimTextOutput(ns("plainTextDisplay"))
          )
        ),
        width = 9
      )
    )
  )
}
