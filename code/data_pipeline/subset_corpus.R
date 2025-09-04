#### Set working directory to the SEEFLEX root folder ####

library(fs)

source("code/data_pipeline/xml_utils.R")
source("code/data_pipeline/meta_utils.R")
source("code/data_pipeline/meta_data.R")


# This script provides functions to subset SEEFLEX according to the WD data
# frame in meta_data.R file.


#' This function creates a complete copy of the corpus files.
#'
#' @param input_directory The path to the corpus files
#' @param output_directory The path to the output directory

copy_corpus_files <- function(input_directory, output_directory) {

  # Check if the input directory exists
  if (!fs::dir_exists(input_directory)) {
    stop("The input directory does not exist.")
  }

  # Create output directory if it doesn't exist
  if (!fs::dir_exists(output_directory)) {
    fs::dir_create(output_directory)
  }

  # Copy all files and subdirectories from input to output directory
  fs::dir_copy(input_directory, output_directory, overwrite = TRUE)

  print(paste0("Files copied successfully from ", input_directory, " to ",
        output_directory))
}


#' This function filters the WD data frame according to up to three filter
#' variables
#'
#' @param df Coded to WD by default
#' @param id_column If used, the function will filter all values in
#' filter_values1, but only if the IDs feature all of the values.
#' @param filter_column_1 The first filter column in the data frame.
#' @param filter_value_1 The first filter value in the data frame.
#' @param filter_column_2 The second filter column in the data frame.
#' @param filter_value_2 The second filter value in the data frame.
#' @param filter_column_3 The third filter column in the data frame.
#' @param filter_value_3 The third filter value in the data frame.

filter_df <- function(df = WD, id_column = NULL, filter_column_1, filter_values_1,
                        filter_column_2 = NULL, filter_values_2 = NULL,
                        filter_column_3 = NULL, filter_values_3 = NULL) {

  # Apply the first filter not depending on an ID
  if (is.null(id_column)) {
    filtered_df <- df %>%
      dplyr::filter(!!sym(filter_column_1) %in% filter_values_1)
    print("First filter applied to all entries")
  # Apply the first filter depending on an ID
  } else {
    print(paste0("The ID column is ", id_column))
    filtered_df <- df %>%
      dplyr::mutate(temporary_ID = !!sym(id_column)) %>%
      dplyr::mutate(temporary_ID = str_remove(temporary_ID, "_.*")) %>%
      dplyr::filter(!!sym(filter_column_1) %in% filter_values_1) %>%
      dplyr::group_by(temporary_ID) %>%
      dplyr::filter(n() == length(filter_values_1)) %>%
      dplyr::ungroup() %>%
      dplyr::select(-temporary_ID)
    print("First filter applied to all entries depending on the ID")
  }

  # Apply the first optional filter if provided
  if (is.null(id_column) & !is.null(filter_column_2)) {
    filtered_df <- filtered_df %>%
    dplyr::filter(!!sym(filter_column_2) %in% filter_values_2)
    print("The second filter was applied.")
  # Apply the second optional filter if provided
  } else if (is.null(id_column) & !is.null(filter_column_3)) {
    filtered_df <- filtered_df %>%
    dplyr::filter(!!sym(filter_column_3) %in% filter_values_3)
    print("The third filter was applied.")
  # Do nothing if the optional filters are not provided
  } else {
    NULL
  }

  return(filtered_df)
}


#' This funtion takes a data frame and only contains the rows with a match in
#' the filtered data frame based on the values in an id_column
#'
#' @param df The original data frame
#' @param filtered_df The filtered data frame
#' @param id_column The column to match the values

apply_filter_to_df <- function(df, filtered_df, id_column) {

  filtered_df <- dplyr::inner_join(df, filtered_df, by = id_column)

  # define columns to be deleted after the join
  columns_to_deselect <- c("SCHOOL", "GRADE", "COURSE", "TASK", "T.CURR",
                           "OPERATOR.14", "OPERATOR.25", "GENRE",
                           "GENRE_FAMILY", "TIME", "TASK.NO")

  final_df <- dplyr::select(-columns_to_deselect)

  return(final_df)
}


#' This function deletes the files not contained in the df in the
#' input_directory.
#'
#' @param data_directory The directory in which the corpus files will be deleted
#' @param df The derivative of the WD data frame that was filtered according
#' to preferences
#' @param id_column_name The column name for the file ID

delete_unlisted_xml_files <- function(data_directory, df, id_column_name) {

  # Get the list of XML files in the directory and its subdirectories
  xml_files <- gather_files(input_directory = data_directory)

  # Extract the filenames (without path) from the dataframe column
  allowed_filenames <- df[[id_column_name]]

  # Loop through each XML file
  for (file in xml_files) {
    # Get the filename without path
    file_name <- basename(file)
    cleaned_file_name <- str_remove(file_name, ".xml")


    # Check if the file name is not in the allowed files
    if (!(cleaned_file_name %in% allowed_filenames)) {
      # Delete the file
      file.remove(file)
      print(paste("Deleted:", file))
    }
  }

  # Remove empty directories after deletion of files
  all_corpus_directories <- list.dirs(data_directory, recursive = TRUE)

  # Reverse to ensure inner directories are checked first
  for (dir in rev(all_corpus_directories)) {
    if (length(list.files(dir)) == 0) {
      unlink(dir, recursive = TRUE)
      # print(dir)
      print(paste("Deleted empty directory:", dir))
    }
  }
}


##### Copy the corpus data to an output directory. #####

current_date <- format(Sys.Date(), "%Y%m%d")
output_filepath <- paste0("output/", current_date, "_filtered/")

copy_corpus_files(input_directory = "data/anon/",
                  output_directory = output_filepath)


##### Filter data frame according to the columns and values specified. #####

# Filter_values <- c("value1", "value1", "value1", "value1")
filter_values <- c("summarize", "comment", "analyze", "informal_e-mail",
                   "formal_letter", "blog", "magazine", "report")
WD_filtered <- filter_df(filter_column_1 = "OPERATOR.17",
                         filter_values_1 = filter_values)

# Recode variables
seeflex_meta <- seeflex_meta %>%
  dplyr::mutate(OPERATOR.17 = dplyr::recode(.$OPERATOR.17,
                                          "magazine" = 'blog',
                                          "report" = 'blog'))


##### Delete all corpus files not contained in the filtered data frame. #####

delete_unlisted_xml_files(data_directory = "output/20250703_filtered/",
                          df = WD_filtered, id_column_name = "ID")
