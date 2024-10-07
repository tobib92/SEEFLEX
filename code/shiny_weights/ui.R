library(shiny)

weights_ui <- function(id) {
  ns <- NS(id)

  fluidPage(
    useShinyjs(),
    titlePanel("SEEFLEX: Feature weights and contributions"),
    # div(class="row",
    #     div(class="col-md-12",
    #         div(class="alert alert-warning alert-dismissible",
    #             HTML('<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>'),
    #             HTML("<strong>Alert box</strong>")))),
    sidebarLayout(
      sidebarPanel(
        helpText("NB: The Shiny applications are based on the work by Stephanie Evert
                 and Stella Neumann (Neumann & Evert, 2021). The code can be accessed",
                 tags$a(href = "https://www.stephanie-evert.de/PUB/NeumannEvert2021/", "here")),
        tags$hr(style = "height: 2px; background: #DDD;"),
        radioButtons(
          ns("lda"), NULL,
          choices = c("14-cat LDA" = "lda14", "25-cat LDA" = "lda25"),
          selected = "lda14", inline = TRUE
        ),
        selectInput(
          ns("dim"), "dimension",
          choices = unname(dim_label),
          selected = "Dimension 1"
        ),
        selectInput(
          ns("y"), "y-axis",
          choices = c("features", "weighted", "contribution"),
          selected = "contribution"
        ),
        radioButtons(
          ns("granularity"), "number of operators",
          choices = c("14" = "n14", "25" = "n25"), selected = "n14",
          inline = TRUE
        ),
        conditionalPanel(
          condition = "input.granularity == 'n14'",
          checkboxGroupInput(
            ns("show_OPERATOR.14"), "operators",
            choices = label_cat.operator.14,
            selected = NULL, inline = TRUE
          )
        ),
        conditionalPanel(
          condition = "input.granularity == 'n25'",
          checkboxGroupInput(
            ns("show_OPERATOR.25"), "operators",
            choices = label_cat.operator.25,
            selected = NULL, inline = TRUE
          )
        ),
        checkboxGroupInput(
          inputId = ns("focus_t.curr"),
          label = "curricular task",
          choices = label_t.curr,
          selected = unname(label_t.curr),
          inline = TRUE
        ),
        checkboxGroupInput(
          inputId = ns("focus_grade"),
          label = "grade level",
          choices = label_grade,
          selected = unname(label_grade),
          inline = TRUE
        ),
        # radioButtons(inputId = "focus_grade",
        #              label = "grade level",
        #              choices = c("all", levels(seeflex_meta$GRADE)),
        #              selected="all",
        #              inline=TRUE),
        tags$hr(style = "height: 3px; background: #DDD;"), # horizontal line
        radioButtons(ns("plot_size"), "display size",
          choices = c("S", "M", "L", "XL"), selected = "M",
          inline = TRUE
        ),
        checkboxInput(ns("use_legend"), "legend in sidebar", value = TRUE),
        checkboxInput(
          ns("use_ylim_box"), "set y-axis limit for boxplots",
          value = FALSE
        ),
        checkboxInput(
          ns("use_ylim_disc"), "set y-axis limit for discriminant plots",
          value = FALSE
        ),
        tags$hr(style = "height: 3px; background: #DDD;"), # horizontal line
        selectInput(ns("preset"), "choose a preset:",
          choices = weights_presets.choices, selected = "default"
        ),
        downloadButton(ns("downloadPDF"), "Download PDF", icon("download"), disabled = TRUE),
        tags$hr(style = "height: 3px; background: #DDD;"),
        downloadButton(ns("save_preset"), "Save Preset", icon("download"), disabled = TRUE),
        checkboxGroupInput(ns("save_preset_options"), "",
          choices = c("include all operator selections" = "allcat"),
          selected = NULL, inline = FALSE
        ),
        width = 3
      ),
      mainPanel(
        verbatimTextOutput(ns("debugOutput")),
        plotOutput(ns("boxplot"), width = "1050px", height = "700px"),
        plotOutput(ns("densities"), width = "1050px", height = "200px"),
        width = 9
      )
    )
  )
}
