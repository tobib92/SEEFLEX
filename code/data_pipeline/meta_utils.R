library(xml2)
library(stringr)
library(tidyverse)
library(stringr)
library(plyr)


#' This function cleans the meta data in the fashions described in the lines
#' below.
#'
#' @param meta The meta data table

clean_meta <- function(meta) {

  meta <- meta %>%
    # remove whitespaces and the beginning and the end of the values
    dplyr::mutate_at(vars(ACQ2.PLACE, ACQ4.PLACE, ACQ3),
                     ~str_trim(., side = "both")) %>%
    # replace "Duolingo" with "App"
    dplyr::mutate_at(vars(ACQ3.PLACE, ACQ4.PLACE, ACQ5.PLACE),
                     ~str_replace_all(., "Duolingo", "App")) %>%
    # make spelling of "Language course" consistent
    dplyr::mutate_at(vars(ACQ4.PLACE),
                     ~str_replace_all(., "Language Course",
                                      "Language course")) %>%
    # make spelling of "Latin" consistent
    dplyr::mutate_at(vars(DOM5), ~str_replace_all(., "latin", "Latin")) %>%
    # replace NAs in the vars with 0
    dplyr::mutate_at(vars(INFL.FRIENDS, INFL.FAMILY, INFL.READ, INFL.CLASS,
                          INFL.SELFSTUDY, INFL.TV, INFL.SOCIALMEDIA, INFL.MUSIC,
                          EXPO.FRIENDS, EXPO.FAMILY, EXPO.READ, EXPO.CLASS,
                          EXPO.SELFSTUDY, EXPO.TV, EXPO.SOCIALMEDIA,
                          EXPO.MUSIC),
                     ~ replace(., is.na(.), 0)) %>%
    # fix some data type issues
    mutate(across(c(ENG.COURSE, GER.COURSE), as.character)) %>%
    # replace 1 with GK
    dplyr::mutate_at(vars(ENG.COURSE, GER.COURSE),
                     ~str_replace_all(., "1", "GK")) %>%
    # replace 2 with LK
    dplyr::mutate_at(vars(ENG.COURSE, GER.COURSE),
                     ~str_replace_all(., "2", "LK"))

  return(meta)

}


#' This function calculates the score for the LexTALE test (Lemhöfer & Broersma
#' 2012).
#'
#' @param meta The meta data table
#' @param words The column containing the number of words guessed correctly
#' @param nonwords The column containing the number of non-words guessed
#' correctly
#' @param score The column name of the overall score


calculate_lextale <- function(meta, words, nonwords, score) {

  meta[[score]] <- ((meta[[words]] / 40 * 100) +
                      (meta[[nonwords]] / 20 * 100)) / 2

  lextale_vars <- c(words, nonwords)
  
  meta <- meta %>%
    dplyr::relocate(matches(score), .after = nonwords) %>%
    dplyr::select(-all_of(lextale_vars))

  return(meta)

}


#' This function calculates the score the different levels of the Vocabulary
#' Levels Test (Schmitt, Schmitt & Clapham 2001) and the New Vocabulary Levels
#' Test (Webb, Sasao & Balance 2017) and creates an overall score of all levels.
#'
#' @param meta The meta data table
#' @param pattern The pattern to match all columns containing levels


calculate_vlt <- function(meta, pattern) {

  selected_columns <- dplyr::select(meta, matches(pattern))

  for (column_name in names(selected_columns)) {
    meta[[column_name]] <- round(meta[[column_name]] / 30 * 100, digits = 2)
  }

  meta$VLT_Overall <- round(rowSums(selected_columns) / 210 * 100, digits = 2)

  return(meta)

}


#' This function normalizes student input from multiple columns meant to add up
#' to 100% if it doesn't.
#'
#' @param meta The meta data table
#' @param pattern The pattern matching all variables in question
#' @param sum_column The name of the original sum column


normalize_sum_scores <- function(meta, pattern, sum_column) {

  sum_column <- sum_column
  selected_columns <- dplyr::select(meta, matches(pattern))

  for (column_name in names(selected_columns)) {

    new_column_name <- paste0(column_name, "_mod")

    meta[[new_column_name]] <- ifelse(meta[[sum_column]] != 100,
                                      round(meta[[column_name]] /
                                        meta[[sum_column]] * 100, digits = 2),
                                      meta[[column_name]])
  }

  seleted_columns_mod <- dplyr::select(meta, matches(paste0(pattern, "_mod")))
  new_sum_column_name <- paste0(sum_column, "_mod")
  meta[[new_sum_column_name]] <- round(rowSums(seleted_columns_mod), digits = 0)

  meta <- meta %>%
    dplyr::relocate(matches(paste0(pattern, "_mod")), .after = sum_column) %>%
    dplyr::select(-c(matches(paste0("^", pattern, "$"), perl = TRUE),
              matches(paste0("^", sum_column, "$"), perl = TRUE),
              matches(new_sum_column_name))) %>%
    dplyr::rename_at(vars(matches(paste0(pattern, "_mod"), perl = TRUE)),
              ~str_remove(., "_mod")) %>%

  return(meta)

}


