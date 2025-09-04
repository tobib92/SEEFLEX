library(shiny)
library(shinyjs)
library(tidyverse)

source("code/shiny_weights/utilities.R", local = TRUE)

persistent_cache <- TRUE # set to FALSE for development


#' Update an input element in a Shiny session
#'
#' @param session The Shiny session object
#' @param name The name of the input element
#' @param val The new value to set
#' @param type The type of the input element
#' @return NULL (invisibly)

table_update_input <- function(
    session,
    name,
    val,
    type = c("radio", "select", "checkbox", "group", "numeric", "slider")) {
  type <- match.arg(type)
  if (is.null(val)) {
    return()
  }
  switch(type,
    radio = shiny::updateRadioButtons(session, name, selected = val),
    select = shiny::updateSelectInput(session, name, selected = val),
    checkbox = shiny::updateCheckboxInput(session, name, value = val),
    group = shiny::updateCheckboxGroupInput(session, name, selected = val),
    numeric = shiny::updateNumericInput(session, name, value = val),
    slider = shiny::updateSliderInput(session, name, value = val)
  )
}

#' Observe changes in the preset selection and update the input elements
#' accordingly
#'
#' @param input The Shiny input object
#' @param session The Shiny session object
#' @return NULL (invisibly)

table_observe_preset <- function(input, session) {
  shiny::observe({
    preset <- weights_presets[[input$preset]]

    for (par in c("dim", "y")) {
      table_update_input(session, par, preset[[par]], "select")
    }

    for (par in c(
      "lda", "granularity", "focus_grade", "focus_t.curr",
      "focus_genre", "feature_deselect", "plot_size"
    )) {
      table_update_input(session, par, preset[[par]], "radio")
    }

    for (par in c("show_OPERATOR.17", "show_OPERATOR.25", "focus_feature")) {
      table_update_input(session, par, preset[[par]], "group")
    }

  })
}


#' Create the data from the shiny data in the rda file
#'
#' @param data_matrix The data matrix containing the feature values
#' @param meta_df The meta dataframe that contains the information on the texts

table_get_data <- function(data_matrix, meta_df) {

  data <- as.data.frame(data_matrix)

  data <- data %>%
    mutate(id = rownames(data)) %>%
    left_join(meta_df[,1:10], by = "id") %>%
    dplyr::relocate(id, .before = 1) %>%
    mutate(across(where(is.numeric), ~ round(.x, 3)))

  rownames(data) <- data$id

  return(data)
}


#### Server Function for Shiny App ####

