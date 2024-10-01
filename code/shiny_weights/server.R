library(ggplot2)
library(shiny)
library(shinyjs)
source("../shiny_weights/utilities.R", local = TRUE)

persistent_cache <- FALSE # set to FALSE for development

#' Define standard plot dimensions for different sizes
PLOT_DIMENSIONS <- list(
  width = c(S = 750, M = 1050, L = 1200, XL = 1600),
  height = c(S = 600, M = 700, L = 900, XL = 1200),
  height2 = c(S = 150, M = 200, L = 200, XL = 300), # for densities
  fontsize = c(S = 12, M = 16, L = 18, XL = 24),
  rows = c(S = 2, M = 2, L = 3, XL = 3)
)

#' Update an input element in a Shiny session
#'
#' @param session The Shiny session object
#' @param name The name of the input element
#' @param val The new value to set
#' @param type The type of the input element
#'
#' @return NULL (invisibly)
weights_update_input <- function(
    session,
    name,
    val,
    type = c("radio", "select", "checkbox", "group", "slider")) {
  type <- match.arg(type)
  if (is.null(val)) {
    return()
  }
  switch(type,
    radio = shiny::updateRadioButtons(session, name, selected = val),
    select = shiny::updateSelectInput(session, name, selected = val),
    checkbox = shiny::updateCheckboxInput(session, name, value = val),
    group = shiny::updateCheckboxGroupInput(session, name, selected = val),
    slider = shiny::updateSliderInput(session, name, value = val)
  )
}

#' Observe changes in the preset selection and update the input elements
#' accordingly
#'
#' @param input The Shiny input object
#' @param session The Shiny session object
#'
#' @return NULL (invisibly)
weights_observe_preset <- function(input, session) {
  shiny::observe({
    preset <- weights_presets[[input$preset]]

    for (par in c("dim", "y")) {
      weights_update_input(session, par, preset[[par]], "select")
    }

    for (par in c("lda", "granularity", "focus_grade")) {
      weights_update_input(session, par, preset[[par]], "radio")
    }

    for (par in c("show_OPERATOR.14", "show_OPERATOR.25")) {
      weights_update_input(session, par, preset[[par]], "group")
    }
  })
}

