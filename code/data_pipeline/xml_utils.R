library(yaml)
library(R6)
library(xml2)
library(log4r)
library(testthat)
library(stringr)
library(tidyverse)
library(readr)


#' This function extracts the text node from an XML document, creates an ID for
#' the node using the create_id() function, and adds the ID as an attribute to
#' the node.
#'
#' @param xml_file An XML document read into R using the read_xml() function.
#' @param namespaces A named character vector of XML namespaces in the document.
#' @return A character string representing the text node

get_text <- function(xml_file, namespaces) {

  # find the first instance of the <text> node.
  text_node <- xml_find_first(xml_file, "//d1:text", namespaces)

  # create an id using the create_id() function
  id <- xml_text(xml_find_first(xml_file, "//d1:author", namespaces))
  # id <- create_id(xml_file, namespaces)

  # set the attribute of the text_node to "id" and the individual text id
  xml_set_attr(text_node, "id", id)

  # extract everything contained in the text_node as a string
  full_text <- as.character(text_node)

  return(full_text)
}


#' This function reads an XML file into R, extracts the namespaces from the
#' document, and then extracts the text node using the get_text() function.
#'
#' @param filename A string representing the path to the XML file.
#' @return A character string representing the text node from the XML document.

extract_text_from_xml_file <- function(directory, filename) {

  parsed_file <- parse_file(directory, filename)

  text <- get_text(parsed_file$xml_file, parsed_file$namespaces)

  return(text)
}


#' This function takes a directory and a filename and parses the XML file.
#'
#' @param directory The directory where the file is located.
#' @param filename The name of the file to parse.
#' @return A list containing the XML file and the namespaces.

parse_file <- function(directory, filename) {
  # Create a full path to the file from the directory and filename
  if (file.exists(filename)) {
    full_path <- filename
  } else {
    full_path <- paste0(directory, filename)
  }

  print(paste("parsing file", full_path)) # Print the full path to see the progress.

  if (!file.exists(full_path)) {
    msg <- paste("unable to locate file", full_path)
    # error(logger, msg)
    stop(msg)
  }

  # info(logger, paste("Parsing file:", full_path))

  # Parse the XML file and get the namespaces
  xml_file <- read_xml(full_path)
  namespaces <- xml_ns(xml_file)

  # Return an object that contains the XML file and the namespaces
  return(list(xml_file = xml_file, namespaces = namespaces))
}


#' This function provides the files to be altered and creates the output
#' directory for the new files.
#'
#' @param input_directory A directory that contains the files.
#' @param pattern A pattern of file types that are searched for.
#' @param output_directory A directory where the new files are saved.

gather_files <- function(input_directory, pattern = "*.xml",
                         output_directory = NULL) {

  # Get a list of all files in "directory"
  all_filenames <- list.files(path = input_directory,
                              pattern = pattern,
                              full.names = TRUE,
                              recursive = TRUE)

  # Assign an output path from the output directory if it doesn't already exist.

  if (!is.null(output_directory)) {
    if (!dir.exists(output_directory)) {
      dir.create(output_directory)
      print(paste("Directory created:", output_directory))
    } else {
      print(paste("Directory already exists:", output_directory))
    }
  } else {
    NULL
  }

  return(all_filenames)

}


#' This function picks and parses one random file from an input directory for
#' testing.
#'
#' @param input_directory A directory that contains the XML files

pick_and_parse_random_file <- function(input_directory = "../../data/anon/") {

  all_filenames <- gather_files(input_directory = input_directory)

  # Select one random file from the list
  random_file <- sample(all_filenames, 1)

  #Read in the file as an XML object
  parsed_file <- parse_file(directory = input_directory,
                            filename = random_file)

  return(parsed_file)
}


#' This function creates an output filepath from an input directory.
#'
#' @param filepath The output path of the file passed to the variable
#' @param output_directory The output directory for the output files
#' @param create_dir Should the output directory be created if necessary?
#' @param output_file_name String to be used as output file name
#' @param output_folder_name String to be used as output folder name

create_output_path <- function(filepath, output_directory, create_dir = TRUE,
                               output_file_name = NULL,
                               output_folder_name = NULL) {

  # Save the part of the original file path we need
  original_filepath <- dirname(filepath)

  # Remove everything but the folder name from the path
  if (is.null(output_folder_name)) {
    original_dirname <- str_remove(original_filepath, ".*\\/")
  } else {
    original_dirname <- output_folder_name
  }

  # Paste the output directory and the original folder name together.
  if (str_sub(output_directory, -1) != "/") {
    output_directory <- paste0(output_directory, "/")
  }

  output_path <- paste0(output_directory, original_dirname)

  # Create this directory if it doesn't already exist.
  if (!dir.exists(output_path) & create_dir) {
    dir.create(output_path)
  }

  # Create an output file name from the original file name
  if (is.null(output_file_name)) {
    output_filename <- basename(filepath)
  } else {
    output_filename <- output_file_name
  }

  # Create an output file path with the output directory, the original file
  # path and the output file name
  output_file <- paste0(output_path, "/", output_filename)

  return(output_file)
}


