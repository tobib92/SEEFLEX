#### Set working directory to the SEEFLEX root folder ####

vars <- load("data/gma/shiny_data.rda")

# mappings between codes/short names and long names
mk.map <- function(x, y) structure(y, names = x)
inverse.map <- function(x) mk.map(x, names(x))

max.files <- 1000 # how many plots can be cached (ca. 0.2 MB / plot)
persistent_cache <- FALSE # set to FALSE for development
if (persistent_cache) {
  # cache up to 1000 plots = ca. 200 MB
  shinyOptions(cache = diskCache("./cache", max_n = max.files))
}

# define presets (which set all listed inputs to the specified values)
source("code/shiny_weights/presets.R", local = TRUE) # load user presets from external file

cats <- function(granularity) {
  switch(granularity,
    n17 = unique(seeflex_meta$OPERATOR.17),
    n25 = unique(seeflex_meta$OPERATOR.25),
    stop("invalid granularity=", granularity)
  )
}

Builtin <- list(
  default = list(
    name = "default settings",
    lda = "lda17",
    dim = "Dimension 1",
    y = "contribution",
    granularity = "n17",
    focus_t.curr = unname(label_t.curr),
    focus_grade = unname(label_grade),
    show_OPERATOR.17 = character(),
    show_OPERATOR.25 = character()
  ),
  allcat = list(
    name = "include all categories",
    show_OPERATOR.17 = label_cat.operator.17,
    show_OPERATOR.25 = label_cat.operator.25
  ),
  nocat = list(
    name = "hide all categories",
    show_OPERATOR.17 = character(),
    show_OPERATOR.25 = character()
  )
)

weights_presets <- c(Builtin, Presets)
weights_presets.choices <- mk.map(sapply(weights_presets, function(x) x$name), names(weights_presets))
