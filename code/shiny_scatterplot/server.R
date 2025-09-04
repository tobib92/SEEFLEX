library(shiny)
library(shinyjs)
library(scatterD3)

lasso.callback <- "
function(sel) {
    /* this is just a dummy implementation to be replaced later */
    pts = sel.data().map(function(d) {return d.key_var});
    alert(pts.length + ' texts selected');
}"

zoom.callback <- "
function(xmin, xmax, ymin, ymax) {
    Shiny.setInputValue('scatter-xmin', xmin);
    Shiny.setInputValue('scatter-xmax', xmax);
    Shiny.setInputValue('scatter-ymin', ymin);
    Shiny.setInputValue('scatter-ymax', ymax);
}"

zoom.set.code <- "
Shiny.setInputValue('scatter-xmin', %g);
Shiny.setInputValue('scatter-xmax', %g);
Shiny.setInputValue('scatter-ymin', %g);
Shiny.setInputValue('scatter-ymax', %g);
"

#' Update an input element in a Shiny session
#'
#' @param session The Shiny session object
#' @param name The name of the input element
#' @param val The new value to set
#' @param type The type of the input element
#' @return NULL (invisibly)

scatterplot_update_input <- function(
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
#' @return NULL (invisibly)

scatterplot_observe_preset <- function(input, session) {
  shiny::observe({
    preset <- scatterplot_presets[[input$preset]]

    for (par in c("x", "y")) {
      scatterplot_update_input(session, par, preset[[par]], "select")
    }

    for (par in c("lda", "granularity", "filter_col", "filter_sym",
                  "focus_t.curr", "focus_grade", "focus_genre")) {
      scatterplot_update_input(session, par, preset[[par]], "radio")
    }
    for (par in c("ellipses", "transitions")) {
      scatterplot_update_input(session, par, preset[[par]], "checkbox")
    }

    for (par in c("show_OPERATOR.17", "show_OPERATOR.25")) {
      scatterplot_update_input(session, par, preset[[par]], "group")
    }

    for (par in c("pointsize")) {
      scatterplot_update_input(session, par, preset[[par]], "slider")
    }

    vp <- preset$viewport

    if (!is.null(vp)) {
      shinyjs::runjs(sprintf(zoom.set.code, vp$xmin, vp$xmax, vp$ymin, vp$ymax))
    }
  })
}

#' Handle the download of a preset file
#'
#' @param input The Shiny input object
#' @param output The Shiny output object
#' @return NULL (invisibly)

scatterplot_save_preset_handler <- function(input, output) {
  output$save_preset <- downloadHandler(
    filename = "scatterplot_preset.R",
    content = function(filename) {
      preset <- list(
        name = shiny::isolate(input$name_preset),
        x = shiny::isolate(input$x),
        y = shiny::isolate(input$y),
        lda = isolate(input$lda),
        granularity = isolate(input$granularity),
        filter_col = isolate(input$filter_col),
        filter_sym = isolate(input$filter_sym),
        ellipses = isolate(input$ellipses),
        focus_t.curr = isolate(input$focus_t.curr),
        focus_genre = isolate(input$focus_genre),
        focus_grade = isolate(input$focus_grade),
        transitions = isolate(input$transitions),
        pointsize = isolate(input$pointsize)
      )
      opts <- shiny::isolate(input$save_preset_options)
      all.cat <- ("allcat" %in% opts) # whether to save all category selections
      if (all.cat || preset$granularity == "n17") {
        preset$show_OPERATOR.17 <- shiny::isolate(input$show_OPERATOR.17)
      }

      if (all.cat || preset$granularity == "n25") {
        preset$show_OPERATOR.25 <- shiny::isolate(input$show_OPERATOR.25)
      }

      if ("viewport" %in% opts) {
        preset$viewport <- list(
          xmin=isolate(input$xmin), xmax=isolate(input$xmax),
          ymin=isolate(input$ymin), ymax=isolate(input$ymax)
        )
      }
      dump("preset", file = filename)
    },
    contentType = "text/plain"
  )
}

#' Get the data for the scatterplot
#'
#' @param input The Shiny input object
#' @return A reactive data frame containing the data to plot

scatterplot_get_data <- function(input) {
  shiny::reactive({
    data.df <- if (input$lda == "pca") {
      PCA4.df
    } else if (input$lda == "lda_genre") {
      LDA4_genre.df
    } else if (input$lda == "lda_t.curr") {
      LDA4_t.curr.df
    } else if (input$lda == "lda_operator17") {
      LDA4_operator17.df
    } else if (input$lda == "lda_operator25") {
      LDA4_operator25.df
    } else {
      stop(paste("Unrecognized input in scatterplot_get_data:", input$lda))
    }

    if (!all(label_grade %in% input$focus_grade)) {
      data.df %<>% subset(GRADE %in% input$focus_grade)
    }

    if (!all(label_genre %in% input$focus_genre)) {
      data.df %<>% subset(GENRE %in% input$focus_genre)
    }

    if (!all(label_grade %in% input$focus_grade)) {
      data.df %<>% subset(GRADE %in% input$focus_grade)
    }

    if (!all(label_t.curr %in% input$focus_t.curr)) {
      data.df %<>% subset(T.CURR %in% input$focus_t.curr) # no droplevels so we don't lose the legend
    }
    data.df <- switch(input$granularity,
      n17 = subset(data.df, OPERATOR.17 %in% input$show_OPERATOR.17),
      n25 = subset(data.df, OPERATOR.25 %in% input$show_OPERATOR.25)
    )

    data.df %<>% droplevels()

    # print(paste("no. of texts currently selected:", nrow(data.df)))
    # print(paste("no. of courses currently selected:", length(unique(data.df$COURSE))))

    data.df
  })
}


#### Plot Generation ####

#' This function takes the information from the UI input on the selected
#' multivariate analysis and the dimension number from the selected data frame
#' column to create the necessary output string to display the plot correctly.
#'
#' @param selected_analysis_label Value of UI input on multivar. analysis
#' @param selected_dimension Selected column of data frame

get_column_name_from_ui <- function(selected_analysis_label, selected_dimension) {

  column_name <- ""
  analysis_label_prefix <- substr(selected_analysis_label, 1,3)
  if (analysis_label_prefix == "pca") {
    column_name <- paste0(column_name, "PC")
  } else if (analysis_label_prefix == "lda") {
    column_name <- paste0(column_name, "LD")
  } else {
    stop("Unknown analysis label!")
  }

  selected_dimension_number <- substr(
    selected_dimension, nchar(selected_dimension), nchar(selected_dimension))

  column_name <- paste0(column_name, selected_dimension_number)

  return(column_name)
}


#' Generate a scatterplot using the scatterD3 package
#'
#' @param input The Shiny input object
#' @param data The data to plot
#' @return A scatterD3 object

generate_scatterplot <- function(input, data) {
  input$reset_zoom # so redisplay is triggered after resetting zoom

  # Switch color focus variable
  col_var <- switch(input$filter_col,
    `Operator 17` = data()$OPERATOR.17,
    `Operator 25` = data()$OPERATOR.25,
    `Curricular task` = data()$T.CURR,
    Genre = data()$GENRE,
    Monochrome = "No color variable"
  )

  # Create the switch for the color vectors
  col_val <- switch(input$filter_col,
    `Operator 17` = c17_corp.vec,
    `Operator 25` = c25_corp.vec,
    `Curricular task` = c5_corp.vec,
    Genre = c7_corp.vec,
    Monochrome = c1_corp.vec
  )

  # Define legend labels depending on color focus variable
  color_lab <- if (input$filter_col == "Operator 17") {
    color_lab <- "Operator 17"
  } else if (input$filter_col == "Operator 25") {
    color_lab <- "Operator 25"
  } else if (input$filter_col == "Curricular task") {
    color_lab <- "Curricular task"
  } else if (input$filter_col == "Genre") {
    color_lab <- "Genre"
  } else if (input$filter_col == "Grade") {
    color_lab <- "Grade"
  } else if (input$filter_col == "Monochrome") {
    color_lab <- "Monochrome"
  }

  # Switch symbol focus variable
  symbol_var <- switch(input$filter_sym,
    Grade = data()$GRADE,
    `Curricular task` = data()$T.CURR,
    Genre = data()$GENRE,
    Monochrome = "No symbol variable"
  )

  # Define symbol types depending on symbol focus variable
  symbol_val <- if (input$filter_sym == "Grade") {
    symbols <- symbols.vec.grade
  } else if (input$filter_sym == "Curricular task") {
    symbols <- symbols.vec.t.curr
  } else if (input$filter_sym == "Genre") {
    symbols <- symbols.vec.genre
  } else if (input$filter_sym == "Monochrome") {
    symbols <- symbols.vec.monochrome
  } else {
    stop(paste("No input found for", input$filter_sym))
  }

  # Define symbol labels depending on symbol focus variable
  symbol_lab <- if (input$filter_sym == "Grade") {
    symbol_lab <- "Grade"
  } else if (input$filter_sym == "Curricular task") {
    symbol_lab <- "Curricular Task"
  } else if (input$filter_sym == "Genre") {
    symbol_lab <- "Genre"
  } else if (input$filter_sym == "Monochrome") {
    symbol_lab <- "Monochrome"
  }

  # Change labels for LDA and PCA
  dim_label_lab <- if (input$lda == "pca") {
    dim_label_lab <- dim_label_pca
  } else {
    dim_label_lab <- dim_label_lda
  }

  # Filter values to only show selected colors in legend
  filtered_legend_color_values <- switch(input$filter_col,
    `Operator 17` = unique(data()$OPERATOR.17),
    `Operator 25` = unique(data()$OPERATOR.25),
    `Curricular task` = unique(data()$T.CURR),
    Genre = unique(data()$GENRE),
    Monochrome = "No color variable"
  )

  # Filter values to only show selected symbols in legend
  filtered_legend_symbol_values <- switch(input$filter_sym,
    `Curricular task` = unique(data()$T.CURR),
    Genre = unique(data()$GENRE),
    Grade = unique(data()$GRADE),
    Monochrome = "No symbol variable"
  )

  # Create the plot
  scatterD3::scatterD3(
    y = data()[, get_column_name_from_ui(input$lda, input$y)],
    x = data()[, get_column_name_from_ui(input$lda, input$x)],
    fixed = TRUE,
    xlab = dim_label_lab[[input$x]],
    ylab = dim_label_lab[[input$y]],
    xlim = c(isolate(input$xmin), isolate(input$xmax)),
    ylim = c(isolate(input$ymin), isolate(input$ymax)),
    col_var = col_var,
    col_lab = color_lab,
    colors = col_val[names(col_val) %in% filtered_legend_color_values],
    symbol_var = symbol_var,
    symbol_lab = symbol_lab,
    symbols = symbol_val[names(symbol_val) %in% filtered_legend_symbol_values],
    point_size = 2^input$pointsize,
    tooltips = TRUE,
    tooltip_text = data()$tooltip,
    key_var = rownames(data()),
    ellipses = input$ellipses,
    transitions = input$transitions,
    lasso = TRUE,
    lasso_callback = lasso.callback,
    zoom_callback = zoom.callback,
    axes_font_size = "160%",
    legend_font_size = "130%",
    legend_width = 200,
    left_margin = 40,
    menu = FALSE
  )
}

#### PDF Download Functions ####

#' Generate the filename for the PDF download
#'
#' @param input The Shiny input object
#' @return A character string with the filename

scatterplot_generate_pdf_filename <- function(input) {
  # Determine the category list based on the granularity input
  cat.list <- switch(input$granularity,
    n17 = {
      all_selected <- setequal(input$show_OPERATOR.17, label_cat.operator.17)
      if (all_selected) {
        "all"
      } else {
        cat_label.operator.17[input$show_OPERATOR.17]
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
  # Check if the category list has elements
  has_categories <- length(cat.list) > 0

  # Create a string representation of the category list
  cat.list <- if (has_categories) {
    paste(cat.list, collapse = "-")
  } else {
    "none"
  }

  sprintf(
    "seeflex-scatter_%s_%s_%s_%s-%s%s_cat%d=%s.html",
    input$lda,
    paste(input$focus_grade, collapse = "-"),
    paste(input$focus_t.curr, collapse = "-"),
    input$y, input$x,
    if (input$ellipses) "_conf" else "",
    switch(input$granularity,
      n17 = 17,
      n25 = 25
    ),
    cat.list
  )
}

#' Define the download handler for the PDF download
#'
#' @param input The Shiny input object
#' @return A downloadHandler object

scatterplot_pdf_download_handler <- function(input) {
  shiny::downloadHandler(
    filename = scatterplot_generate_pdf_filename(input),
    content = function(filename) {
      t.curr.txt <- switch(input$focus_t.curr,
        both = "both",
        W = "written",
        S = "spoken"
      )
      title.txt <- sprintf(
        "ICE-%s – %s vs. %s – %s",
        input$focus_variety,
        dim2label[input$y], dim2label[input$x],
        mode.txt
      )
      saveWidget(
        D3plot(),
        file = filename,
        title = title.txt,
        selfcontained = TRUE
      )
    },
    contentType = "application/octet-stream"
  )
}

scatterplot_server <- function(input, output, session) {
  ns <- session$ns

  scatterplot_observe_preset(input, session)
  scatterplot_save_preset_handler(input, output)

  data <- scatterplot_get_data(input)

  # create the D3 scatterplot object, so it can either be displayed or saved to a file
  D3plot <- shiny::reactive(generate_scatterplot(input, data))
  output$scatterPlot <- scatterD3::renderScatterD3(D3plot())

  # Observe both input$granularity and input$filter_col and mutually adjust
  observeEvent(input$granularity, {
    false_triggers <- c("Curricular task", "Genre", "Grade")
    if (input$granularity == "n17" && !(input$filter_col %in% false_triggers)) {
      updateRadioButtons(session, "filter_col", selected = "Operator 17")
    } else if (input$granularity == "n25" && !(input$filter_col %in% false_triggers)) {
      updateRadioButtons(session, "filter_col", selected = "Operator 25")
    }
  })
  observeEvent(input$filter_col, {
    if (input$filter_col == "Operator 17") {
      updateRadioButtons(session, "granularity", selected = "n17")
    } else if (input$filter_col == "Operator 25") {
      updateRadioButtons(session, "granularity", selected = "n25")
    }
  })

  output$current_selection_count <- renderPrint({
    print(paste("no. of texts currently selected:", nrow(data())))
    print(paste("no. of courses currently selected:", length(unique(data()$COURSE))))
  })

  output$download_plot <- scatterplot_pdf_download_handler(input)

  output$debugOutput <- renderText({ })
}
