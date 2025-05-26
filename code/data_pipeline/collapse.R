#### Set working directory to the SEEFLEX root folder ####

source("xml_utils.R")


#' !!! Only run the lines below once !!!
#'
#' For CQP, nested <s> tags need to be renamed because nesting is not supported.
#' The following lines create a new directory "anon_cqp" in the "data" folder
#' and rename all nested <s> tags to <qs> (quoted sentence) as nesting only
#' occurs inside <quote> tags.
#'
#' The function rename_xml_files_in_directory() in xml_manipulation.R needs to
#' be called and adjusted before running the lines below.
#'

rename_xml_files_in_directory <- function(input_directory, output_directory) {

# Get the files and create the output directory
all_filenames <- gather_files(input_directory = input_directory,
                              output_directory = output_directory)

for (file in all_filenames) {

  # parse the file
  parsed_file <- parse_file(directory = input_directory, filename = file)
  xml_nodes <- parsed_file$xml_file
  namespaces <- parsed_file$namespaces


  ### INSERT YOUR PARAMETERS HERE ###
  rename_xml_content(xml_nodes = xml_nodes, namespaces = namespaces,
                     node_old = "s//d1:s",
                     node_new = "qs",
                     type = "node",
                     attr_old = NULL,
                     attr_new = NULL
  )

  # create an output file
  output_file <- create_output_path(filepath = file,
                                    output_directory = output_directory)

  # Write new file to output file path
  write_xml(xml_nodes, file = output_file)

}

print("All nodes were renamed in the corpus files.")

}

rename_xml_files_in_directory(input_directory = "output/20250409_seeflex_orig/",
                              output_directory = "output/20250409_seeflex_orig")


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

##### Run the lines below to save the entire corpus as one .txt file #####

corpus_version <- "orig" # Change this string if needed
output_filename <- paste0("output/collapse/", format(Sys.Date(), "%Y%m%d"),
                          "_seeflex_", corpus_version, ".txt")

concatenate_all_files(
  directory = "output/20250409_seeflex_orig/",
  output_file = output_filename)
