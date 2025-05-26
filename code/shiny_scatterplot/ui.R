library(shiny)
library(shinyjs)
library(htmlwidgets)
library(shinyBS)

# tooltip_what <- HTML( # Jon's code
#   'What <i class="fa fa-info-circle text-primary" data-toggle="tooltip"
#   title="This is the first line.<br>This is the second line."></i>'
# )

#### Define tooltip text ####

tooltip_lda_scatter <- HTML(
  paste(
    "Choose between the unsupervised Principal Component Analysis (PCA) and the",
    "supervised Linear Discriminant Analysis (LDA). For the LDA, select the",
    "variable that was passed as class into the supervised LDA."
  )
)

tooltip_transitions_scatter <- HTML(
  "Enabled this will show smooth transitions between the two versions of the plot."
)

tooltip_filter_scatter <- HTML(
  "Choose the variables to be distinguished by colors and symbols and toggle confidence ellipses."
)

tooltip_granularity_scatter <- HTML(
  "Choose between the Operator 17 and Operator 25 granularity."
)

tooltip_deselect1_scatter <- HTML(
  "Subset the data depending on different variables."
)

tooltip_deselect2_scatter <- HTML(
  "Subset the data depending on different variables."
)

tooltip_reset_zoom_scatter <- HTML(
  'Zoom reset will always reset to selected preset. Choose "Default" preset to reset to start-up zoom.'
)

#### Scatterplot UI ####