#' This function adds an extra space after each sentence opening tag to appear
#' when the files are parsed and prepared for NLP tool usage.
#'
#' @param xml_nodes A parsed xml object
#' @param tags The xml tags after which the space should be added.

add_spaces <- function(xml_nodes, tags = c("s", "l")) {
  # Internal function to add a space to the last text node
  add_space_to_last_text_node <- function(node) {
    # Find all text nodes within the element
    text_nodes <- xml_find_all(node, ".//text()")

    # If the node element is not empty
    if (length(text_nodes) > 0) {
      last_text_node <- text_nodes[length(text_nodes)]
      text_content <- xml_text(last_text_node)

      # If the text_content string does not end with a space,
      if (!grepl(" $", text_content)) {
        # add a space after the text_content
        xml_text(last_text_node) <- paste0(text_content, " ")
      }
    }
  }

  # Extract namespaces and prepare queries
  namespaces <- xml_ns(xml_nodes)
  ns_prefix <- ""
  if (length(namespaces) > 0) {
    ns_prefix <- sprintf(
      "%s:", names(namespaces)[which(names(namespaces) != "xml")][1]
    )
  }

  for (tag in tags) {
    # Adjust  query to include namespace prefix and current tag
    xpath_query <- sprintf(".//%s%s", ns_prefix, tag)

    # Apply the function to all elements of the current tag
    nodes <- xml_find_all(xml_nodes, xpath_query)
    lapply(nodes, add_space_to_last_text_node)
  }

  return(xml_nodes)
}


#' This function iterates through a directory of .xml-files and, by default,
#' finds all nodes of the old pattern and replaces them with the new pattern.
#' Attributes within nodes can be renamed by setting the type and providing the
#' additional arguments.
#'
#' @param xml_file An XML document read into R using the read_xml() function.
#' @param namespaces A named character vector of XML namespaces in the document.
#' @param node_old The name of the old node (do not add xPath language except
#' for nested nodes (e.g. "s//d1:s" for "//d1:s//d1:s"!)
#' @param node_new The name of the new node (do not add xPath language!)
#' @param attr_old The name of the old attribute (do not add xPath language!)
#' @param attr_new The name of the new attribute (do not add xPath language!)
#' @param type The type of object: either "node" or "attribute"

rename_xml_content <- function(xml_nodes, namespaces, node_old,
                               node_new = NULL, type = "node", attr_old = NULL,
                               attr_new = NULL) {

    # Save all nodes of the old pattern from the XML file
    if (type == "node") {
      # Convert the old pattern to the correct format
      pattern_node_old <- paste0("//d1:", node_old)
      nodes_to_rename <- xml_find_all(xml_nodes, pattern_node_old, namespaces)
    } else if (type == "attribute") {
      # Convert the old pattern to the correct format
      pattern_attr_old <- paste0("//d1:", node_old, "[@", attr_old, "]")
      nodes_to_rename <- xml_find_all(xml_nodes, pattern_attr_old, namespaces)
    } else {
      print("File ignored. Nodes or attributes not in file.")
    }

    # Apply the new pattern to the element nodes_to_remove
    if (type == "node" & !is.null(nodes_to_rename)) {
      xml_name(nodes_to_rename) <- node_new
    } else if (type == "attribute" & !is.null(nodes_to_rename)) {
    attr_to_remove <- xml_attr(nodes_to_rename, attr_old)
    xml_attr(nodes_to_rename, attr_old) <- NULL
    xml_attr(nodes_to_rename, attr_new) <- attr_to_remove
    } else {
      print("File ignored. Nodes or attributes not in file.")
    }

    print(paste("Renaming XML nodes", node_old, "to", node_new))

}


#' This function replaces the content in either a node or an attribute of a node
#'
#' @param xml_file An XML document read into R using the read_xml() function.
#' @param namespaces A named character vector of XML namespaces in the document.
#' @param node The name of the node (do not add xPath language!)
#' @param attr The name of the attribute (do not add xPath language!)
#' @param type The type of object: either "node" or "attribute"
#' @param extent The extent of the replacement: either "all" or "part"
#' @param content The content to be replaced in the node/attribute
#' @param regex A character string or regex pattern that captures the old
#' content that is to be kept in the replaced node/attribute
#' @param direction The paste direction for content and regex: "cr" or "rc"

