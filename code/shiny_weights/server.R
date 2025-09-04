library(ggplot2)
library(shiny)
library(shinyjs)

source("code/shiny_weights/utilities.R", local = TRUE)

persistent_cache <- TRUE # set to FALSE for development

#' Define standard plot dimensions for different sizes
PLOT_DIMENSIONS <- list(
  width = c(S = 750, M = 1050, L = 1400, XL = 1800),
  height = c(S = 600, M = 700, L = 900, XL = 1200),
  height2 = c(S = 150, M = 200, L = 200, XL = 300), # for densities
  fontsize = c(S = 12, M = 16, L = 18, XL = 24),
  rows = c(S = 2, M = 2, L = 2, XL = 2)
)

#' Update an input element in a Shiny session
#'
#' @param session The Shiny session object
#' @param name The name of the input element
#' @param val The new value to set
#' @param type The type of the input element
#' @return NULL (invisibly)

weights_update_input <- function(
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
    numeric = shiny::updateNumericInput(session, name, value = as.numeric(val), min = 0, max = 1, step = .05),
    slider = shiny::updateSliderInput(session, name, value = val)
  )
}

#' Observe changes in the preset selection and update the input elements
#' accordingly
#'
#' @param input The Shiny input object
#' @param session The Shiny session object
#' @return NULL (invisibly)

weights_observe_preset <- function(input, session) {
  shiny::observe({
    preset <- weights_presets[[input$preset]]

    for (par in c("dim", "y")) {
      weights_update_input(session, par, preset[[par]], "select")
    }

    for (par in c(
      "lda", "granularity", "focus_grade", "focus_t.curr",
      "focus_genre", "feature_deselect", "plot_size"
    )) {
      weights_update_input(session, par, preset[[par]], "radio")
    }

    for (par in c("show_OPERATOR.17", "show_OPERATOR.25", "focus_feature")) {
      weights_update_input(session, par, preset[[par]], "group")
    }

    for (par in c("focus_weight")) {
      weights_update_input(session, par, preset[[par]], "numeric")
    }

    for (par in c("use_legend", "use_ylim_box", "use_ylim_disc")) {
      weights_update_input(session, par, preset[[par]], "checkbox")
    }
  })
}

#' Handle the download of a preset file
#'
#' @param input The Shiny input object
#' @param output The Shiny output object
#' @return NULL (invisibly)

weights_save_preset_handler <- function(input, output) {
  output$save_preset <- shiny::downloadHandler(
    filename = "boxplot_preset.R",
    content = function(filename) {
      preset <- list(
        name = shiny::isolate(input$name_preset),
        lda = shiny::isolate(input$lda),
        dim = shiny::isolate(input$dim),
        y = isolate(input$y),
        granularity = isolate(input$granularity),
        focus_t.curr = isolate(input$focus_t.curr),
        focus_genre = isolate(input$focus_genre),
        focus_grade = isolate(input$focus_grade),
        feature_deselect = isolate(input$feature_deselect),
        focus_feature = isolate(input$focus_feature),
        focus_weight = isolate(input$focus_weight),
        plot_size = isolate(input$plot_size),
        use_legend = isolate(input$use_legend),
        use_ylim_box = isolate(input$use_ylim_box),
        use_ylim_disc = isolate(input$use_ylim_disc)
      )
      opts <- shiny::isolate(input$save_preset_options)
      all.cat <- ("allcat" %in% opts) # whether to save all category selections
      coalesce <- function(x, default = character()) {
        if (is.null(x)) default else x
      }
      if (all.cat || preset$granularity == "n17") {
        preset$show_OPERATOR.17 <- coalesce(shiny::isolate(input$show_OPERATOR.17))
      }
      if (all.cat || preset$granularity == "n25") {
        preset$show_OPERATOR.25 <- coalesce(shiny::isolate(input$show_OPERATOR.25))
      }
      dump("preset", file = filename)
    },
    contentType = "text/plain"
  )
}

#' Get the data for the feature weights and contributions plot
#'
#' @param input The Shiny input object
#' @note Currently, this function requires the shiny_data.rda file to be loaded,
#' which is done in the app.R script.
#' @return A reactive expression returning a list with the data

