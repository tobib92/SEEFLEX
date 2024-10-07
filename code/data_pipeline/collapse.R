library(xml2)
library(stringr)
library(tidyverse)

current_working_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(current_working_dir)

source("xml_utils.R")


#' !!! Only run the lines below once !!!
#'
#' For CQP, nested <s> tags need to be renamed because nesting is not supported.
#' The following lines create a new directory "anon_cqp" in the "data" folder
#' and renames all nested <s> tags to <qs> (quoted sentence) as nesting only
#' occurs inside <quote> tags.

# rename_nodes(input_directory = "../../data/anon/",
#              output_directory = "../../data/anon_cqp/", node_old = "s//d1:s",
#              node_new = "qs", type = "node")


#' Clean the strings from unnecessary spaces, tabs and linebreaks.
#'
#' @param my_string A string that captures the written content of an xml file

clean_string <- function(my_string) {

  # remove all new lines \n and tabs \t from the text.
  cleaned_string <- str_remove_all(my_string, "\r|\b|\t")
  # add a line break after each closing tag </text>
  cleaned_string2 <- str_replace_all(cleaned_string, "</text>", "</text>\n")
  # remove the space in between the opening and closing <text> tag
  cleaned_string3 <- str_replace_all(cleaned_string2, " <text id", "<text id")
  # trim and squish the character string to remove surplus white spaces
  cleaned_string4 <- str_trim(cleaned_string3, side = "both")
  cleaned_string5 <- str_squish(cleaned_string4)
  # removes self-closing tags in the final file
  cleaned_string6 <- str_remove_all(cleaned_string5, "<[^<>]*\\/>")
  cleaned_string7 <- str_replace_all(cleaned_string6, "</text> <text id=",
                                     "</text><text id=")
  text_tag <- "</text>"
  # adds a line break because CQP does not allow the closing and opening
  # <text> tag to be in the same line
  cleaned_string8 <- str_replace_all(cleaned_string7,
                                     paste0("(", text_tag, ")"), "\\1\n")
  # changes the attribute name (TEI Guidelines standard) because CQP does not
  # accept colons ":" in the attribute
  cleaned_string9 <- str_replace_all(cleaned_string8, "xml:lang", "xml_lang")

  return(cleaned_string9) # return the cleaned string
}


#' Concatenate all files in a directory and optionally write the result to
#' a file
#'
#' @param directory A string representing the path to the directory.
#' @param pattern A string representing the unix pattern to match.
#' @param output_file A string representing the path to the output file.
#'                    If this parameter is NULL, the function will print
#'                    the result to the console.
#' @return A single string that contains the content of all the parsed files.

concatenate_all_files <- function(directory, pattern = "*.xml", output_file = NULL) {


  # Get a list of all files in the given directory that match the pattern and
  # create a list to hold all of our parsed strings
  all_files <- as.list(list.files(path = directory,
                          pattern = pattern,
                          recursive = TRUE))

  # For each file in the all_files list run extract_text_from_xml_file,
  # store the resulting string and add the string to the list we created

  all_strings <- list()

  for (file in all_files) {

    my_string <- extract_text_from_xml_file(directory, file)
    all_strings <- append(all_strings, my_string)

  }

  # Concatenate all of our strings together
  final_string <- paste(unlist(all_strings), collapse = " ")

  # Clean the final string
  output_string <- clean_string(final_string)

  # If output_file is null, just print it to the console.
  if (is.null(output_file)) {
    print(output_string)
  } else {
    writeLines(output_string, output_file)
  }

  print("The corpus file has been created.")
}

################################################################################
######## Run the lines below to save the entire corpus as one .txt file ########
################################################################################

concatenate_all_files(
  directory = "../../data/anon_cqp/",
  output_file = "../../output/collapse/20240831_SEEFLEX.txt")