#' Handle the download of a preset file
#'
#' @param input The Shiny input object
#' @param output The Shiny output object
#'
#' @return NULL (invisibly)
weights_save_preset_handler <- function(input, output) {
  output$save_preset <- shiny::downloadHandler(
    filename = "boxplot_preset.R",
    content = function(filename) {
      preset <- list(
        name = "",
        lda = shiny::isolate(input$lda),
        dim = shiny::isolate(input$dim),
        y = isolate(input$y),
        granularity = isolate(input$granularity),
        focus_grade = isolate(input$focus_grade)
      )
      opts <- shiny::isolate(input$save_preset_options)
      all.cat <- ("allcat" %in% opts) # whether to save all category selections
      coalesce <- function(x, default = character()) {
        if (is.null(x)) default else x
      }
      if (all.cat || preset$granularity == "n14") {
        preset$show_OPERATOR.14 <- coalesce(shiny::isolate(input$show_OPERATOR.14))
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
#'
#' @return A reactive expression returning a list with the data
weights_get_data <- function(input) {
  # NOTE: Currently, this function requires the shiny_data.rda file to be loaded,
  # which is done in the app.R script.

  shiny::reactive({
    Dims <- switch(input$lda,
      lda14 = features_14,
      lda25 = features_25
    )

    idx <- rep(TRUE, nrow(seeflex_meta))

    grade_idx <- seeflex_meta$GRADE %in% input$focus_grade
    idx <- idx & grade_idx

    tcurr_idx <- seeflex_meta$T.CURR %in% input$focus_t.curr
    idx <- idx & tcurr_idx

    return(list(M = seeflex_zl[idx, ], Meta = seeflex_meta[idx, ], Dims = Dims))
  })
}

#' Update the dimensions of a plotly plot
#'
#' @param element_id The ID of the plotly plot
#' @param width The new width of the plot
#' @param height The new height of the plot
#'
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
#'
#' @return A named numeric vector with the width and height of the plot
size_policy <- function(dims) {
  d <- abs(dims[1] - PLOT_DIMENSIONS$width) + abs(dims[2] - PLOT_DIMENSIONS$height)
  idx <- which.min(d) # find preset size closest to the dimensions reported by UI
  c(width = PLOT_DIMENSIONS$width[idx], height = PLOT_DIMENSIONS$height[idx])
}

############################### Plot Generation ################################

#' Generate a boxplot for the feature weights and contributions
#'
#' @param input The Shiny input object
#' @param Data A reactive expression returning a list with the data
#' @param feature.names A character vector with the names of the features
#' @param dim_label A named character vector with the dimension labels
#' @param c14_corp.vec A character vector with the colours for the 14 categories
#' @param c25_corp.vec A character vector with the colours for the 25 categories
#' @param plot_dimensions A list with the plot dimensions (default: PLOT_DIMENSIONS)
#'
#' @return A ggplot object
generate_boxplot <- function(
    input,
    Data,
    feature.names,
    dim_label,
    c14_corp.vec,
    c25_corp.vec,
    plot_dimensions = PLOT_DIMENSIONS) {
  cat.variable <- switch(input$granularity,
    n14 = "OPERATOR.14",
    n25 = "OPERATOR.25"
  )
  cat.selected <- switch(input$granularity,
    n14 = input$show_OPERATOR.14,
    n25 = input$show_OPERATOR.25
  )
  cat.colours <- switch(input$granularity,
    n14 = c14_corp.vec,
    n25 = c25_corp.vec
  )
  # Create an adjustable title for the boxplots
  main.txt <- input$dim
  if (!all(label_grade %in% input$focus_grade)) {
    main.txt <- sprintf("%s (Grade(s): %s)", main.txt, paste(input$focus_grade, collapse = ", "))
  }
  if (input$use_ylim_box) {
    y.range <- if (input$y == "features") c(-1.5, 3) else c(-0.5, 1)
  } else {
    y.range <- NULL
  }

  # Use the inverse.map function to flip the keys and values in the dim_label
  # object. Then use the value from the "dim" drop down input to grab the
  # corresponding value from the lookup in the other direction

  selected_dimension <- inverse.map(dim_label)[input$dim]

  # This value can be passed in to ggbox.selected in order to
  # subset the displayed features on the final plot

  # idx.weights <- apply(abs(Data()$Dims), 1, max) >= .1

  plt <- ggbox.selected(
    M = Data()$M, Meta = Data()$Meta,
    variable = cat.variable,
    cats = cat.selected,
    colours = cat.colours,
    weights = Data()$Dims[, selected_dimension],
    what = input$y,
    feature.names = feature.names,
    # select=idx.weights,
    main = main.txt,
    group.labels = !input$use_legend,
    ylim = y.range,
    nrow = PLOT_DIMENSIONS$rows[input$plot_size],
    base_size = PLOT_DIMENSIONS$fontsize[input$plot_size]
  )
  if (!input$use_legend) {
    plt <- plt +
      theme(
        axis.text.x = element_text(angle = 52, hjust = 1),
        legend.position = "none"
      )
  }
  plt
}

#' Generate a discriminant plot for the feature weights and contributions
#'
#' @param input The Shiny input object
#' @param Data A reactive expression returning a list with the data
#' @param dim_label A named character vector with the dimension labels
#' @param c14_corp.vec A character vector with the colours for the 14 categories
#' @param c25_corp.vec A character vector with the colours for the 25 categories
#'
#' @return A ggplot object
generate_densities_plot <- function(input, Data, dim_label, c14_corp.vec, c25_corp.vec) {
  cat.vec <- switch(input$granularity,
    n14 = Data()$Meta$OPERATOR.14,
    n25 = Data()$Meta$OPERATOR.25
  )
  cat.colours <- switch(input$granularity,
    n14 = c14_corp.vec,
    n25 = c25_corp.vec
  )
  cat.selected <- switch(input$granularity,
    n14 = input$show_OPERATOR.14,
    n25 = input$show_OPERATOR.25
  )
  leg.cex <- switch(input$plot_size,
    S = 0.7,
    M = 0.9,
    L = 1.0,
    XL = 1.4
  )
  selected_dimension <- inverse.map(dim_label)[input$dim]
  dim.vec <- Data()$Dims[, selected_dimension]
  idx <- if (length(cat.selected) > 0) cat.vec %in% cat.selected else NULL
  par(mar = c(2, 4, 0, 1))
  ymax <- if (input$use_ylim_disc) 2.2 else NULL
  dplt <- discriminant.plot(Data()$M,
    dim.vec,
    cat.vec,
    idx = idx,
    col.vals = cat.colours,
    rug = TRUE,
    legend.cex = leg.cex,
    legend.colsize = 11,
    y.max = ymax,
    xlim = c(-3, 5),
    xaxs = "i",
    xlab = ""
  )
  dplt
}

##################### PDF Download Functions ###################################

#' Generate the filename for the PDF download
#'
#' @param input The Shiny input object
#'
#' @return A character string with the filename
weights_generate_pdf_filename <- function(input) {
  cat.list <- switch(input$granularity,
     n14 = {
        all_selected <- setequal(input$show_OPERATOR.14, label_cat.operator.14)
        if (all_selected) {
          "all"
        } else {
          cat_label.operator.14[input$show_OPERATOR.14]
        }
      },
      n25 = {
        all_selected <- setequal(input$show_OPERATOR.25, label_cat.operator.25)
        if (all_selected) {
          "all"
        } else {
          cat_label.operator.25[input$show_OPERATOR.25]
        }
      }
  )
  if (length(cat.list) > 0) {
    cat.info <- sprintf(
      "_cat%d=%s",
      switch(input$granularity,
        n14 = 14,
        n25 = 25
      ),
      paste(cat.list, collapse = "-")
    )
  } else {
    cat.info <- ""
  }
  sprintf(
    "ICE-boxplot_%s_%s_%s%s.pdf",
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
#' @param dim_label A named character vector with the dimension labels
#' @param c14_corp.vec A character vector with the colours for the 14 categories
#' @param c25_corp.vec A character vector with the colours for the 25 categories
#' @param feature.names A character vector with the names of the features
#'
#' @return NULL (invisibly)
generate_pdf_content <- function(
    filename,
    input,
    Data,
    dim_label,
    c14_corp.vec,
    c25_corp.vec,
    feature.names) {
  cairo_pdf(filename, width = 12, height = 8)
  cat.variable <- switch(input$granularity,
    n14 = "OPERATOR.14",
    n25 = "OPERATOR.25"
  )
  cat.selected <- switch(input$granularity,
    n14 = input$show_OPERATOR.14,
    n25 = input$show_OPERATOR.25
  )
  cat.colours <- switch(input$granularity,
    n14 = c14_corp.vec,
    n25 = c25_corp.vec
  )
  main.txt <- dim_label[input$dim]
  if (input$focus_grade != "all") {
    main.txt <- sprintf("%s (Grade: %s)", main.txt, input$focus_grade)
  }
  y.range <- if (input$y == "features") c(-1.5, 3) else c(-0.5, 1)
  ggbox.selected(Data()$M, Data()$Meta,
    cats = cat.selected,
    variable = cat.variable,
    colours = cat.colours,
    weights = Data()$Dims[, input$dim],
    what = input$y,
    select = weights, # idx.weights
    feature.names = feature.names,
    main = main.txt,
    ylim = y.range,
    nrow = 2, base_size = 14
  ) %>% print()
  dev.off()
}

#' Define the download handler for the PDF downloa
#'
#' @param input The Shiny input object
#'
#' @return A downloadHandler object
weights_pdf_download_handler <- function(input) {
  shiny::downloadHandler(
    filename = function() {
      weights_generate_pdf_filename(
        input,
        label_cat.operator.14,
        label_cat.operator.25
      )
    },
    content = function(filename) {
      generate_pdf_content(
        filename,
        input,
        Data,
        dim_label,
        c14_corp.vec,
        c25_corp.vec,
        feature.names
      )
    },
    contentType = "application/octet-stream"
  )
}

##################### Server Function for Shiny App ############################

weights_server <- function(input, output, session) {
  ns <- session$ns

  weights_observe_preset(input, session)
  weights_save_preset_handler(input, output)

  ################################### Data #####################################
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

  ################################## Boxplot ###################################

  output$boxplot <- shiny::renderCachedPlot(
    {
      generate_boxplot(
        input,
        Data,
        feature.names,
        dim_label,
        c14_corp.vec,
        c25_corp.vec
      )
    },
    sizePolicy = size_policy,
    cacheKeyExpr = {
      list(
        grade = input$focus_grade,
        lda = input$lda,
        dim = input$dim,
        what = input$y,
        fine = input$granularity,
        size = input$plot_size,
        legend = input$use_legend,
        cats = switch(input$granularity,
          n14 = input$show_OPERATOR.14,
          n25 = input$show_OPERATOR.25
        )
      )
    },
    cache = if (persistent_cache) "app" else "session"
  )


  ############################### Density Plot #################################


  output$densities <- shiny::renderPlot(
    {
      generate_densities_plot(
        input,
        Data,
        dim_label,
        c14_corp.vec,
        c25_corp.vec
      )
    },
    execOnResize = TRUE
  )

  output$downloadPDF <- weights_pdf_download_handler(input)

  output$debugOutput <- renderText({ })
}