#' This function calculates the score for The Efficient Assessment of Need for
#' Cognition (Cacioppo, Petty & Kao 1984). It recodes the values that are the
#' result of questions with negative polarity.
#'
#' @param meta The meta data table
#' @param pattern The pattern matching all variables in question

calculate_nfc <- function(meta, pattern) {

  selected_columns <- dplyr::select(meta, matches(pattern))

  columns_to_recode <- dplyr::select(meta, c("PERS3","PERS4", "PERS5", "PERS7",
                                       "PERS8", "PERS9", "PERS12", "PERS16",
                                       "PERS17"))

  for (column_name in names(selected_columns)){
    meta[[column_name]] <- round(meta[[column_name]], digits = 0)
  }

  for (column_name in names(columns_to_recode)) {
    meta[[column_name]] <- case_match(meta[[column_name]],
                                      1~5, 2~4, 3~3, 4~2, 5~1)
  }

  meta <- meta %>%
    mutate(NFC = round(rowSums(selected_columns) / 18, digits = 2)) %>%
    relocate(NFC, .after = "PERS18") %>%
    dplyr::select(-matches(paste0(pattern)))

  return(meta)
}


#' This function gathers values from certain variables inside the TEI Guidelines
#' header inside the .xml files and saves it inside a data frame (WD - Written
#' Data)
#'
#' @param directory A directory that includes the student text files
#' @param pattern The document file extension to look for
#' @return A data frame that contains the information

gather_text_info <- function(directory) {

  all_files <- gather_files(input_directory = directory)

  output_df <- data.frame()

  for (file in all_files) {

    # Read in the file as an XML node object
    xml_file <- read_xml(file)

    # Get the namespaces for the document
    namespaces <- xml_ns(xml_file)

    # extract the unique student ID (in our case this is equivalent to the
    # author name)
    student_node <- xml_find_first(xml_file, "//d1:author", namespaces)
    student_name <- xml_text(student_node)

    # extract the school name (in our case this is equivalent to the publisher)
    school_node <- xml_find_first(xml_file, "//d1:publisher", namespaces)
    school_name <- xml_text(school_node)

    # extract grade name (in our case this is equivalent to the title of the
    # seriesStmt node)
    grade_node <- xml_find_first(xml_file, "//d1:seriesStmt//d1:title",
                                 namespaces)
    grade_name <- xml_text(grade_node)

    # extract the course name (in our case this is equivalent to the sourceStmt
    # p name)
    course_node <- xml_find_first(xml_file, "//d1:sourceStmt//d1:p", namespaces)
    course_name <- xml_text(course_node)

    # extract the task number (in our case this is equivalent to the titleStmt
    # title name)
    task_node <- xml_find_first(xml_file, "//d1:titleStmt//d1:title",
                                namespaces)
    task_name <- xml_text(task_node)

    # extract the operator (in our case this is equivalent to the titleStmt
    # name)
    operator_node <- xml_find_first(xml_file, "//d1:titleStmt//d1:name",
                                    namespaces)
    operator_name <- xml_text(operator_node)

    # extract the exam time (in our case this is equivalent to the first note in
    # the notesStmt)
    time_node <- xml_find_first(xml_file, "//d1:notesStmt//d1:note[1]",
                                namespaces)
    time_name <- xml_text(time_node)

    # extract the number of tasks (in our case this is equivalent to the second
    # note in the notesStmt)
    task_number_node <- xml_find_first (xml_file, "//d1:notesStmt//d1:note[2]",
                                        namespaces)
    task_number_name <- xml_text(task_number_node)

    # extract the genre
    genre_node <- xml_find_first(xml_file, "//d1:notesStmt//d1:note/@genre", namespaces)
    genre_name <- xml_text(genre_node)

    # extract the genre family
    genre_family_node <- xml_find_first (xml_file, "//d1:notesStmt//d1:note/@genre_family",
                                        namespaces)
    genre_family_name <- xml_text(genre_family_node)

    # create the data frame containing the information
    output_df <- rbind(output_df, data.frame(ID = student_name,
                                             SCHOOL = school_name,
                                             GRADE = grade_name,
                                             COURSE = course_name,
                                             TASK = task_name,
                                             OPERATOR = operator_name,
                                             GENRE = genre_name,
                                             GENRE_FAMILY = genre_family_name,
                                             TIME = time_name,
                                             TASK.NO = task_number_name))
  }

  output_df <- output_df %>%
    mutate_at(vars(TIME, TASK.NO), ~ str_extract(., '(?<=")([^"]*)(?=")'))


  return(output_df)

}


#' This function categorizes the operators into 14 operators and renames the
#' original categories as a list of 25. The curricular task (T.CURR) categories
#' are added to the data frame.
#'
#' @param written_meta The data frame containing the meta data on the student
#' texts