replace_xml_content <- function(xml_nodes, namespaces, node,
                                 attr = NULL, content, type = "node",
                                 extent = "all", regex = NULL,
                                 direction = NULL) {

  # Save all nodes of the old pattern from the XML file
  if (type == "node") {
    pattern <- paste0("//d1:", node)
    nodes_to_replace <- xml_find_all(xml_nodes, pattern, namespaces)
  } else if (type == "attribute") {
    pattern <- paste0("//d1:", node, "[@", attr, "]")
    nodes_to_replace <- xml_find_all(xml_nodes, pattern, namespaces)
  } else {
    print("File ignored. Nodes or attributes not in file.")
  }

  # Apply the new pattern to the element nodes_to_remove
  if (extent == "all" & type == "node" & !is.null(nodes_to_replace)) {

    # paste the content into the xml node
    xml_text(nodes_to_replace) <- content

  } else if (extent == "all" & type == "attribute" & !is.null(nodes_to_replace)) {

    # paste the content into the xml attribute
    xml_attr(nodes_to_replace, attr) <- content

  } else if (extent == "part" & type == "node" & !is.null(nodes_to_replace)) {

    # Extract the old content from the xml node
    content_old <- xml_text(nodes_to_replace)
    # Extract the part we want to keep
    part_to_keep <- str_extract(content_old, regex)

    # Select the correct pasting direction
    if (direction == "cr") {
      content_new <- paste0(content, part_to_keep)
    } else if (direction == "rc") {
      content_new <- paste0(part_to_keep, content)
    } else {
      print("invalid direction")
    }

    # paste the new content into the xml node
    xml_text(nodes_to_replace) <- content_new

  } else if (extent == "part" & type == "attribute" & !is.null(nodes_to_replace)) {

    # Extract the old content from the xml attribute
    content_old <- xml_attr(nodes_to_replace, attr)
    # Extract the part we want to keep
    part_to_keep <- str_extract(content_old, regex)

    # Select the correct pasting direction
    if (direction == "cr") {
      content_new <- paste0(content, part_to_keep)
    } else if (direction == "rc") {
      content_new <- paste0(part_to_keep, content)
    } else {
      print("invalid direction")
    }

    # paste the new content into the xml attribute
    xml_attr(nodes_to_replace, attr) <- content_new

  } else {
    print("File ignored. Nodes or attributes not in file.")
  }

  print(paste0("Replacing content in: ", "'", ifelse(type == "node",
                                                     node, attr),
               "' ", "with '", content))

}


#' This function counts the nested s tags in the corpus
#'
#' @param input_directory A directory that contains the XML files.

count_nested_s_tags <- function(input_directory) {

  # Get a list of all files in "directory"
  all_filenames <- gather_files(input_directory)

  # Initialize a vector to hold our results
  my_vector <- c()

  # For each file we found
  for (file in all_filenames) {

    # Read in the file as an XML node object and get the namespaces
    parsed_file <- parse_file(directory = input_directory, filename = file)
    xml_node <- parsed_file$xml_file
    namespaces <- parsed_file$namespaces

    # Create a list of all embedded "s" tags in the current file looking at any
    # <s> nodes than are embedded anywhere within another <s> node
    s_tags <- as.list(xml_find_all(xml_node, "//d1:s//d1:s", namespaces))

    # If the length of the element is greater than zero, append the filename and
    # the count to it
    if (length(s_tags) > 0) {
      my_vector[file] <- length(s_tags)
    }
  }

  # Return our results
  return(my_vector)
}


#' This function searches for xml nodes within other xml nodes.
#'
#' @param xml_file The xml_file to be searched
#' @return An xml2 node object

check_nodes_without_s <- function(xml_file) {
  # Read the XML file
  xml_doc <- read_xml(xml_file)

  # Find all nodes in the document
  all_nodes <- xml_find_all(xml_doc, "//u")
  # print(all_nodes)

  # Initialize a list to store nodes without <s> children
  nodes_without_s <- list()

  # Iterate through each node
  for (node in all_nodes) {
    # Check if the node has children and if those children are not <s>
    if (length(xml_find_all(node, ".//s")) == 0) {

      node_text <- xml_text(node)
      nodes_without_s <- append(nodes_without_s, node_text)
    }
  }

  return(nodes_without_s)
}


#' This function creates a data frame from the information gained from two nodes
#' in an .xml document.
#'
#' @param input_directory The directory containing the xml files
#' @param node1 The xPath to the first node
#' @param node2 The xPath to the second node

write_info_from_xml_to_df <- function(input_directory,
                                      node1 = "//d1:sourceStmt//d1:p",
                                      node2 = "//d1:publicationStmt//d1:date") {

  all_filenames <- gather_files(input_directory = input_directory)

  df <- data.frame(Course = character(), Date = character())

  for (file in all_filenames) {

    # Read in the file as an XML object
    parsed_file <- parse_file(directory = input_directory,
                              filename = file)

    xml_file <- parsed_file$xml_file
    namespaces <- parsed_file$namespaces

    course_node <- xml_find_first(xml_file, node1, namespaces)
    course_text <- xml_text(course_node)
    date_node <- xml_find_first(xml_file, node2, namespaces)
    date_text <- xml_text(date_node)

    new_row <- data.frame(Course = course_text, Date = date_text)
    df <- rbind(df, new_row)

  }
  return(df)
}
