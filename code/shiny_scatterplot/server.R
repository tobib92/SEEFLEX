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
    Shiny.setInputValue('xmin', xmin);
    Shiny.setInputValue('xmax', xmax);
    Shiny.setInputValue('ymin', ymin);
    Shiny.setInputValue('ymax', ymax);
}"

#' Update an input element in a Shiny session
#'
#' @param session The Shiny session object
#' @param name The name of the input element
#' @param val The new value to set
#' @param type The type of the input element
#'
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
#'
#' @return NULL (invisibly)
scatterplot_observe_preset <- function(input, session) {
  shiny::observe({
    preset <- scatterplot_presets[[input$preset]]
    for (par in c("x", "y")) {
      scatterplot_update_input(session, par, preset[[par]], "select")
    }

    for (par in c("lda", "granularity", "focus_t.curr", "focus_grade")) {
      scatterplot_update_input(session, par, preset[[par]], "radio")
    }

    for (par in c("ellipses", "transitions")) {
      scatterplot_update_input(session, par, preset[[par]], "checkbox")
    }

    for (par in c("show_OPERATOR.14", "show_OPERATOR.25")) {
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
#'
#' @return NULL (invisibly)
scatterplot_save_preset_handler <- function(input, output) {
  output$save_preset <- downloadHandler(
    filename = "scatterplot_preset.R",
    content = function(filename) {
      preset <- list(
        name = "",
        x = shiny::isolate(input$x),
        y = shiny::isolate(input$y),
        lda = isolate(input$lda),
        granularity = isolate(input$granularity),
        focus_t.curr = isolate(input$focus_t.curr),
        focus_grade = isolate(input$focus_grade),
        ellipses = isolate(input$ellipses),
        transitions = isolate(input$transitions),
        pointsize = isolate(input$pointsize)
      )
      opts <- shiny::isolate(input$save_preset_options)
      all.cat <- ("allcat" %in% opts) # whether to save all category selections
      if (all.cat || preset$granularity == "n14") {
        preset$show_OPERATOR.14 <- shiny::isolate(input$show_OPERATOR.14)
      }

      if (all.cat || preset$granularity == "n25") {
        preset$show_OPERATOR.25 <- shiny::isolate(input$show_OPERATOR.25)
      }

      if ("viewport" %in% opts) {
        preset$viewport <- list(
          xmin = shiny::isolate(input$xmin), xmax = isolate(input$xmax),
          ymin = isolate(input$ymin), ymax = isolate(input$ymax)
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
#'
#' @return A reactive data frame containing the data to plot
scatterplot_get_data <- function(input) {
  shiny::reactive({
    data.df <- if (input$lda == "lda14") LDA4.df else if (input$lda == "lda25") PCA4.df

    if (!all(label_grade %in% input$focus_grade)) {
      data.df %<>% subset(GRADE == input$focus_grade)
    }

    data.df <- switch(input$granularity,
      n14 = subset(data.df, OPERATOR.14 %in% input$show_OPERATOR.14),
      n25 = subset(data.df, OPERATOR.25 %in% input$show_OPERATOR.25)
    )

    data.df %<>% droplevels()

    if (!all(label_t.curr %in% input$focus_t.curr)) {
      data.df %<>% subset(T.CURR == input$focus_t.curr) # no droplevels so we don't lose the legend
    }

    data.df
  })
}

############################### Plot Generation ################################

#' Generate a scatterplot using the scatterD3 package
#'
#' @param input The Shiny input object
#' @param data The data to plot
#'
#' @return A scatterD3 object
generate_scatterplot <- function(input, data) {
  input$reset_zoom # so redisplay is triggered after resetting zoom
  col.vec <- switch(input$granularity,
    n14 = data()$OPERATOR.14,
    n25 = data()$OPERATOR.25
  )
  col.values <- switch(input$granularity,
    n14 = c14_corp.vec,
    n25 = c25_corp.vec
  )
  symbol_var <- switch(input$filter,
    grade = data()$GRADE,
    t.curr = data()$T.CURR
  )
  symbols <- if (input$filter == "grade") {
    symbols <- symbols.vec.grade
  } else if (input$filter == "t.curr") {
    symbols <- symbols.vec.t.curr
  }
  symbol_lab <- if (input$filter == "grade") {
    symbol_lab <- "Grade"
  } else if (input$filter == "t.curr") {
    symbol_lab <- "Curricular Task"
  }

  tooltip_pca <- paste(
    "ID:", data()$ID,
    # "<br /> PC1:", data()$PC1, # needs input from granularity and dims
    # "<br /> PC2:", data()$PC2,
    "<br /> OPERATOR:", data()$OPERATOR.14,
    "<br /> T.CURR:", data()$T.CURR,
    "<br /> GRADE:", data()$GRADE
  )
  tooltip_lda <- paste(
    "ID:", data()$ID,
    # "<br /> PC1:", data()$PC1, # needs input from granularity and dims
    # "<br /> PC2:", data()$PC2,
    "<br /> Operator:", data()$OPERATOR.14,
    "<br /> T.Curr:", data()$T.CURR,
    "<br /> Grade:", data()$GRADE
  )
  scatterD3::scatterD3(
    y = data()[, input$y],
    x = data()[, input$x],
    fixed = TRUE,
    xlab = dim_label[[input$x]],
    ylab = dim_label[[input$y]],
    xlim = c(isolate(input$xmin), isolate(input$xmax)),
    ylim = c(isolate(input$ymin), isolate(input$ymax)),
    col_var = col.vec,
    col_lab = "Operator (Command word)",
    colors = col.values,
    symbol_var = symbol_var,
    symbol_lab = symbol_lab,
    symbols = symbols,
    point_size = 2^input$pointsize,
    tooltips = TRUE,
    tooltip_text = tooltip_pca,
    key_var = rownames(data()),
    ellipses = input$ellipses,
    transitions = input$transitions,
    lasso = TRUE,
    lasso_callback = lasso.callback,
    zoom_callback = zoom.callback,
    axes_font_size = "160%",
    legend_font_size = "140%",
    legend_width = 200,
    left_margin = 40,
    menu = FALSE
  )
}

##################### PDF Download Functions ###################################

#' Generate the filename for the PDF download
#'
#' @param input The Shiny input object
#'
#' @return A character string with the filename
#'
scatterplot_generate_pdf_filename <- function(input) {
  # Determine the category list based on the granularity input
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
  # Check if the category list has elements
  has_categories <- length(cat.list) > 0

  # Create a string representation of the category list
  cat.list <- if (has_categories) {
    paste(cat.list, collapse = "-")
  } else {
    "none"
  }

  sprintf(
    "ICE-scatter_%s_%s_%s_%s-%s%s_cat%d=%s.html",
    input$lda,
    paste(input$focus_grade, collapse = "-"),
    paste(input$focus_t.curr, collapse = "-"),
    input$y, input$x,
    if (input$ellipses) "_conf" else "",
    switch(input$granularity,
      n14 = 14,
      n25 = 25
    ),
    cat.list
  )
}

#' Define the download handler for the PDF downloa
#'
#' @param input The Shiny input object
#'
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

  ## create the D3 scatterplot object, so it can either be displayed or saved to a file
  D3plot <- shiny::reactive(generate_scatterplot(input, data))
  output$scatterPlot <- scatterD3::renderScatterD3(D3plot())

  output$download_plot <- scatterplot_pdf_download_handler(input)

  output$debugOutput <- renderText({ })
}
