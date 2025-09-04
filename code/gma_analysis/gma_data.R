#### Set working directory to the SEEFLEX root folder ####

library(corpora)

source("code/data_pipeline/meta_data.R")
seeflex_meta <- WD

# load features located in "code/gma/"
seeflex_features_original <- read.csv(
  "data/gma/20250410_seeflex_orig_features.tsv", sep = "")
# seeflex_features_corrected <- read.csv(
#   "output/seeflex_features.tsv", sep = "")
# seeflex_features_lexical_sophistication <- read.csv(
#   "output/seeflex_features.tsv", sep = "")
# seeflex_features_clean_text <- read.csv(
#   "output/seeflex_features.tsv", sep = "")

# mappings between codes/short names and long names (Neumann & Evert 2021)

mk.map <- function (x, y) structure(y, names=x)
inverse.map <- function (x) mk.map(x, names(x))

# all colors

c1_corp <- c(
  "#00559f"
)

c4_corp <- c(
  "#00559f", "#57ab27", "#f6a800", "#cc071e"
  )

c5_corp <- c(
  "#00559f", "#57ab27", "#f6a800", "#cc071e", "#7a6fac"
  )

c5_grey <- c(
  "#494848", "#636363", "#909090", "#B4B4B4", "#D4D4D4"
  )

c7_corp <- c(
  "#00559f", "#57ab27", "#f6a800", "#cc071e", "#bdcd00", "#00b1b7", "#7a6fac"
  )

c17_corp <- c(
  "#db4688", "#df4539", "#ce50d0", "#c4b442", "#77b5a5", "#767cda", "#c89ec9",
  "#71512c", "#d07f35", "#39212d", "#d57e7f", "#71aed0", "#833a52", "#344f3e",
  "#7342d3", "#3e275e", "#4fc445"
)

c25_corp <- c(
  "#db4688", "#597934", "#df4539", "#ce50d0", "#c4b442", "#77b5a5", "#767cda",
  "#c89ec9", "#91c43d", "#a14c96", "#71512c", "#d07f35", "#c2a67d", "#39212d",
  "#d57e7f", "#923428", "#69c282", "#71aed0", "#5b678a", "#833a52", "#4e2f91",
  "#344f3e", "#7342d3", "#4fc445", "#3e275e"
  )

# c30_corp <- c(
#   "#00559f", "#006265", "#0099a1", "#57ab27", "#bdcd00", "#f6a800", "#cc071e",
#   "#a11035", "#612158", "#7a6fac", "#407fb7", "#2d7f83", "#00b1b7", "#8dc060",
#   "#d1d95c", "#fabe50", "#d85c41", "#b65255", "#834e75", "#9b91c1", "#8EBAE5",
#   "#7DA4A7", "#89CCCF", "#B8D698", "#E0E69A", "#fdd48f", "#e69679", "#cd8b87",
#   "#a8859e", "#bcb5d7")


# all types
types.grade <- c(
  "10", "11", "12"
  )

types.t.curr <- c(
  "analysis", "argumentative", "creative", "int.reading", "mediation"
  )

types.genre <- c(
  "describing", "entertaining", "explaining", "inquiring", "persuading",
  "recounting", "responding"
  )

types.operator.17 <- c(
  "analyze",
  "blog",
  "characterize",
  "comment",
  "describe",
  "dialogue",
  "diary",
  "formal_letter",
  "informal_e-mail",
  "interior_monologue",
  "magazine",
  "point_out",
  "report",
  "sonnet_paraphrase",
  "speech",
  "story",
  "summarize"
)

types.operator.25 <- c(
  "analyze",
  "assess",
  "blog",
  "characterize",
  "comment",
  "describe",
  "dialogue",
  "diary",
  "discuss",
  "explain",
  "formal_letter",
  "informal_e-mail",
  "informal_letter",
  "interior_monologue",
  "magazine",
  "news",
  "outline",
  "point_out",
  "present",
  "report",
  "soliloquy",
  "sonnet_paraphrase",
  "speech",
  "story",
  "summarize"
  )


# all labels
labels.grade <- c(
  "Year 10", "Year 11", "Year 12"
  )

labels.t.curr <- c(
  "Analysis", "Argumentative Writing", "Creative Writing",
  "Integrated Reading Comprehension", "Mediation"
  )

labels.t.curr.short <- c(
  "Analysis", "Argumentative", "Creative", "Integrated Read. Comp.",
  "Mediation"
  )

