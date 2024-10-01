vars <- load("../../data/20240905_shiny_data.rda")
## ByType4.df, ByType32.df, dim2label, symbols.vec,
## rainbow32.vec, rainbow20.vec, rainbow12.vec,
## types.variety, types.mode,
## types.short32, types.short20, types.short12,
## types.textcat32, types.textcat20, types.textcat12

## mappings between codes/short names and long names
mk.map <- function(x, y) structure(y, names = x)
inverse.map <- function(x) mk.map(x, names(x))

zoom.set.code <- "
Shiny.setInputValue('xmin', %g);
Shiny.setInputValue('xmax', %g);
Shiny.setInputValue('ymin', %g);
Shiny.setInputValue('ymax', %g);
"
zoom.default <- list(xmin = -3.1, xmax = 3.1, ymin = -3.1, ymax = 3.1)

## define presets (which set all listed inputs to the specified values)
# source("presets.R", local=TRUE) # load user presets from external file
# source("figures.R", local=TRUE) # presets for figures in the paper
Builtin <- list(
  default = list(
    name = "default settings",
    lda = "lda14",
    y = "Dimension 1", x = "Dimension 2",
    granularity = "n14",
    ellipses = FALSE,
    focus_mode = "both",
    focus_variety = "all",
    show_OPERATOR.14 = label_cat.operator.14,
    show_OPERATOR.25 = label_cat.operator.25,
    pointsize = 4,
    transitions = FALSE,
    viewport = zoom.default
  ),
  allcat = list(
    name = "show all operators",
    show_OPERATOR.14 = label_cat.operator.14,
    show_OPERATOR.25 = label_cat.operator.25
  ),
  nocat = list(
    name = "hide all operators",
    show_OPERATOR.14 = character(),
    show_OPERATOR.25 = character()
  )
)
scatterplot_presets <- c(Builtin)
# Figures,
# Presets)
scatterplot_presets.choices <- mk.map(sapply(scatterplot_presets, function(x) x$name), names(scatterplot_presets))
