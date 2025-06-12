#### Set working directory to the SEEFLEX root folder ####

logger <- create.logger(level = "DEBUG")

source("code/data_pipeline/config_manager.R")
source("code/data_pipeline/xml_utils.R")
config_manager <- ConfigManager$new()
settings <- config_manager$final_config()


#' Alter an XML file using a given pattern to remove nodes that match the
#' pattern
#'
#' This function takes an XML file, a list of namespaces, and a pattern to
#' match nodes in the XML file.
#'
#' @param xml_file The XML file to alter.
#' @param namespaces The namespaces used in the XML file.
#' @param pattern The pattern to match nodes in the XML file.
#' @return The altered XML file.

remove_nodes <- function(xml_file, namespaces, pattern) {
  if (is.null(pattern)) {
    debug(logger, "Pattern is NULL")
    return(xml_file)
  }

  # Use the pattern to find nodes in the XML file that will be removed
  debug(logger, paste("Applying pattern:", pattern))
  nodes_to_remove <- xml_find_all(xml_file, pattern, namespaces)

  # Remove the nodes that we have identified
  xml_remove(nodes_to_remove)

  # Return the new modified XML nodes object
  return(xml_file)
}

#' Apply filters to an XML file using a loaded configuration
#'
#' This function takes an XML file, a list of namespaces, and a
#' configuration and applies filters to the XML file based on the
#' configuration.
#'
#' @param xml_file The XML file to alter.
#' @param namespaces The namespaces used in the XML file.
#' @param config_patterns The configuration settings converted to patterns.
#' @return The altered XML file, after applying the filters.

apply_filters <- function(xml_file, namespaces, config_patterns) {
  debug(logger, "Applying filters...")
  for (option in names(config_patterns)) {
    debug(logger, paste("Applying filter:", option))
    if (is.list(config_patterns[[option]])) {
      debug(logger, paste("Applying sub-filters for:", option))
      xml_file <- apply_filters(xml_file, namespaces, config_patterns[[option]])
    } else {
      debug(logger, paste("Applying pattern for:", option))
      pattern <- config_patterns[[option]]
      xml_file <- remove_nodes(xml_file, namespaces, pattern)
    }
  }

  return(xml_file)
}

#' Parse and apply filters to an XML file
#'
#' This function takes a directory, a filename, and a configuration and
#' parses the XML file and applies filters to it based on the configuration.
#'
#' @param directory The directory where the file is located.
#' @param filename The name of the file to parse.
#' @param settings The configuration settings to use.
#' @param output_format The desired output format: "txt" or "xml"
#' @return The altered XML file, after applying the filters.

parse_apply_filters_and_save_to_file <- function(input_directory,
                                                 output_directory, filename,
                                                 settings,
                                                 output_format = "txt") {

  # Parse the file and to get our xml nodes and namespaces
  parsed_file <- parse_file(directory = input_directory, filename = filename)

  # Create the id for the filename
  id <- xml_text(xml_find_first(parsed_file$xml_file, "//d1:author",
                                parsed_file$namespaces))

  # Apply filters based on the settings
  xml_file <- apply_filters(parsed_file$xml_file,
                            parsed_file$namespaces,
                            convert_config(settings))

  # Construct a filename
  if (output_format == "txt") {
    output_filename <- paste0(id, ".txt")
  } else if (output_format == "xml") {
    output_filename <- paste0(id, ".xml")
  } else {
    print("Invalid output format. Filename cannot be created.")
  }

  # Create the full output filepath
  output_filepath <- paste0(output_directory, output_filename)
  debug(logger, paste("Saving output file to", output_filepath))

  # Clean the file and add spaces
  xml_file <- add_spaces(xml_file)

  if (output_format == "txt") {
    # Extract the text from the text node inside the xml file
    output_file_content <- xml_text(xml_find_all(xml_file, "//d1:text"))

    # Save the file to the output directory
    writeLines(output_file_content, output_filepath)

  } else if (output_format == "xml") {
    write_xml(xml_file, file = output_filepath)

  } else {
    print("Invalid output format.")
  }

}

#' Convert all files in a directory using a given configuration
#'
#' This function takes a directory and a configuration and converts all the
#' files in the directory based on the configuration.
#'
#' @param directory The directory where the files are located.
#' @param output_directory The directory to save the converted files in.
#' @param settings The configuration settings to use.
#' @param pattern The pattern to match files in the directory.
#' @return A list of strings containing the converted files.

convert_all_files <- function(input_directory, output_directory, settings,
                              pattern = "*.xml") {

  # Get all the files in the directory that match the pattern
  all_filenames <- list.files(path = input_directory, pattern = pattern,
    full.names = TRUE, recursive = TRUE)

  # Assign an output path that is the output directory if it doesn't already
  # exist.
  if (!dir.exists(output_directory)) {
    dir.create(output_directory)
  }

  # Iterate over the files, parsing them based on the settings.
  for (filename in all_filenames) {
    parse_apply_filters_and_save_to_file(
      input_directory = input_directory,
      output_directory = output_directory,
      filename = filename,
      ### CHANGE OUTPUT FORMAT IF DESIRED! ###
      output_format = "txt",
      settings = settings
    )
  }
  print(paste("The corpus files have been exported to", output_directory))
}

##### Run the lines below to save the texts as separate .txt files #####

corpus_version <- "orig" # Change this string if needed
output_filepath <- paste0("output/", format(Sys.Date(), "%Y%m%d"),
                          "_seeflex_", corpus_version, "/")

convert_all_files(
  input_directory = "data/anon/",
  output_directory = output_filepath,
  settings = settings
)