group_operators <- function(meta) {

  meta <- meta %>%
    dplyr::mutate(T.CURR = case_when(
      .$OPERATOR %in% "analyze" ~ "analysis",
      .$OPERATOR %in% "assess" ~ "argumentative",
      .$OPERATOR %in% "blog" ~ "mediation",
      .$OPERATOR %in% "characterize" ~ "analysis",
      .$OPERATOR %in% "comment" ~ "argumentative",
      .$OPERATOR %in% "describe" ~ "int.reading",
      .$OPERATOR %in% "dialogue" ~ "creative",
      .$OPERATOR %in% "diary" ~ "creative",
      .$OPERATOR %in% "discuss" ~ "argumentative",
      (.$OPERATOR %in% "e-mail_informal" & .$COURSE %in% "a11gk4" &
         .$TASK %in% "t3") ~ "argumentative",
      (.$OPERATOR %in% "e-mail_informal" & .$COURSE %in% "a11gk4" &
         .$TASK %in% "t4") ~ "mediation",
      (.$OPERATOR %in% "e-mail_informal" & .$COURSE %in% "c10gk4") ~
        "argumentative",
      .$OPERATOR %in% "e-mail_informal" ~ "mediation",
      .$OPERATOR %in% "explain" ~ "int.reading",
      .$OPERATOR %in% "letter_formal" ~ "argumentative",
      (.$OPERATOR %in% "letter_informal" & .$COURSE %in% "c12lk1") ~
        "argumentative",
      (.$OPERATOR %in% "letter_informal" & .$COURSE %in% "a10gk6") ~
        "mediation",
      .$OPERATOR %in% "magazine" ~ "mediation",
      # .$OPERATOR %in% "monologue" ~ "mediation",
      .$OPERATOR %in% "interior_monologue" ~ "creative",
      .$OPERATOR %in% "blog" ~ "creative",
      .$OPERATOR %in% "news" ~ "mediation",
      .$OPERATOR %in% "outline" ~ "int.reading",
      .$OPERATOR %in% "paraphrase_sonnet" ~ "int.reading",
      .$OPERATOR %in% "point_out" ~ "int.reading",
      .$OPERATOR %in% "present" ~ "int.reading",
      .$OPERATOR %in% "report" ~ "mediation",
      .$OPERATOR %in% "soliloquy" ~ "creative",
      (.$OPERATOR %in% "speech" & .$COURSE %in% "c10gk3") ~ "creative",
      .$OPERATOR %in% "speech" ~ "argumentative",
      .$OPERATOR %in% "story" ~ "creative",
      .$OPERATOR %in% "summarize" ~ "int.reading",
      .$OPERATOR %in% "sum_up" ~ "int.reading"
    )) %>%
    dplyr::mutate(OPERATOR.14 = dplyr::recode(.$OPERATOR,
                                       "outline" = 'summarize',
                                       "point_out" = 'summarize',
                                       "present" = 'summarize',
                                       # "report" = 'summarize',
                                       "discuss" = 'comment',
                                       "assess" = 'comment',
                                       "explain" = 'analyze',
                                       "news" = 'magazine',
                                       "letter_informal" = 'e-mail_informal',
                                       "sum_up" = "summarize",
                                       # "blog" = 'diary',
                                       "soliloquy" = 'interior_monologue')) %>%
    dplyr::rename(OPERATOR.25 = OPERATOR) %>%
    dplyr::relocate(T.CURR, .after = TASK) %>%
    dplyr::relocate(OPERATOR.14, .after = T.CURR) %>%
    dplyr::relocate(OPERATOR.25, .after = OPERATOR.14)
    # dplyr::relocate(TASK.NO, .after = OPERATOR.25)

}

#' This function separates the combined filename for the single texts created
#' in "collapse.R" in "code". It then uses the function randomize_id() to
#' create the same random IDs.
#'
#' @param feature_data The data frame containing the features created by the
#' feature extraction CQP script used in Evert & Neumann (2021).

anonymize_collapsed_id <- function(feature_data, id_column) {

  regex1 <- "(?=_.*)"
  regex2 <- "\\."

  feature_data <- feature_data %>%
    separate_wider_delim(cols = id_column, delim = stringr::regex(regex1),
                         names = c("SOURCE", "rest")) %>%
    separate_wider_delim(cols = rest, delim = stringr::regex(regex2),
                         names = c("CODE", "TASK")) %>%
    mutate_at(vars(CODE), ~str_remove(., "_")) %>%
    separate_wider_position(cols = SOURCE, widths = c(SCHOOL = 3, GRADE = 2,
                                                      COURSE = 3))

  feature_data <- anonymize_id(meta = feature_data, school = "SCHOOL",
                               grade = "GRADE", course = "COURSE",
                               task = "TASK")

  feature_data <- feature_data %>%
    dplyr::select(-c(SCHOOL, GRADE, COURSE, TASK)) %>%
    dplyr::rename(id = ID)

}
