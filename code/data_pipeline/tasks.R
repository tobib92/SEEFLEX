#### Set working directory to the SEEFLEX root folder ####

source("code/data_pipeline/meta_utils.R")
source("code/data_pipeline/xml_utils.R")
source("code/data_pipeline/meta_data.R")

library(xlsx)


#' Clean the task data by adding a count, adding the courses the prompt appears
#' in and only keeping each prompt once.
#'
#' @param df The data frame that is to be cleaned.

summarize_task_data <- function(df) {
  df %>%
    dplyr::group_by(PROMPT) %>%
    dplyr::mutate(COUNT = n()) %>% # Count occurrences of each value in A
    # Append C values if A occurs more than once
    dplyr::mutate(IN_COURSES = ifelse(COUNT > 1, paste(COURSE, collapse = ", "), COURSE)) %>%
    dplyr::ungroup() %>%
    dplyr::distinct(PROMPT, .keep_all = TRUE)
}


#' This function creates the task ID from the course ID and the task number.
#'
#' @param df A data frame containing the COURSE and TASK columns

create_task_id <- function(df) {

  df <- df %>%
    dplyr::mutate(TASK_ID = str_c(COURSE, TASK, sep = "_")) %>%
    dplyr::relocate(TASK_ID, .before = 1)

  return(df)

}

#' This function creates the match from COURSE, T.CURR and OPERATOR.25 for
#' matching with the written data.
#'
#' @param df A data frame containing the COURSE and TASK columns

create_task_match <- function(df) {

  df_match <- df %>%
    dplyr::mutate(MATCH = str_c(COURSE, T.CURR, OPERATOR.25, sep = "_")) %>%
    dplyr::relocate(MATCH, .before = 1)

  return(df_match)

}


#' This function changes the task column depending on T.CURR. It also checks
#' for duplicates in TASK, COURSE, and T.CURR and assigns a count to TASK to
#' differentiate between the unique entries.
#'
#' @param df A data frame containing the T.CURR, the COURSE, and TASK column.

differentiate_t3_in_df <- function(df) {

  # change task column depending on T.CURR

  for (i in 1:nrow(df)) {
    if (df$T.CURR[i] == "creative") {
      df$TASK[i] <- "t3c"
    } else if (df$T.CURR[i] == "argumentative") {
      df$TASK[i] <- "t3a"
    } else if (df$T.CURR[i] %in% c("int.reading", "analysis", "mediation")) {
      print(paste("No change made to", df$TASK[i], "in", df$COURSE[i]))
    } else {
      stop("No match found in task ID")
    }
  }

  # Create a new column that counts occurrences of each combination of A and B
  df$count <- ave(1:nrow(df), df$TASK, df$T.CURR, df$COURSE, FUN = length)

  # Create a suffix only for combinations that occur more than once
  df$suffix <- ifelse(df$count > 1, ave(1:nrow(df), df$TASK, df$COURSE,
                                        FUN = seq_along), NA)

  # Add the suffix to values in column A where applicable
  df$TASK <- ifelse(!is.na(df$suffix), paste0(df$TASK, df$suffix), df$TASK)

  # Remove temporary columns
  df$count <- NULL
  df$suffix <- NULL

  return(df)
}


#' Create a data frame from edited Excel file that unlists the courses and
#' selects the appropriate columns for merging with the original task data
#' frame.
#'
#' @param df The data frame that contains the genres added manually in Excel.

extend_task_df <- function(df) {

  df <- df %>%
    dplyr::select(TASK, T.CURR, GENRE, GENRE_FAMILY, IN_COURSES) %>%
    tidyr::separate_rows(IN_COURSES, sep = ",") %>%
    dplyr::relocate(IN_COURSES, .before = TASK) %>%
    dplyr::mutate_at(vars(IN_COURSES), ~ str_trim(.)) %>%
    plyr::arrange(IN_COURSES) %>%
    dplyr::rename(COURSE = IN_COURSES)

  df <- create_task_id(df)

  return(df)

}


#' This function creates a lookup and returns the matching values from data_key.
#'
#' @param lookup_value Value to be returned based on lookup_key
#' @param lookup_key Value to be matched based on data_key
#' @param data_key List of values to return lookups for
#' @param full_match If true will error if any non-matches are found
#' @return A named list.

perform_lookup <- function(lookup_value, lookup_key, data_key,
                           full_match = TRUE) {

  # Lookup value must be the same length as lookup_key
  stopifnot(length(lookup_value) == length(lookup_key))

  my_lookup <- setNames(as.list(lookup_value), lookup_key)

  matches <- sapply(data_key, function(key) my_lookup[[key]])

  null_values <- sapply(matches, is.null)

  has_nulls <- any(null_values)

  if (has_nulls & full_match) {
    missing_keys <- names(matches)[null_values]
    print(unique(missing_keys))
    stop("There are non-matching values.")
  }

  return(matches)

}


#' This function create the nodes containing the genre and the genre family
#' in the TEI Header for a file.
#'
#' @param xml_file A parsed xml file
#' @param namespaces An xml namespaces object
#' @param df A data frame containing the genre information

create_genre_nodes <- function(xml_file, namespaces, df) {

  # get the author node from xml file and extract the string
  author_node <- xml_find_first(xml_file, "//d1:titleStmt//d1:author", namespaces)
  author_text <- xml_text(author_node)

  # match the ids from the file and the df
  matched_id <- df %>%
    dplyr::filter(ID == author_text)

  # get the operator name from the xml file
  operator_node <- xml_find_first(xml_file, "//d1:titleStmt//d1:name", namespaces)
  operator_text <- xml_text(operator_node)

  # find the notesStmt node
  notesStmt_node <- xml_find_first(xml_file, "//d1:notesStmt", namespaces)

  if (nrow(matched_id) == 1) {
    # Create a new 'note' node with operator as text
    note_node <- xml_add_child(notesStmt_node, "note", operator_text)

    # Add attributes from the data frame columns
    xml_set_attr(note_node, "genre", matched_id$GENRE[1])
    xml_set_attr(note_node, "genre_family", matched_id$GENRE_FAMILY[1])

  } else {
    stop("Matched task ID not equal to 1!")
  }

  return(xml_file)
}