scatterplot_ui <- function(id) {
  ns <- shiny::NS(id)

  fluidPage(
    shinyjs::useShinyjs(),

    # Formatting for tooltip help texts
    tags$head(tags$style(HTML(".tooltip-inner { text-align: left; }"))),
    tags$script(htmlwidgets::JS(
      "$(document).on('shiny:sessioninitialized',
      function (event) {$('#reset_zoom').click();});"
    )),

    #### UI Title ####
    titlePanel("SEEFLEX: Scatterplots of latent dimensions"),
    sidebarLayout(
      sidebarPanel(
        helpText(
          "NB: The Shiny applications are based on the work by Stephanie Evert
                 and Stella Neumann (Neumann & Evert, 2021). The code can be accessed",
          tags$a(href = "https://www.stephanie-evert.de/PUB/NeumannEvert2021/", "here.")
        ),
        tags$hr(style = "height: 2px; background: #DDD;"),

        #### LDA radio button and tooltip ####
        bsTooltip(ns("info_lda"), tooltip_lda_scatter, trigger = "hover", placement = "right"),
        radioButtons(
          ns("lda"),
          label = tagList("Multivariate analysis", actionButton(
            ns("info_lda"),
            label = tags$i(class = "fa fa-info-circle text-primary"),
            style = "border: none; background: transparent; cursor: pointer;"
          )),
          choices = c(
            "PCA" = "pca",
            "LDA Genre" = "lda_genre",
            "LDA Curricular task" = "lda_t.curr",
            "LDA Operator 17" = "lda_operator17",
            "LDA Operator 25" = "lda_operator25"
          ),
          selected = "lda_genre", inline = TRUE
        ),
        conditionalPanel(
          condition = paste0("input['", ns("lda"), "'] == 'pca'"),
          selectInput(ns("x"), "x-axis (horizontal)",
            choices = label_dim_pca,
            selected = "PC2"
          ),
        ),
        conditionalPanel(
          condition = paste0("input['", ns("lda"), "'] != 'pca'"),
          selectInput(ns("x"), "x-axis (horizontal)",
            choices = label_dim_lda,
            selected = "LD2"
          ),
        ),
        conditionalPanel(
          condition = paste0("input['", ns("lda"), "'] == 'pca'"),
          selectInput(ns("y"), "y-axis (vertical)",
            choices = label_dim_pca,
            selected = "PC1"
          ),
        ),
        conditionalPanel(
          condition = paste0("input['", ns("lda"), "'] != 'pca'"),
          selectInput(ns("y"), "y-axis (vertical)",
            choices = label_dim_lda,
            selected = "LD1"
          ),
        ),
        tags$hr(style = "height: 2px; background: #DDD;"),

        #### Preset ####
        selectInput(ns("preset"), "choose a preset:",
          choices = scatterplot_presets.choices, selected = "default"
        ),
        conditionalPanel(
          condition = "output.isDevMode",
          fluidRow(
            column(
              5, textInput(ns("name_preset"), label = NULL, placeholder = "Set preset name...")
            ),
            column(
              3, downloadButton(ns("save_preset"), "Save Preset", icon("download"))
            )
          ),
          checkboxGroupInput(ns("save_preset_options"), "",
            choices = c(
              "Include all textcat selections" = "allcat",
              "Include current zoom" = "viewport"
            ),
            selected = NULL, inline = FALSE
          )
        ),
        tags$hr(style = "height: 2px; background: #DDD;"),

        #### Color variable ####
        radioButtons(ns("filter_col"), "Filter color variable",
          choices = c("Operator 17", "Operator 25", "Curricular task", "Genre"),
          selected = "Operator 17", inline = TRUE
        ),

        #### Symbol variable ####
        radioButtons(ns("filter_sym"), "Filter symbol variable",
          choices = c("Grade", "Curricular task", "Genre"),
          selected = "Curricular task", inline = TRUE
        ),

        #### Confidence ellipses ####
        checkboxInput(ns("ellipses"), "Confidence ellipses", value = TRUE),
        tags$hr(style = "height: 2px; background: #DDD;"),

        #### Granularity and operator checkboxes ####
        bsTooltip(ns("info_granularity"), tooltip_granularity_scatter, trigger = "hover", placement = "right"),
        radioButtons(ns("granularity"),
          label = tagList(
            "Operators granularity", actionButton(
              ns("info_granularity"),
              label = tags$i(class = "fa fa-info-circle text-primary"),
              style = "border: none; background: transparent; cursor: pointer;"
            )
          ),
          choices = c("17" = "n17", "25" = "n25"),
          selected = "n17", inline = TRUE
        ),
        bsTooltip(ns("info_deselect1"), tooltip_deselect1_scatter, trigger = "hover", placement = "right"),
        conditionalPanel(
          condition = paste0("input['", ns("granularity"), "'] == 'n17'"),
          checkboxGroupInput(
            ns("show_OPERATOR.17"),
            label = tagList(
              "Operators 17", actionButton(
                ns("info_deselect1"),
                label = tags$i(class = "fa fa-info-circle text-primary"),
                style = "border: none; background: transparent; cursor: pointer;"
              )
            ),
            choices = label_cat.operator.17,
            selected = label_cat.operator.17, inline = TRUE
          )
        ),
        bsTooltip(ns("info_deselect2"), tooltip_deselect2_scatter, trigger = "hover", placement = "right"),
        conditionalPanel(
          condition = paste0("input['", ns("granularity"), "'] == 'n25'"),
          checkboxGroupInput(
            ns("show_OPERATOR.25"),
            label = tagList(
              "Operators 25", actionButton(
                ns("info_deselect2"),
                label = tags$i(class = "fa fa-info-circle text-primary"),
                style = "border: none; background: transparent; cursor: pointer;"
              )
            ),
            choices = label_cat.operator.25,
            selected = label_cat.operator.25, inline = TRUE
          )
        ),

        #### Curricular task focus ####
        checkboxGroupInput(
          inputId = ns("focus_t.curr"),
          label = "Curricular task",
          choices = label_t.curr,
          selected = unname(label_t.curr),
          inline = TRUE
        ),

        #### Genre focus ####
        checkboxGroupInput(
          inputId = ns("focus_genre"),
          label = "Genre",
          choices = label_genre,
          selected = unname(label_genre),
          inline = TRUE
        ),

        #### Grade focus ####
        checkboxGroupInput(
          inputId = ns("focus_grade"),
          label = "Grade level",
          choices = label_grade,
          selected = unname(label_grade),
          inline = TRUE
        ),
        tags$hr(style = "height: 2px; background: #DDD;"),

        #### Point size ####
        sliderInput(ns("pointsize"), "point size",
          min = 1, max = 6, value = 5, step = .1
        ),

        #### Transitions ####
        bsTooltip(ns("info_transitions"), tooltip_transitions_scatter,
          trigger = "hover", placement = "right"
        ),
        checkboxInput(ns("transitions"), label = tagList(
          "Use transitions", actionButton(
            ns("info_transitions"),
            label = tags$i(class = "fa fa-info-circle text-primary"),
            style = "border: none; background: transparent; cursor: pointer;"
          )
        ), value = FALSE),

        #### ScatterD3 buttons ####
        tags$p(
          tags$a(
            id = "scatterD3-svg-export", href = "#", class = "btn btn-default",
            HTML("<span class='glyphicon glyphicon-save' aria-hidden='true'></span> Download SVG"),
          ),
          actionButton("scatterD3-lasso-toggle", HTML("<span class='glyphicon glyphicon-screenshot' aria-hidden='true'></span> Toggle Lasso"),
            "data-toggle" = "button"
          ),
          actionButton("scatterD3-reset-zoom", HTML("<span class='glyphicon glyphicon-search' aria-hidden='true'></span> Reset Zoom")),
          bsTooltip(ns("info_reset_zoom"), tooltip_reset_zoom_scatter, trigger = "hover", placement = "right"),
          tagList(
            # "scatterD3-reset-zoom",
            actionButton(
              ns("info_reset_zoom"),
              label = tags$i(class = "fa fa-info-circle text-primary"),
              style = "border: none; background: transparent; cursor: pointer;"
            )
          )
        ),
        tags$hr(style = "height: 2px; background: #DDD;"),

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
