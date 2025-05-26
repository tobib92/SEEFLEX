library(shiny)
library(shinyBS)

# tooltip_what <- HTML( # Jon's code
#   'What <i class="fa fa-info-circle text-primary" data-toggle="tooltip"
#   title="This is the first line.<br>This is the second line."></i>'
# )

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
  "Select the dimension of the Linear Discriminant Analysis (LDA)."
)

tooltip_lda_weights <- HTML(
  paste(
    "Choose between the unsupervised Principal Component Analysis (PCA) and the",
    "supervised Linear Discriminant Analysis (LDA). For the LDA, select the",
    "variable that was passed as class into the supervised LDA.<br><br>",
    "<b>NB:</b> If an error occurs (Index out of bounds), switch dimensions to reset",
    "the selection."
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

weights_ui <- function(id) {
  ns <- NS(id)

  fluidPage(
    useShinyjs(),

    # Formatting for tooltip help texts
    tags$head(tags$style(HTML(".tooltip-inner { text-align: left; }"))),

    #### UI Title ####
    titlePanel("SEEFLEX: Feature weights and contributions"),
    sidebarLayout(
      sidebarPanel(

        #### Text field with Neumann & Evert Reference ####
        helpText(
          "NB: The Shiny applications are based on the work by Stephanie Evert
                 and Stella Neumann (Neumann & Evert, 2021). The code can be accessed",
          tags$a(href = "https://www.stephanie-evert.de/PUB/NeumannEvert2021/", "here.")
        ),
        tags$hr(style = "height: 2px; background: #DDD;"),

        #### LDA radio button and tooltip ####
        bsTooltip(ns("info_lda"), tooltip_lda_weights, trigger = "hover", placement = "right"),
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

        #### Dimension input ####
        bsTooltip(ns("info_dim"), tooltip_dim, trigger = "hover", placement = "right"),
        conditionalPanel(
          condition = paste0("input['", ns("lda"), "'] == 'pca'"),
          selectInput(
            ns("dim"),
            label = tagList("Dimension", actionButton(
              ns("info_dim"),
              label = tags$i(class = "fa fa-info-circle text-primary"),
              style = "border: none; background: transparent; cursor: pointer;"
            )),
            choices = label_dim_pca,
            selected = "PC2"
          ),
        ),
        conditionalPanel(
          condition = paste0("input['", ns("lda"), "'] != 'pca'"),
          selectInput(
            ns("dim"),
            label = tagList("Dimension", actionButton(
              ns("info_dim"),
              label = tags$i(class = "fa fa-info-circle text-primary"),
              style = "border: none; background: transparent; cursor: pointer;"
            )),
            choices = label_dim_lda,
            selected = "LD1"
          ),
        ),

        #### What input and tooltip
        bsTooltip(ns("info_what"), tooltip_what, trigger = "hover", placement = "right"),
        selectInput(
          ns("y"),
          # label = tooltip_what,
          label = tagList("What", actionButton(
            ns("info_what"),
            label = tags$i(class = "fa fa-info-circle text-primary"),
            style = "border: none; background: transparent; cursor: pointer;"
          )),
          choices = c("features", "weighted", "contribution"),
          selected = "weighted"
        ),
        tags$hr(style = "height: 2px; background: #DDD;"),

        #### Presets ####
        selectInput(ns("preset"), "Choose a preset:",
          choices = weights_presets.choices, selected = "default"
        ),

        # Preset buttons only appear locally
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
              "include all operator selections" = "allcat"
            ),
            selected = NULL, inline = FALSE
          )
        ),

        tags$hr(style = "height: 2px; background: #DDD;"),

        #### Granularity and operator checkboxes ####
        bsTooltip(ns("info_granularity"), tooltip_granularity_weights, trigger = "hover", placement = "right"),
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
        bsTooltip(ns("info_deselect1"), tooltip_deselect1_weights, trigger = "hover", placement = "right"),
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
        bsTooltip(ns("info_deselect2"), tooltip_deselect2_weights, trigger = "hover", placement = "right"),
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

        #### t.curr, genre, and grade checkboxes ####
        checkboxGroupInput(
          inputId = ns("focus_t.curr"),
          label = "Curricular task",
          choices = label_t.curr,
          selected = unname(label_t.curr),
          inline = TRUE
        ),
        checkboxGroupInput(
          inputId = ns("focus_genre"),
          label = "Genre",
          choices = label_genre,
          selected = unname(label_genre),
          inline = TRUE
        ),
        checkboxGroupInput(
          inputId = ns("focus_grade"),
          label = "Grade level",
          choices = label_grade,
          selected = unname(label_grade),
          inline = TRUE
        ),
        tags$hr(style = "height: 2px; background: #DDD;"), # horizontal line

        #### Feature selection ####
        bsTooltip(ns("info_deselect3"), tooltip_deselect3_weights, trigger = "hover", placement = "right"),
        radioButtons(
          ns("feature_deselect"),
          label = tagList(
            "Linguistic feature selection", actionButton(
              ns("info_deselect3"),
              label = tags$i(class = "fa fa-info-circle text-primary"),
              style = "border: none; background: transparent; cursor: pointer;"
            )
          ),
          choices = c(
            "All features" = "all_features",
            "Select features" = "selected_features",
            "Select weights limit" = "weights_limit_features"
          ),
          selected = "all_features",
          inline = TRUE
        ),
        conditionalPanel(
          condition = paste0("input['", ns("feature_deselect"), "'] == 'selected_features'"),
          checkboxGroupInput(
            inputId = ns("focus_feature"),
            label = "Select linguistic features",
            choices = feature.names,
            selected = "word_S",
            inline = TRUE
          )
        ),
        conditionalPanel(
          condition = paste0("input['", ns("feature_deselect"), "'] == 'weights_limit_features'"),
          numericInput(
            inputId = ns("focus_weight"),
            label = "Adjust minimum weight",
            value = 0,
            min = 0,
            max = 1,
            step = .05
          )
        ),
        tags$hr(style = "height: 2px; background: #DDD;"), # horizontal line

        #### Plot size and settings ####
        radioButtons(ns("plot_size"), "display size",
          choices = c("S", "M", "L", "XL"), selected = "M",
          inline = TRUE
        ),
        checkboxInput(
          ns("use_legend"), "legend in sidebar",
          value = TRUE),
        checkboxInput(
          ns("use_ylim_box"), "set y-axis limit for boxplots",
          value = FALSE
        ),
        checkboxInput(
          ns("use_ylim_disc"), "set y-axis limit for discriminant plots",
          value = FALSE
        ),
        tags$hr(style = "height: 2px; background: #DDD;"), # horizontal line


        width = 3
      ),
      mainPanel(
        verbatimTextOutput(ns("debugOutput")),
        plotOutput(ns("boxplot"), width = "1200px", height = "900px"),
        plotOutput(ns("densities"), width = "1200px", height = "200px"),
        width = 9
      )
    )
  )
}