weights_get_data <- function(input) {
  shiny::reactive({
    Dims <- switch(input$lda,
      pca = weights_PCA,
      lda_genre = weights_LDA_genre,
      lda_t.curr = weights_LDA_t.curr,
      lda_operator17 = weights_LDA_operator17,
      lda_operator25 = weights_LDA_operator25
    )

    if (input$lda == "pca") {
      Dims <- weights_PCA
    } else if (input$lda == "lda_genre") {
      Dims <- weights_LDA_genre
    } else if (input$lda == "lda_t.curr") {
      Dims <- weights_LDA_t.curr
    } else if (input$lda == "lda_operator17") {
      Dims <- weights_LDA_operator17
    } else if (input$lda == "lda_operator25") {
      Dims <- weights_LDA_operator25
    } else {
      stop("No weights found in selection.")
    }

    # Create a boolean index for the meta dataframe
    idx <- rep(TRUE, nrow(seeflex_meta))
    idx_meta_all <- rep(TRUE, nrow(seeflex_meta))

    # Subset index for t.curr
    tcurr_idx <- seeflex_meta$T.CURR %in% input$focus_t.curr
    idx <- idx & tcurr_idx

    # Subset index for genre
    genre_idx <- seeflex_meta$GENRE %in% input$focus_genre
    idx <- idx & genre_idx

    # Subset index for grade
    grade_idx <- seeflex_meta$GRADE %in% input$focus_grade
    idx <- idx & grade_idx

    # Create a boolean index of the data matrix for the features
    if (input$feature_deselect == "all_features") {
      feature_idx <- colnames(seeflex_zl)
    } else if (input$feature_deselect == "selected_features") {
      feature_idx <- colnames(seeflex_zl) %in% input$focus_feature
    } else if (input$feature_deselect == "weights_limit_features") {
      # function call from shiny_scatter/server.R
      col_name <- get_column_name_from_ui(input$lda, input$dim)
      feature_idx <- abs(Dims[, col_name]) > input$focus_weight
    } else {
      stop("No features found in selection for M.")
    }

    # Create a boolean index of the weights matrix for the features
    if (input$feature_deselect == "all_features") {
      weights_idx <- rownames(Dims)
    } else if (input$feature_deselect == "selected_features") {
      weights_idx <- rownames(Dims) %in% input$focus_feature
    } else if (input$feature_deselect == "weights_limit_features") {
      # function call from shiny_scatter/server.R
      col_name <- get_column_name_from_ui(input$lda, input$dim)
      weights_idx <- abs(Dims[, col_name]) > input$focus_weight
    } else {
      stop("No features found in selection for Dims.")
    }

    M_subset <- seeflex_zl[idx, feature_idx, drop = FALSE]
    M_all <- seeflex_zl[idx_meta_all, feature_idx, drop = FALSE]
    Meta_subset <- seeflex_meta[idx, , drop = FALSE]
    Meta_all <- seeflex_meta[idx_meta_all, , drop = FALSE]
    Dims_subset <- Dims[weights_idx, , drop = FALSE]

    # print(paste("Meta", nrow(M_subset), head(rownames(M_subset)), ncol(M_subset), colnames(M_subset)))
    # print(paste("Meta", nrow(Meta_subset), head(rownames(Meta_subset)), ncol(Meta_subset), head(colnames(Meta_subset))))
    # print(paste("Meta", nrow(Dims_subset), rownames(Dims_subset), ncol(Dims_subset), colnames(Dims_subset)))

    return(list(M = M_subset, MAll = M_all, Meta = Meta_subset, MetaAll = Meta_all, Dims = Dims_subset))
  })
}


#' Update the dimensions of a plotly plot
#'
#' @param element_id The ID of the plotly plot
#' @param width The new width of the plot
#' @param height The new height of the plot
#' @return NULL (invisibly)

update_plot_dimensions <- function(element_id, width, height) {
  shinyjs::runjs(sprintf(
    "$('#%s').css('width', %d).css('height', %d);",
    element_id, width, height
  ))
  shinyjs::runjs(sprintf("$('#%s').trigger('resize');", element_id))
}

