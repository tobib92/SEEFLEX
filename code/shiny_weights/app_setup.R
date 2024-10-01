vars <- load("../../data/20240905_shiny_data.rda")
# vars <- load("../shiny weights/data.rda")

# mappings between codes/short names and long names
mk.map <- function(x, y) structure(y, names = x)
inverse.map <- function(x) mk.map(x, names(x))

max.files <- 1000 # how many plots can be cached (ca. 0.2 MB / plot)
persistent_cache <- TRUE # set to FALSE for development
if (persistent_cache) {
  # cache up to 1000 plots = ca. 200 MB
  shinyOptions(cache = diskCache("./cache", max_n = max.files))
}

# define presets (which set all listed inputs to the specified values)
source("../shiny_weights/presets.R", local = TRUE) # load user presets from external file

cats <- function(granularity) {
  switch(granularity,
    n14 = unique(seeflex_meta$OPERATOR.14),
    n25 = unique(seeflex_meta$OPERATOR.25),
    stop("invalid granularity=", granularity)
  )
}

Builtin <- list(
  default = list(
    name = "default settings",
    lda = "lda14",
    dim = "Dimension 1",
    y = "contribution",
    granularity = "n14",
    focus_t.curr = unname(label_t.curr),
    focus_grade = unname(label_grade),
    show_OPERATOR.14 = character(),
    show_OPERATOR.25 = character()
  ),
  allcat = list(
    name = "include all categories",
    show_OPERATOR.14 = label_cat.operator.14,
    show_OPERATOR.25 = label_cat.operator.25
  ),
  # allwritten = list(name="include all written categories",
  #                   show_OPERATOR.14=mode2cats("n12", "W"),
  #                   show_OPERATOR.25=mode2cats("n20", "W"),
  #                   show_textcat32=mode2cats("n32", "W")),
  # allspoken = list(name="include all spoken categories",
  #                  show_textcat12=mode2cats("n12", "S"),
  #                  show_textcat20=mode2cats("n20", "S"),
  #                  show_textcat32=mode2cats("n32", "S")),
  nocat = list(
    name = "hide all categories",
    show_OPERATOR.14 = character(),
    show_OPERATOR.25 = character()
  )
)

weights_presets <- c(Builtin, Presets)
weights_presets.choices <- mk.map(sapply(weights_presets, function(x) x$name), names(weights_presets))
