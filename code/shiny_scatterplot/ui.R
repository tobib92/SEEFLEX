library(shiny)
library(shinyjs)
library(htmlwidgets)

scatterplot_ui <- function(id) {
  ns <- shiny::NS(id)

  fluidPage(
    shinyjs::useShinyjs(),
    tags$script(htmlwidgets::JS("$(document).on('shiny:sessioninitialized', function (event) {$('#reset_zoom').click();});")), # so plot dimensions are
    titlePanel("SEEFLEX: Scatterplots of latent dimensions"),
    sidebarLayout(
      sidebarPanel(
        radioButtons(
          ns("lda"), NULL,
          choices = c(
            "14-cat LDA" = "lda14",
            "25-cat LDA" = "lda25"
          ),
          selected = "lda14", inline = TRUE
        ),
        selectInput(ns("y"), "y-axis (vertical)",
          choices = label_dim,
          selected = "LD1"
        ),
        selectInput(ns("x"), "x-axis (horizontal)",
          choices = label_dim,
          selected = "LD2"
        ),
        radioButtons(ns("granularity"), "number of operators",
          choices = c("14" = "n14", "25" = "n25"),
          selected = "n14", inline = TRUE
        ),
        radioButtons(ns("filter"), "filter variable",
          choices = c("grade", "t.curr"),
          selected = "grade", inline = TRUE
        ),
        checkboxInput(ns("ellipses"), "confidence ellipses", value = TRUE),
        tags$hr(style = "height: 3px; background: #DDD;"),

        conditionalPanel(
          condition = ns("granularity") == 'n14',
          checkboxGroupInput(
            ns("show_OPERATOR.14"), "operators",
            choices = label_cat.operator.14,
            selected = label_cat.operator.14, inline = TRUE
          )
        ),
        conditionalPanel(
          condition = ns("granularity") == 'n25',
          checkboxGroupInput(
            ns("show_OPERATOR.25"), "operators",
            choices = label_cat.operator.25,
            selected = label_cat.operator.25, inline = TRUE
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
        # radioButtons("focus_mode", "text mode",
        #              choices=c("both"="both", "written"="W", "spoken"="S"), selected="both",
        #              inline=TRUE),
        # radioButtons("focus_variety", "language variety",
        #              choices=c("all", names(symbols.vec)), selected="all",
        #              inline=TRUE),
        # conditionalPanel(condition="input.granularity == 'n14'",
        #                  checkboxGroupInput("show_textcat12", "text categories",
        #                                     choices=label2cat.12, selected=label2cat.12,
        #                                     inline=TRUE)),
        # conditionalPanel(condition="input.granularity == 'n20'",
        #                  checkboxGroupInput("show_textcat20", "text categories",
        #                                     choices=label2cat.20, selected=label2cat.20,
        #                                     inline=TRUE)),
        # conditionalPanel(condition="input.granularity == 'n32'",
        #                  checkboxGroupInput("show_textcat32", "text categories",
        #                                     choices=label2cat.32, selected=label2cat.32,
        #                                     inline=TRUE)),
        tags$hr(style = "height: 3px; background: #DDD;"),
        sliderInput(ns("pointsize"), "point size",
          min = 1, max = 6, value = 4, step = .1
        ),
        checkboxInput(ns("transitions"), "use transitions", value = FALSE),
        tags$p( # actionButton("scatterD3-reset-zoom", HTML("<span class='glyphicon glyphicon-search' aria-hidden='true'></span> Reset Zoom")),
          actionButton("reset_zoom", HTML("<span class='glyphicon glyphicon-search' aria-hidden='true'></span> Reset Zoom"),
            onclick = paste(
              sprintf(zoom.set.code, zoom.default$xmin, zoom.default$xmax, zoom.default$ymin, zoom.default$ymax),
              "return true;"
            )
          ),
          tags$a(
            id = "scatterD3-svg-export", href = "#", class = "btn btn-default",
            HTML("<span class='glyphicon glyphicon-save' aria-hidden='true'></span> Download SVG")
          ),
          # actionButton("scatterD3-lasso-toggle", HTML("<span class='glyphicon glyphicon-screenshot' aria-hidden='true'></span> Toggle Lasso"),
          # "data-toggle" = "button")),
          downloadButton(ns("download_plot"), "Download Interactive Plot", icon("download"), disabled = FALSE)
        ),
        tags$hr(style = "height: 3px; background: #DDD;"),
        selectInput(ns("preset"), "choose a preset:",
          choices = scatterplot_presets.choices, selected = "default"
        ),
        tags$hr(style = "height: 3px; background: #DDD;"),
        downloadButton(ns("save_preset"), "Save Preset", icon("download"), disabled = TRUE),
        checkboxGroupInput(ns("save_preset_options"), "",
          choices = c(
            "include all textcat selections" = "allcat",
            "include current zoom" = "viewport"
          ),
          selected = NULL, inline = FALSE
        ),
        width = 3
      ),
      mainPanel(
        verbatimTextOutput(ns("debugOutput")),
        scatterD3Output(ns("scatterPlot"), width = "100%", height = "1200px"),
        width = 9
      )
    )
  )
}