#' Define a size policy for the cached plots
#' This function selects the preset size that is closest to the dimensions
#'
#' @param dims A numeric vector with the dimensions of the plot
#' @return A named numeric vector with the width and height of the plot

size_policy <- function(dims) {
  d <- abs(dims[1] - PLOT_DIMENSIONS$width) + abs(dims[2] - PLOT_DIMENSIONS$height)
  idx <- which.max(d) # find preset size closest to the dimensions reported by UI
  c(width = PLOT_DIMENSIONS$width[idx], height = PLOT_DIMENSIONS$height[idx])
}

#### Plot Generation ####


#' Generate a boxplot for the feature weights and contributions
#'
#' @param input The Shiny input object
#' @param Data A reactive expression returning a list with the data
#' @param feature.names A character vector with the names of the features
#' @param dim_label_lda A named character vector with the dimension labels
#' @param c17_corp.vec A character vector with the colours for the 17 categories
#' @param c25_corp.vec A character vector with the colours for the 25 categories
#' @param plot_dimensions A list with the plot dimensions (default: PLOT_DIMENSIONS)
#' @return A ggplot object

generate_boxplot <- function(input, Data, feature.names, c17_corp.vec,
                             c25_corp.vec, plot_dimensions = PLOT_DIMENSIONS) {

  selected_dimension <- dim_label_pca[input$dim]

  cat.variable <- switch(input$granularity,
    n17 = "OPERATOR.17",
    n25 = "OPERATOR.25",
    n5 = "T.CURR",
    n7 = "GENRE"
  )
  cat.selected <- switch(input$granularity,
    n17 = input$show_OPERATOR.17,
    n25 = input$show_OPERATOR.25,
    n5 = input$focus_t.curr,
    n7 = input$focus_genre
  )
  cat.colours <- switch(input$granularity,
    n17 = c17_corp.vec,
    n25 = c25_corp.vec,
    n5 = c5_corp.vec,
    n7 = c7_corp.vec,
  )

  # This value can be passed in to ggbox.selected in order to subset the
  # displayed features on the final plot

  if (input$feature_deselect == "all_features") {
    cat.features <- feature.names
  } else if (input$feature_deselect == "selected_features") {
    cat.features <- feature.names[feature.names %in% input$focus_feature]
  } else if (input$feature_deselect == "weights_limit_features") {
    cat.features <- feature.names[feature.names %in% rownames(Data()$Dims)]
  } else {
    stop("No features found in selection for feature.names.")
  }

  # Create an adjustable title for the boxplots
  main.txt <- selected_dimension
  if (!all(label_grade %in% input$focus_grade)) {
    main.txt <- sprintf("%s (Grade(s): %s)", main.txt, paste(input$focus_grade, collapse = ", "))
  }

  # Adjust y-axis limit for density plots
  if (input$use_ylim_box) {
    y.range <- if (input$y == "features") c(-1.5, 3) else c(-0.5, 1)
  } else {
    y.range <- NULL
  }

  # Use the inverse.map function to flip the keys and values in the dim_label_lda
  # object. Then use the value from the "dim" drop down input to grab the
  # corresponding value from the lookup in the other direction
  bplt <- ggbox.selected(
    M = Data()$MAll,
    Meta = Data()$MetaAll,
    cats = cat.selected,
    colours = cat.colours,
    # function call from shiny_scatter/server.R
    weights = Data()$Dims[, get_column_name_from_ui(input$lda, input$dim)],
    what = input$y,
    feature.names = cat.features,
    variable = cat.variable,
    # select = idx.weights,
    main = main.txt,
    group.labels = !input$use_legend,
    ylim = y.range,
    nrow = PLOT_DIMENSIONS$rows[input$plot_size],
    base_size = PLOT_DIMENSIONS$fontsize[input$plot_size]
  )
  if (!input$use_legend) {
    bplt <- bplt +
      theme(
        axis.text.x = element_text(angle = 52, hjust = 1),
        legend.position = "none"
      )
  }
  bplt
}

