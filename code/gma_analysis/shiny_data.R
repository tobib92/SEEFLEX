#### Set working directory to the SEEFLEX root folder ####

library(tidyverse)
library(tidytext)

source("code/gma_analysis/gma_utils.R")
source("code/gma_analysis/seeflex_gma_utils.R")
load("data/gma/20250611_data.rda", verbose=TRUE)

# Data preparation
# Filter for texts of min 10 sentences and min 100 words
res2 <- filter_text_length_and_adjust_meta(
  seeflex_features_original, seeflex_meta, 100, 5)
seeflex_features_original <- res2$feat_df
seeflex_meta <- res2$meta_df

# Deselect the word, sentence and token count and create GMA matrix
seeflex <- convert_to_gma_matrix(seeflex_features_original)

# standardizing data
seeflex_z <- scale(seeflex)
# log transformation
seeflex_zl <- signed.log(seeflex_z)

# creating PCA element
PCA <- GMA(seeflex_zl) # for log transformed data

# selecting dimensions
PCA4 <- PCA$projection(space = "complement", dim = 1:4) # We need to specify
# `space="complement"` to obtain dimensions of the complement space rather than
# the (here zero-dimensional) target space, or `space="both"` to append them to
# the target space dimensions (Neumann & Evert 2021, online supplement).

weights_PCA <- PCA$basis(space = "complement")

PCA4.df <- data.frame(
  PC1=PCA4[, 1], PC2=PCA4[, 2],
  PC3=PCA4[, 3], PC4=PCA4[, 4],
  T.CURR = seeflex_meta$T.CURR,
  OPERATOR.17 = seeflex_meta$OPERATOR.17,
  OPERATOR.25 = seeflex_meta$OPERATOR.25,
  GENRE = seeflex_meta$GENRE,
  GENRE_FAMILY = seeflex_meta$GENRE_FAMILY,
  GRADE = seeflex_meta$GRADE,
  ID = seeflex_meta$id
)

PCA4.df <- PCA4.df %>%
  mutate(tooltip = paste("ID:", PCA4.df$ID,
                         "<br /> PC1:", PCA4.df$PC1,
                         "<br /> PC2:", PCA4.df$PC2,
                         "<br /> Operator:", PCA4.df$OPERATOR.17,
                         "<br /> T.Curr:", PCA4.df$T.CURR,
                         "<br /> Genre:", PCA4.df$GENRE,
                         "<br /> Subgenre:", PCA4.df$GENRE_FAMILY,
                         "<br /> Grade:", PCA4.df$GRADE))

# creating the LDA elements
LDA_genre <- PCA$copy()
LDA_t.curr <- PCA$copy()
LDA_operator17 <- PCA$copy()
LDA_operator25 <- PCA$copy()


##### Add linear discriminants #####
LDA_genre$add.discriminant(seeflex_meta$GENRE)
LDA_t.curr$add.discriminant(seeflex_meta$T.CURR)
LDA_operator17$add.discriminant(seeflex_meta$OPERATOR.17)
LDA_operator25$add.discriminant(seeflex_meta$OPERATOR.25)

weights_LDA_genre <- LDA_genre$basis(space = "both")
weights_LDA_t.curr <- LDA_t.curr$basis(space = "both")
weights_LDA_operator17 <- LDA_operator17$basis(space = "both")
weights_LDA_operator25 <- LDA_operator25$basis(space = "both")

LDA_genre <- LDA_genre$projection("both", dim=1:4)
LDA_t.curr <- LDA_t.curr$projection("both", dim=1:4)
LDA_operator17 <- LDA_operator17$projection("both", dim=1:4)
LDA_operator25 <- LDA_operator25$projection("both", dim=1:4)

# create the LDA data frames for the scatter plot
## LDA genre df
LDA4_genre.df <- data.frame(
  LD1 = LDA_genre[, 1], LD2 = LDA_genre[, 2],
  LD3 = LDA_genre[, 3], LD4 = LDA_genre[, 4],
  T.CURR = seeflex_meta$T.CURR,
  OPERATOR.17 = seeflex_meta$OPERATOR.17,
  OPERATOR.25 = seeflex_meta$OPERATOR.25,
  GENRE = seeflex_meta$GENRE,
  GENRE_FAMILY = seeflex_meta$GENRE_FAMILY,
  GRADE = seeflex_meta$GRADE,
  ID = seeflex_meta$id)

LDA4_genre.df <- LDA4_genre.df %>%
  mutate(tooltip = paste("ID:", LDA4_genre.df$ID,
                  "<br /> LD1:", LDA4_genre.df$LD1,
                  "<br /> LD2:", LDA4_genre.df$LD2,
                  "<br /> Operator:", LDA4_genre.df$OPERATOR.17,
                  "<br /> T.Curr:", LDA4_genre.df$T.CURR,
                  "<br /> Genre:", LDA4_genre.df$GENRE,
                  "<br /> Subgenre:", LDA4_genre.df$GENRE_FAMILY,
                  "<br /> Grade:", LDA4_genre.df$GRADE))

