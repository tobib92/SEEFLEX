#### Set working directory to the SEEFLEX root folder ####

#' The functions saveWidgetD3() and save.pdf() were developed by Stephanie
#' Evert and Stella Neumann (Neumann & Evert, 2021) and can be found in their
#' online supplement (https://www.stephanie-evert.de/PUB/NeumannEvert2021/)

# Function to trick saveWidget() into writing to a subdirectory
## NB: file= has to specify plain filename, use subdir= to change location
saveWidgetD3 <- function(widget, file, title = "", subdir = "D3_proc") {
  cur.dir <- getwd()
  on.exit(setwd(cur.dir))
  setwd(cur.dir)
  saveWidget(widget, file=file, title=title, selfcontained=TRUE)
  return(widget) # so it simply wraps around scatterD3
}

# Function for saving plots to PDF file
save.pdf <- function (file, ...) {
  invisible(dev.copy2pdf(file=file, ..., out.type="cairo"))
}


#' This function filters the text length accordning to a minimum number of words
#' and a minimum number of sentences for the GMA. The meta data frame is
#' automatically adjusted to match the number of rows in the feature data frame
#'
#' @param feat_df The feature data frame
#' @param meta_df The metadata data frame
#' @param min_word The minimum number of words per text
#' @param min_sent The minimum number of sentences per text

filter_text_length_and_adjust_meta <- function(feat_df, meta_df,
                                               min_word, min_sent){
  feat_df <- feat_df %>%
    dplyr::filter(word >= min_word) %>%
    dplyr::filter(sent >= min_sent)

  meta_df <- meta_df %>%
    dplyr::rename(id = ID) %>%
    dplyr::right_join(feat_df, by = "id") %>%
    na.omit(meta_df)

  return(list(feat_df = feat_df, meta_df = meta_df))
}


#' This function filters the texts by a certain metadata category with a
#' specified minimum number of texts and adjusts the feature data frame in the
#' number of rows.
#'
#' @param meta_df The metadata data frame
#' @param feat_df The feature data frame
#' @param cat The metadata category in meta_df
#' @param min_n The minimum amount of texts in the category cat

filter_meta_category_and_adjust_feat <- function(meta_df, feat_df, cat, min_n) {
  meta_df <- meta_df %>%
    dplyr::group_by(meta_df[[cat]]) %>%
    dplyr::filter(n() > min_n) %>%
    dplyr::ungroup()
  # Adjust feat_df to filtering
  ids <- meta_df$ID # ID variable must match "ID"
  feat_df <- feat_df %>%
    dplyr::filter(id %in% ids) # ID variable must match "id"
  # Adjust meta_df to nrow in feat_df
  meta_df <- meta_df %>%
    dplyr::right_join(feat_df, by = dplyr::join_by(ID == id))

  return(list(feat_df = feat_df, meta_df = meta_df))
}


#' This function converts the feature data frame generated in the CQP feature
#' extraction script to a numerical matrix which can be used in the GMA
#' analysis.
#'
#' @param df The data frame containing the feature distributions

convert_to_gma_matrix <- function(df) {
  df <- as.data.frame(df)
  df <- dplyr::select(df, !2:4)
  df2 <- df[,-1]
  rownames(df2) <- df[,1]
  gma_matrix <- df2
  return(gma_matrix)
}