#' Generate a discriminant plot for the feature weights and contributions
#'
#' @param input The Shiny input object
#' @param Data A reactive expression returning a list with the data
#' @param dim_label_lda A named character vector with the dimension labels
#' @param c17_corp.vec A character vector with the colors for the 17 categories
#' @param c25_corp.vec A character vector with the colors for the 25 categories
#' @return A ggplot object

generate_densities_plot <- function(input, Data, c17_corp.vec, c25_corp.vec) {

  cat.vec <- switch(input$granularity,
    n17 = Data()$Meta$OPERATOR.17,
    n25 = Data()$Meta$OPERATOR.25,
    n5 = Data()$Meta$T.CURR,
    n7 = Data()$Meta$GENRE
  )
  cat.colours <- switch(input$granularity,
    n17 = c17_corp.vec,
    n25 = c25_corp.vec,
    n5 = c5_corp.vec,
    n7 = c7_corp.vec,
  )
  cat.selected <- switch(input$granularity,
    n17 = input$show_OPERATOR.17,
    n25 = input$show_OPERATOR.25,
    n5 = input$focus_t.curr,
    n7 = input$focus_genre
  )
  leg.cex <- switch(input$plot_size,
    S = 0.7,
    M = 0.9,
    L = 1.0,
    XL = 1.4
  )

  selected_dimension <- dim_label_pca[input$dim]

  idx <- if (length(cat.selected) > 0 & input$granularity %in% c("n17", "n25", "n5", "n7")) {
    cat.vec %in% cat.selected
  # } else if (length(cat.selected) > 0 & input$granularity == "n25") {
  #   cat.vec %in% cat.selected
  # } else if (length(cat.selected) > 0 & input$granularity == "n5") {
  #   cat.vec %in% cat.selected
  # } else if (length(cat.selected) > 0 & input$granularity == "n7") {
  #   cat.vec %in% cat.selected
  } else if (length(cat.selected) == 0 & input$granularity %in% c("n17", "n5", "n7")) {
    NULL
  } else if (length(cat.selected) == 0 & input$granularity == "n25") {
    # exclude assess because there is only one data point.
    !(cat.vec %in% c("assess"))
  } else {
    stop("Index of selections could not be created.")
  }

  par(mar = c(2, 4, 0, 1))
  ymax <- if (input$use_ylim_disc) 2.2 else NULL

  dplt <- discriminant.plot(Data()$M,
    discriminant = Data()$Dims[, get_column_name_from_ui(input$lda, input$dim)], # function call from shiny_scatter/server.R
    categories = cat.vec,
    idx = idx,
    col.vals = cat.colours,
    rug = TRUE,
    legend.cex = leg.cex,
    legend.colsize = 11,
    y.max = ymax,
    xlim = c(-3, 5),
    xaxs = "i"
  )
  dplt
}

#### PDF Download Functions ####

#' Generate the filename for the PDF download
#'
#' @param input The Shiny input object
#' @return A character string with the filename

weights_generate_pdf_filename <- function(input) {
  cat.list <- switch(input$granularity,
    n17 = label_cat.operator.17[input$show_OPERATOR.17],
    n25 = label_cat.operator.25[input$show_OPERATOR.25]
  )
  if (length(cat.list) > 0) {
    cat.info <- sprintf(
      "_cat%d=%s",
      switch(input$granularity,
        n17 = 17,
        n25 = 25
      ),
      paste(cat.list, collapse = "-")
    )
  } else {
    cat.info <- ""
  }
  sprintf(
    "SEEFLEX-boxplot_%s_%s_%s%s.pdf",
    input$focus_grade,
    input$dim,
    input$y,
    cat.info
  )
}

#' Generate the content for the PDF download
#'
#' @param filename The filename for the PDF download
#' @param input The Shiny input object
#' @param Data A reactive expression returning a list with the data
#' @param dim_label_lda A named character vector with the dimension labels
#' @param c17_corp.vec A character vector with the colors for the 17 categories
#' @param c25_corp.vec A character vector with the colors for the 25 categories
#' @param feature.names A character vector with the names of the features
#' @return NULL (invisibly)