labels.genre <- c(
  "Describing", "Entertaining", "Explaining", "Inquiring", "Persuading",
  "Recounting", "Responding"
  )

labels.operator.17 <- c(
  "Analysis",
  "Blog post",
  "Characterization",
  "Comment",
  "Description",
  "Dialogue",
  "Diary entry",
  "Formal letter",
  "Informal e-mail",
  "Interior monologue",
  "Magazine",
  "Point out",
  "Report",
  "Sonnet paraphrase",
  "Speech",
  "Story",
  "Summary"
  )

labels.operator.25 <- c(
  "Analysis",
  "Assessment",
  "Blog post",
  "Characterization",
  "Comment",
  "Description",
  "Dialogue",
  "Diary entry",
  "Discussion",
  "Explanation",
  "Formal letter",
  "Informal e-mail",
  "Informal letter",
  "Interior monologue",
  "Magazine",
  "News",
  "Outline",
  "Point out",
  "Presentation",
  "Report",
  "Soliloquy",
  "Sonnet Paraphrase",
  "Speech",
  "Story",
  "Summary"
  )

types.operator.mediation <-  c(
  "magazine", "informal_e-mail", "diary", "monologue", "summarize"
  )


# bundle label
bundle_label <- c(
  "orig" = "original",
  "corr" = "corrected",
  "lexs" = "lexical sophistication",
  "cltx" = "clean text"
  )


# all dimension labels
dim_label_lda <- c(
  "Dim1" = "Dimension 1",
  "Dim2" = "Dimension 2",
  "Dim3" = "Dimension 3",
  "Dim4" = "Dimension 4"
  )

dim_label_pca <- c(
  "Dim1" = "Dimension 1",
  "Dim2" = "Dimension 2",
  "Dim3" = "Dimension 3",
  "Dim4" = "Dimension 4"
  )

dim_label_lda_short <- c(
  "Dim1" = "Dim1", # short labels for plots
  "Dim2" = "Dim2",
  "Dim3" = "Dim3",
  "Dim4" = "Dim4"
  )

dim_label_pca_short <- c(
  "Dim1" = "Dim1", # short labels for plots
  "Dim2" = "Dim2",
  "Dim3" = "Dim3",
  "Dim4" = "Dim4"
  )
# # all dimension labels
# dim_label_lda <- c(
#   "LD1" = "Linear discriminant 1",
#   "LD2" = "Linear discriminant 2",
#   "LD3" = "Linear discriminant 3",
#   "LD4" = "Linear discriminant 4"
#   )
#
# dim_label_pca <- c(
#   "PC1" = "Principal component 1",
#   "PC2" = "Principal component 2",
#   "PC3" = "Principal component 3",
#   "PC4" = "Principal component 4"
#   )
#
# dim_label_lda_short <- c(
#   "LD1" = "LD1", # short labels for plots
#   "LD2" = "LD2",
#   "LD3" = "LD3",
#   "LD4" = "LD4"
#   )
#
# dim_label_pca_short <- c(
#   "PC1" = "PC1", # short labels for plots
#   "PC2" = "PC2",
#   "PC3" = "PC3",
#   "PC4" = "PC4"
#   )

label_dim_lda <- inverse.map(dim_label_lda)
label_dim_lda_short <- inverse.map(dim_label_lda_short) # shorter labels

label_dim_pca <- inverse.map(dim_label_pca)
label_dim_pca_short <- inverse.map(dim_label_pca_short) # shorter labels

label_cat.operator.17 <- mk.map(labels.operator.17, types.operator.17)
cat_label.operator.17 <- inverse.map(label_cat.operator.17)

label_cat.operator.25 <- mk.map(labels.operator.25, types.operator.25)
cat_label.operator.25 <- inverse.map(label_cat.operator.25)

label_t.curr <- mk.map(labels.t.curr, types.t.curr)
cat_label_t.curr <- inverse.map(label_t.curr)

label_grade <- mk.map(labels.grade, types.grade)
cat_label_grade <- inverse.map(label_grade)

label_genre <- mk.map(labels.genre, types.genre)
cat_label_genre <- inverse.map(label_genre)

# all color vectors

c1_corp.vec <- c(
  "No color variable" = "#00559f"
)

