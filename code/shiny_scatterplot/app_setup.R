#### Set working directory to the SEEFLEX root folder ####

vars <- load("data/gma/20250519_shiny_data.rda")

## mappings between codes/short names and long names
mk.map <- function(x, y) structure(y, names = x)
inverse.map <- function(x) mk.map(x, names(x))

zoom.set.code <- "
Shiny.setInputValue('scatter-xmin', %g);
Shiny.setInputValue('scatter-xmax', %g);
Shiny.setInputValue('scatter-ymin', %g);
Shiny.setInputValue('scatter-ymax', %g);
"
zoom.default <- list(xmin = -2.3, xmax = 2.3, ymin = -2.3, ymax = 2.3)

## define presets (which set all listed inputs to the specified values)

source("code/shiny_scatterplot/presets.R", local = TRUE) # load user presets from external file

Builtin <- list(
  default = list(
    name = "Default",
    lda = "lda_genre",
    y = "Dimension 1", x = "Dimension 2",
    granularity = "n17",
    ellipses = TRUE,
    # focus_mode = "both",
    # focus_variety = "all",
    show_OPERATOR.17 = label_cat.operator.17,
    show_OPERATOR.25 = label_cat.operator.25,
    pointsize = 4,
    transitions = FALSE,
    viewport = zoom.default
  ),
  allcat = list(
    name = "show all operators",
    show_OPERATOR.17 = label_cat.operator.17,
    show_OPERATOR.25 = label_cat.operator.25
  ),
  nocat = list(
    name = "hide all operators",
    show_OPERATOR.17 = character(),
    show_OPERATOR.25 = character()
  )
)

scatterplot_presets <- c(Builtin, Presets)
scatterplot_presets.choices <- mk.map(sapply(scatterplot_presets, function(x) x$name), names(scatterplot_presets))