## LDA t.curr df
LDA4_t.curr.df <- data.frame(
  LD1 = LDA_t.curr[, 1], LD2 = LDA_t.curr[, 2],
  LD3 = LDA_t.curr[, 3], LD4 = LDA_t.curr[, 4],
  T.CURR = seeflex_meta$T.CURR,
  OPERATOR.17 = seeflex_meta$OPERATOR.17,
  OPERATOR.25 = seeflex_meta$OPERATOR.25,
  GENRE = seeflex_meta$GENRE,
  GENRE_FAMILY = seeflex_meta$GENRE_FAMILY,
  GRADE = seeflex_meta$GRADE,
  ID = seeflex_meta$id)

LDA4_t.curr.df <- LDA4_t.curr.df %>%
  mutate(tooltip = paste("ID:", LDA4_t.curr.df$ID,
                  "<br /> LD1:", LDA4_t.curr.df$LD1,
                  "<br /> LD2:", LDA4_t.curr.df$LD2,
                  "<br /> Operator:", LDA4_t.curr.df$OPERATOR.17,
                  "<br /> T.Curr:", LDA4_t.curr.df$T.CURR,
                  "<br /> Genre:", LDA4_t.curr.df$GENRE,
                  "<br /> Subgenre:", LDA4_t.curr.df$GENRE_FAMILY,
                  "<br /> Grade:", LDA4_t.curr.df$GRADE))

## LDA operator.17 df
LDA4_operator17.df <- data.frame(
  LD1 = LDA_operator17[, 1], LD2 = LDA_operator17[, 2],
  LD3 = LDA_operator17[, 3], LD4 = LDA_operator17[, 4],
  T.CURR = seeflex_meta$T.CURR,
  OPERATOR.17 = seeflex_meta$OPERATOR.17,
  OPERATOR.25 = seeflex_meta$OPERATOR.25,
  GENRE = seeflex_meta$GENRE,
  GENRE_FAMILY = seeflex_meta$GENRE_FAMILY,
  GRADE = seeflex_meta$GRADE,
  ID = seeflex_meta$id)

LDA4_operator17.df <- LDA4_operator17.df %>%
  mutate(tooltip = paste("ID:", LDA4_operator17.df$ID,
                  "<br /> LD1:", LDA4_operator17.df$LD1,
                  "<br /> LD2:", LDA4_operator17.df$LD2,
                  "<br /> Operator:", LDA4_operator17.df$OPERATOR.17,
                  "<br /> T.Curr:", LDA4_operator17.df$T.CURR,
                  "<br /> Genre:", LDA4_operator17.df$GENRE,
                  "<br /> Subgenre:", LDA4_operator17.df$GENRE_FAMILY,
                  "<br /> Grade:", LDA4_operator17.df$GRADE))

## LDA operator.25 df
LDA4_operator25.df <- data.frame(
  LD1 = LDA_operator25[, 1], LD2 = LDA_operator25[, 2],
  LD3 = LDA_operator25[, 3], LD4 = LDA_operator25[, 4],
  T.CURR = seeflex_meta$T.CURR,
  OPERATOR.17 = seeflex_meta$OPERATOR.17,
  OPERATOR.25 = seeflex_meta$OPERATOR.25,
  GENRE = seeflex_meta$GENRE,
  GENRE_FAMILY = seeflex_meta$GENRE_FAMILY,
  GRADE = seeflex_meta$GRADE,
  ID = seeflex_meta$id)

LDA4_operator25.df <- LDA4_operator25.df %>%
  mutate(tooltip = paste("ID:", LDA4_operator25.df$ID,
                  "<br /> LD1:", LDA4_operator25.df$LD1,
                  "<br /> LD2:", LDA4_operator25.df$LD2,
                  "<br /> Operator:", LDA4_operator25.df$OPERATOR.17,
                  "<br /> T.Curr:", LDA4_operator25.df$T.CURR,
                  "<br /> Genre:", LDA4_operator25.df$GENRE,
                  "<br /> Subgenre:", LDA4_operator25.df$GENRE_FAMILY,
                  "<br /> Grade:", LDA4_operator25.df$GRADE))


feature.names <- colnames(seeflex_zl)

##### Save GMA data to a file #####

output_filename <- paste0("data/gma/", format(Sys.Date(), "%Y%m%d"),
                          "_shiny_data.rda")

save(seeflex, seeflex_z, seeflex_zl, feature.names,
     seeflex_meta, PCA4, PCA4.df, weights_PCA,
     weights_LDA_genre, weights_LDA_t.curr, weights_LDA_operator17, weights_LDA_operator25,
     LDA_genre, LDA_t.curr, LDA_operator17, LDA_operator25,
     LDA4_genre.df, LDA4_t.curr.df, LDA4_operator17.df, LDA4_operator25.df,
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