#' This function adds a "c" to all t3 that are classed as creative and an "a"
#' to all t3 that are classed as argumentative.
#'
#' @param xml_file A parsed xml file
#' @param namespaces An xml namespaces object
#' @param df A data frame containing the task information

update_task_nodes <- function(xml_file, namespaces, df) {

  # get the author node from xml file and extract the string
  author_node <- xml_find_first(xml_file, "//d1:titleStmt//d1:author", namespaces)
  author_text <- xml_text(author_node)

  # get the task node from xml file
  task_node <- xml_find_first(xml_file, "//d1:titleStmt//d1:title", namespaces)

  # match the ids from the file and the df
  matched_id <- df %>%
    dplyr::filter(ID == author_text)

  if (nrow(matched_id) == 1) {
    xml_text(task_node) <- matched_id$TASK[1]
  } else {
    stop("Matched task ID not equal to 1!")
  }

  return(xml_file)
}


#' This function applies the create_genre_nodes function to a directory changing
#' all files in it and writing them to an output directory.
#'
#' @param input_directory A directory that contains the XML files
#' @param output_directory A directory where the new files are saved

write_genre_nodes <- function(input_directory, output_directory) {

  # Get a list of all files in "directory"
  all_filenames <- gather_files(input_directory = input_directory,
                                output_directory = output_directory)

  for (file in all_filenames) {

    # Read in the file as an XML object
    parsed_file <- parse_file(directory = input_directory,
                              filename = file)

    xml_file <- parsed_file$xml_file
    namespaces <- parsed_file$namespaces

    genre_file <- create_genre_nodes(xml_file = xml_file,
                                     namespaces = namespaces,
                                     df = WD)

    # create the output file, define new file name, define new folder name
    output_file <- create_output_path(filepath = file,
                                      output_directory = output_directory
                                      )

    # write the xml file into the new output file
    write_xml(genre_file, file = output_file)

  }
  print("All genre nodes written into .xml files!")
}


#' This function applies the update_task_nodes function to a directory changing
#' all files in it and writing them to an output directory.
#'
#' @param input_directory A directory that contains the XML files
#' @param output_directory A directory where the new files are saved
#' @note WD needs to be loaded from meta_data.R

write_task_nodes <- function(input_directory, output_directory) {

  # Get a list of all files in "directory"
  all_filenames <- gather_files(input_directory = input_directory,
                                output_directory = output_directory)

  for (file in all_filenames) {

    # Read in the file as an XML object
    parsed_file <- parse_file(directory = input_directory,
                              filename = file)

    xml_file <- parsed_file$xml_file
    namespaces <- parsed_file$namespaces

    task_file <- update_task_nodes(xml_file = xml_file,
                                   namespaces = namespaces,
                                   df = WD)

    # create the output file, define new file name, define new folder name
    output_file <- create_output_path(filepath = file,
                                      output_directory = output_directory
                                      )

    # write the xml file into the new output file
    write_xml(task_file, file = output_file)

  }
  print("All task nodes written into .xml files!")

}


##### Matching tasks and genres #####

# Read the raw tasks table, clean it, add operators and write to .xlsx.
TD <- read_delim("data/tasks.csv", delim = ";")
TD <- group_operators(TD)
TD <- differentiate_t3_in_df(TD)
TD <- create_task_id(TD)
GD <- read.csv("data/genres.csv", sep = ";")

# Join the data frames
TD <- TD %>%
  left_join(GD, by = "TASK_ID") %>%
  dplyr::relocate(GENRE, .after = T.CURR) %>%
  dplyr::relocate(GENRE_FAMILY, .after = GENRE)

# Add match column to TD and WD
TD_match <- create_task_match(TD)
WD_match <- create_task_match(WD)

# Lookup tasks, genres and genre families in TD and write to WD
WD$TASK <- perform_lookup(TD_match$TASK, TD_match$MATCH, WD_match$MATCH)
WD$GENRE <- perform_lookup(TD_match$GENRE, TD_match$MATCH, WD_match$MATCH)
WD$GENRE_FAMILY <- perform_lookup(TD_match$GENRE_FAMILY, TD_match$MATCH,
                                  WD_match$MATCH)

# Write the task nodes to a directory of files
write_task_nodes(input_directory = "data/anon/",
                  output_directory = "data/anon/")

# Write the genre nodes to a directory of files
write_genre_nodes(input_directory = "data/anon/",
                  output_directory = "data/anon/")

# write the combined data frame to a file
current_date <- format(Sys.Date(), "%Y%m%d")
output_filename <- paste0("data/", current_date, "_tasks_complete.csv")
write.csv(x = TD, file = output_filename, row.names = FALSE)

##### Manual genre matching #####
# Read the modified Excel file and match the genres to tasks
# GD <- read.xlsx(file = "../../output/tasks.xlsx", sheetIndex = 1)
# GD <- read.xlsx(file = "../../../../sciebo/IfAAR/Forschung/Dissertation/Data Analysis/seeflex/output/tasks.xlsx", sheetIndex = 1)
# GD <- differentiate_t3_in_df(GD)
# GD <- match_genres_to_tasks(GD)
# GD <- GD %>%
#   dplyr::select(TASK_ID, GENRE, GENRE_FAMILY)