c5_corp.vec <- c(
  "analysis" = "#00559f",
  "argumentative" = "#57ab27",
  "creative" = "#f6a800",
  "int.reading" = "#cc071e",
  "mediation" = "#7a6fac"
  )

c7_corp.vec <- c(
  "describing" = "#00559f",
  "entertaining" = "#57ab27",
  "explaining" = "#f6a800",
  "inquiring" = "#cc071e",
  "persuading" = "#bdcd00",
  "recounting" = "#00b1b7",
  "responding" = "#7a6fac"
  )


c17_corp.vec <- c(
  "analyze" =            "#db4688",
  "blog" =               "#df4539",
  "characterize" =       "#ce50d0",
  "comment" =            "#c4b442",
  "describe" =           "#77b5a5",
  "dialogue" =           "#767cda",
  "diary" =              "#c89ec9",
  "formal_letter" =      "#71512c",
  "informal_e-mail" =    "#d07f35",
  "interior_monologue" = "#39212d",
  "magazine" =           "#d57e7f",
  "point_out" =          "#71aed0",
  "report" =             "#833a52",
  "sonnet_paraphrase" =  "#344f3e",
  "speech" =             "#7342d3",
  "story" =              "#3e275e",
  "summarize" =          "#4fc445"
)

c25_corp.vec <- c(
  "analyze" =            "#db4688",
  "assess" =             "#597934",
  "blog" =               "#df4539",
  "characterize" =       "#ce50d0",
  "comment" =            "#c4b442",
  "describe" =           "#77b5a5",
  "dialogue" =           "#767cda",
  "diary" =              "#c89ec9",
  "discuss" =            "#91c43d",
  "explain" =            "#a14c96",
  "formal_letter" =      "#71512c",
  "informal_e-mail" =    "#d07f35",
  "informal_letter" =    "#c2a67d",
  "interior_monologue" = "#39212d",
  "magazine" =           "#d57e7f",
  "news" =               "#923428",
  "outline" =            "#69c282",
  "point_out" =          "#71aed0",
  "present" =            "#5b678a",
  "report" =             "#833a52",
  "soliloquy" =          "#4e2f91",
  "sonnet_paraphrase" =  "#344f3e",
  "speech" =             "#7342d3",
  "summarize" =          "#4fc445",
  "story" =              "#3e275e"
)

c5.vec <- structure(c5_corp, names = types.t.curr)
c17.vec <- structure(c17_corp, names = types.operator.17)
c25.vec <- structure(c25_corp, names = types.operator.25)

symbols.vec.grade <- structure(qw("circle triangle square"),
                               names = types.grade)
symbols.vec.t.curr <- structure(qw("circle triangle square wye star"),
                                names = types.t.curr)
symbols.vec.genre <- structure(qw("circle cross diamond square star triangle wye"),
                                names = types.genre)
symbols.vec.monochrome <- c(
  "No symbol variable" = "circle"
)


##### Save GMA data to a file #####

output_filename <- paste0("data/gma/", format(Sys.Date(), "%Y%m%d"),
                          "_data.rda")

save(
  # METADATA
  seeflex_meta,
  # FEATURE DATA
  seeflex_features_original,
  # seeflex_features_corrected,
  # seeflex_features_lexical_sophistication,
  # seeflex_features_clean_text,
  # COLORS
  c1_corp.vec, c5_corp.vec, c7_corp.vec, c17_corp.vec, c25_corp.vec,
  c1_corp, c4_corp, c5_corp, c17_corp, c25_corp,
  c5_grey, c5.vec, c17.vec, c25.vec,
  # LABELS
  bundle_label, dim_label_lda, dim_label_pca, dim_label_lda_short, dim_label_pca_short,
  label_dim_lda, label_dim_pca, label_dim_lda_short, label_dim_pca_short,
  labels.grade, labels.operator.17, labels.operator.25, labels.t.curr,
  labels.t.curr.short, labels.genre,
  # TYPES
  types.operator.17, types.operator.25, types.grade, types.t.curr, types.genre,
  types.operator.mediation,
  # LABEL CATS
  label_cat.operator.17, cat_label.operator.17, label_cat.operator.25,
  cat_label.operator.25, label_t.curr, cat_label_t.curr, label_grade,
  cat_label_grade, label_genre, cat_label_genre,
  # SYMBOLS
  symbols.vec.grade, symbols.vec.t.curr, symbols.vec.genre, symbols.vec.monochrome,
  # OUTPUT FILE
  file = output_filename
  )
