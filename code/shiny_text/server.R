library(shiny)
library(shinyjs)
library(tidyverse)
library(shinyAce)


#' This function gathers values from certain variables inside the TEI Guidelines
#' header inside the .xml files and saves it inside a data frame (WD - Written
#' Data)
#'
#' @param directory A directory that includes the student text files
#' @param pattern The document file extension to look for
#' @return A named vector that contains the information

gather_xml_info <- function(directory, file) {

  parsed_file <- parse_file(directory, file)
  xml_file <- parsed_file$xml_file
  namespaces <- parsed_file$namespaces

  # text info
  student_node <- xml_find_first(xml_file, "//d1:author", namespaces)
  student_name <- xml_text(student_node)
  school_node <- xml_find_first(xml_file, "//d1:publisher", namespaces)
  school_name <- xml_text(school_node)
  grade_node <- xml_find_first(xml_file, "//d1:seriesStmt//d1:title", namespaces)
  grade_name <- xml_text(grade_node)
  course_node <- xml_find_first(xml_file, "//d1:sourceStmt//d1:p", namespaces)
  course_name <- xml_text(course_node)
  task_node <- xml_find_first(xml_file, "//d1:titleStmt//d1:title", namespaces)
  task_name <- xml_text(task_node)
  operator_node <- xml_find_first(xml_file, "//d1:titleStmt//d1:name", namespaces)
  operator_name <- xml_text(operator_node)
  time_node <- xml_find_first(xml_file, "//d1:notesStmt//d1:note[1]", namespaces)
  time_name <- xml_text(time_node)
  task_number_node <- xml_find_first (xml_file, "//d1:notesStmt//d1:note[2]", namespaces)
  task_number_name <- xml_text(task_number_node)
  genre_node <- xml_find_first(xml_file, "//d1:notesStmt//d1:note/@genre", namespaces)
  genre_name <- xml_text(genre_node)
  genre_family_node <- xml_find_first (xml_file, "//d1:notesStmt//d1:note/@genre_family", namespaces)
  genre_family_name <- xml_text(genre_family_node)

  # Create the named vector containing the information
  output_vec <- c(
    ID = student_name,
    SCHOOL = school_name,
    GRADE = grade_name,
    COURSE = course_name,
    TASK = task_name,
    OPERATOR = operator_name,
    GENRE = genre_name,
    GENRE_FAMILY = genre_family_name,
    TIME = time_name,
    TASK.NO = task_number_name
  )

  return(output_vec)
}


#### Server Function for Shiny App ####

text_server <- function(input, output, session) {

  ns <- session$ns

  # Reactive value to store the list of matching files
  matchingFiles <- reactiveVal(list.files(input_directory, recursive = TRUE))

  # Update the file list based on the search term
  observeEvent(input$search_button, {
    allFiles <- list.files(input_directory, recursive = TRUE)
    files <- if (nzchar(input$search_box)) {
      allFiles[grepl(input$search_box, allFiles, ignore.case = TRUE)]
    } else {
      allFiles
    }
    matchingFiles(files)
    updateSelectInput(session, "selected_file", choices = setNames(files, basename(files)), )
  })

  # Reactive values for storing the file content for both views
  xml_content <- reactiveVal("")
  txt_content <- reactiveVal("")
  meta_string <- reactiveVal()

  observeEvent(input$load_button, {

    input_file <- input$selected_file
    print(input_file)

    meta_vec <- gather_xml_info(input_directory, input_file)

    formatted_output <- paste0(
      "<table style='border-collapse: separate; border-spacing: 20px 2px;' border='0'>",

      # First row: ID and School
      "<tr>",
      "<td><strong>ID:</strong></td>",
      "<td>", meta_vec[["ID"]], "</td>",
      "<td style='padding-left:50px;'><strong>School:</strong></td>",
      "<td>", meta_vec[["SCHOOL"]], "</td>",
      "</tr>",

      # Second row: Task and Grade
      "<tr>",
      "<td><strong>Task:</strong></td>",
      "<td>", meta_vec[["TASK"]], "</td>",
      "<td style='padding-left:50px;'><strong>Grade:</strong></td>",
      "<td>", meta_vec[["GRADE"]], "</td>",
      "</tr>",

      # Third row: Operator and Course
      "<tr>",
      "<td><strong>Operator:</strong></td>",
      "<td>", meta_vec[["OPERATOR"]], "</td>",
      "<td style='padding-left:50px;'><strong>Course:</strong></td>",
      "<td>", meta_vec[["COURSE"]], "</td>",
      "</tr>",

      # Fourth row: Genre and No. of tasks
      "<tr>",
      "<td><strong>Genre:</strong></td>",
      "<td>", meta_vec[["GENRE"]], "</td>",
      "<td style='padding-left:50px;'><strong>No. of tasks:</strong></td>",
      "<td>", meta_vec[["TASK.NO"]], "</td>",
      "</tr>",

      # Fifth row: Genre family and Time
      "<tr>",
      "<td><strong>Genre family:</strong></td>",
      "<td>", meta_vec[["GENRE_FAMILY"]], "</td>",
      "<td style='padding-left:50px;'><strong>Time:</strong></td>",
      "<td>", meta_vec[["TIME"]], "</td>",
      "</tr>",

      "</table>"
    )
    meta_string(formatted_output)

  })

  observeEvent(input$load_button, {

    req(input$selected_file)
    filePath <- file.path(input_directory, input$selected_file)
    print(filePath)

    # Read the complete file as text while preserving newlines

    parsed_file <- parse_file(input_directory, input$selected_file)
    xml_file <- parsed_file$xml_file
    namespaces <- parsed_file$namespaces

    tei_header_node <- xml_find_first(xml_file, "//d1:teiHeader", namespaces)
    tei_node <- xml_root(xml_file)
    if (!is.null(tei_header_node)) {
      xml_remove(tei_header_node)
    }
    content <- as.character(xml_file)
    content <- sub("^<\\?xml[^>]+>\\s*\n?", "", content)
    updateAceEditor(session, "xmlEditor", value = content)

    # Remove all XML nodes using a regular expression.
    # 1. Remove all <reg> nodes and their content
    xml_file %>% xml_find_all("//d1:reg") %>% xml_remove()

    # 2. Extract the remaining XML as plain text (ignores tags, keeps text)
    text_no_tags <- xml_text(xml_file)

    # 3. Trim whitespace/newlines from beginning and end
    clean_text <- trimws(text_no_tags)
    extractedText <- gsub("\\.(?!\\s)", ". ", clean_text, perl = TRUE)
    # extractedText <- gsub("(?s)<.*?>", "", xml_file, perl = TRUE)
    txt_content(extractedText)
    updateAceEditor(session, "plainTextEditor", value = extractedText)
  })

  output$values_output <- renderUI({
    req(meta_string())
    HTML(meta_string())
  })

  output$plainTextDisplay <- renderText({
    req(txt_content())
    txt_content()
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