generate_pdf_content <- function(
    filename,
    input,
    Data,
    dim_label_lda,
    c17_corp.vec,
    c25_corp.vec,
    feature.names) {
  cairo_pdf(filename, width = 12, height = 8)
  cat.variable <- switch(input$granularity,
    n17 = "OPERATOR.17",
    n25 = "OPERATOR.25"
  )
  cat.selected <- switch(input$granularity,
    n17 = input$show_OPERATOR.17,
    n25 = input$show_OPERATOR.25
  )
  cat.colours <- switch(input$granularity,
    n17 = c17_corp.vec,
    n25 = c25_corp.vec
  )
  main.txt <- dim_label_lda[input$dim]
  if (input$focus_grade != "all") {
    main.txt <- sprintf("%s (Grade: %s)", main.txt, input$focus_grade)
  }
  y.range <- if (input$y == "features") c(-1.5, 3) else c(-0.5, 1)
  ggbox.selected(
    M = Data()$M,
    Meta = Data()$Meta,
    cats = cat.selected,
    variable = cat.variable,
    colours = cat.colours,
    weights = Data()$Dims[, input$dim],
    what = input$y,
    select = weights, # idx.weights
    feature.names = feature.names,
    main = main.txt,
    ylim = y.range,
    nrow = 2, base_size = 17
  ) %>% print()
  dev.off()
}

#' Define the download handler for the PDF download
#'
#' @param input The Shiny input object
#' @return A downloadHandler object

weights_pdf_download_handler <- function(input) {
  shiny::downloadHandler(
    filename = function() {
      weights_generate_pdf_filename(
        input,
        label_cat.operator.17,
        label_cat.operator.25
      )
    },
    content = function(filename) {
      generate_pdf_content(
        filename,
        input,
        Data,
        dim_label_lda,
        c17_corp.vec,
        c25_corp.vec,
        feature.names
      )
    },
    contentType = "application/octet-stream"
  )
}

#### Server Function for Shiny App ####

weights_server <- function(input, output, session) {
  ns <- session$ns

  weights_observe_preset(input, session)
  weights_save_preset_handler(input, output)

  #### Data ####

  Data <- weights_get_data(input)

  shiny::observe({
    plot_size <- input$plot_size
    update_plot_dimensions(
      "boxplot",
      PLOT_DIMENSIONS$width[plot_size],
      PLOT_DIMENSIONS$height[plot_size]
    )
    update_plot_dimensions(
      "densities",
      PLOT_DIMENSIONS$width[plot_size],
      PLOT_DIMENSIONS$height2[plot_size]
    )
  })

  #### Boxplot ####

  output$boxplot <- shiny::renderCachedPlot(
    {
      generate_boxplot(
        input,
        Data,
        feature.names,
        c17_corp.vec,
        c25_corp.vec
      )
    },
    sizePolicy = size_policy,
    cacheKeyExpr = {
      list(
        grade = input$focus_grade,
        genre = input$focus_genre,
        t.curr = input$focus_t.curr,
        feature_deselect = input$feature_deselect,
        focus_feature = input$focus_feature,
        focus_weight = input$focus_weight,
        lda = input$lda,
        dim = input$dim,
        what = input$y,
        fine = input$granularity,
        size = input$plot_size,
        legend = input$use_legend,
        ylim_box = input$use_ylim_box,
        ylim_box = input$use_ylim_disc,
        cats = switch(input$granularity,
          n17 = input$show_OPERATOR.17,
          n25 = input$show_OPERATOR.25
        )
      )
    },
    execOnResize = TRUE,
    cache = if (persistent_cache) "app" else "session"
  )

  #### Density Plot ####

  output$densities <- shiny::renderPlot(
    {
      if ("assess" %in% input$show_OPERATOR.25) {
        print("Found assessment")

        updateCheckboxGroupInput(session, "show_OPERATOR.25",
          selected = setdiff(input$show_OPERATOR.25, "assess")
        )
      }
      generate_densities_plot(
        input,
        Data,
        c17_corp.vec,
        c25_corp.vec
      )
    },
    execOnResize = TRUE
  )

  output$downloadPDF <- weights_pdf_download_handler(input)

  # output$debugOutput <- renderText({ })
}