table_server <- function(input, output, session) {

  ns <- session$ns

  data <- table_get_data(seeflex_zl, seeflex_meta)

  table_observe_preset(input, session)

  #### Table ####

  filtered_table_data <- reactive({

    # Select operator from granularity
    OPERATOR <- switch(
      input$granularity,
      n17 = "OPERATOR.17",
      n25 = "OPERATOR.25"
    )

    # Select operator input from granularity
    selected_operators <- switch(
      input$granularity,
      n17 = input$show_OPERATOR.17,
      n25 = input$show_OPERATOR.25
    )

    # Filter metadata
    filtered_table_data_subset <- data %>%
      dplyr::filter(
        get(OPERATOR) %in% selected_operators,
        GENRE %in% input$focus_genre,
        T.CURR %in% input$focus_t.curr,
        GRADE %in% input$focus_grade
      )

    # Filter features
    if (input$feature_deselect == "selected_features") {

      meta_columns <- names(filtered_table_data_subset)[sapply(filtered_table_data_subset, is.character)]
      filtered_table_data_subset <- filtered_table_data_subset %>%
      dplyr::select(all_of(input$focus_feature), all_of(meta_columns))

    }

    # Load weights
    weights <- switch(
      input$lda,
      pca = weights_PCA,
      lda_genre = weights_LDA_genre,
      lda_t.curr = weights_LDA_t.curr,
      lda_operator17 = weights_LDA_operator17,
      lda_operator25 = weights_LDA_operator25
    )

    # Select features
    if (input$feature_deselect == "all_features") {
      numeric_cols <- feature.names

    } else if (input$feature_deselect == "selected_features") {
      numeric_cols <- input$focus_feature

    } else if (input$feature_deselect == "weights_limit_features") {
      numeric_cols <- feature.names
      # numeric_cols <- rownames(weights[weights[[input$y]] > input$focus_weight, ])
      # numeric_cols <- rownames(subset(weights, weights[, input$y] > input$focus_weight))
      # numeric_cols <- rownames(weights)[
      #   weights[,input$y] > as.numeric(input$focus_weight)
      # ]
      print("Warning: Feature weight limit has not yet been set up.")

    }

    # Create chosen column name in data frames from selected input
    dim_colname <- get_column_name_from_ui(input$lda, input$dim)

    # Create weighted and contribution values
    if (input$y == "contribution") {
      # print(paste("intputdim", input$dim))
      weight_multiplier <- weights[numeric_cols, dim_colname, drop = FALSE]
      tmp_table_data <- filtered_table_data_subset[, numeric_cols, drop = FALSE]
      tmp_table_matrix <- as.matrix(tmp_table_data)
      result_matrix <- round(sweep(tmp_table_matrix, 2, weight_multiplier, FUN = "*"), 3)
      filtered_table_data_subset[, numeric_cols] <- result_matrix
      print("Using contribution values")

    } else if (input$y == "weighted") {
      weight_multiplier <- abs(weights[numeric_cols, dim_colname, drop = FALSE])
      tmp_table_data <- filtered_table_data_subset[, numeric_cols, drop = FALSE]
      tmp_table_matrix <- as.matrix(tmp_table_data)
      result_matrix <- round(sweep(tmp_table_matrix, 2, weight_multiplier, FUN = "*"), 3)
      filtered_table_data_subset[, numeric_cols] <- result_matrix
      print("Using weighted values")

    } else {
      filtered_table_data_subset <- filtered_table_data_subset %>%
        dplyr::mutate(across(where(is.numeric), ~ round(., 3)))
      print("Using feature values")
    }

    return(filtered_table_data_subset)
  })

  # Calculate statistics
  output$descriptive_stats <- renderDT({

    # Create operator switch for granularity
    OPERATOR <- switch(
      input$granularity,
      n17 = "OPERATOR.17",
      n25 = "OPERATOR.25"
    )

    # Get data from reactive container
    stats_df <- filtered_table_data()

    # Modify df
    stats_df <- stats_df %>%
      dplyr::group_by(get(OPERATOR)) %>%
      dplyr::summarise(across(where(is.numeric), ~ round(mean(.x, na.rm = TRUE), 3))) %>%
      dplyr::rename("Operator" = "get(OPERATOR)")

    # Include centroid if contribution and all features are selected
    if (input$y == "contribution") {
    # if (input$y == "contribution" & ncol(stats_df) == 43) {
      stats_df <- stats_df %>%
        dplyr::mutate(`Axis score` = rowSums(across(where(is.numeric)), na.rm = TRUE), .after = Operator) %>%
        dplyr::mutate(`Axis score` = round(`Axis score`, 3))
    } else {
      stats_df
    }

    datatable(stats_df, options = list(pageLength = 7))
  })

  # Render feature values table
  output$table_data <- renderDT({

    # Get data
    table_df <- filtered_table_data()

    # Include axis score if contribution and all features are selected
    if (input$y == "contribution" & ncol(table_df) == 52) {
      table_df <- table_df %>%
        dplyr::mutate(`Axis score` = rowSums(across(where(is.numeric)), na.rm = TRUE), .before = 1) %>%
        dplyr::mutate(`Axis score` = round(`Axis score`, 3))
    } else {
      table_df
    }

    # Only select numeric columns for output
    table_df <- table_df[, sapply(table_df, is.numeric), drop = FALSE]
    datatable(table_df, options = list(pageLength = 50))
  })

  # Observe LDA <-> PCA changes
  observeEvent(input$lda, {
    if (input$lda != "pca") {
      updateSelectInput(session, "dim", selected = "LD1")
    } else if (input$lda == "pca") {
      updateSelectInput(session, "dim", selected = "PC1")
    }
  })

 output$debugOutput <- renderText({ })

}
