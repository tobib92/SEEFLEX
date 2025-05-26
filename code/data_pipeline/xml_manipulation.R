#### Set working directory to the SEEFLEX root folder ####

source("xml_utils.R")


##### Run the lines below to count the nested <s> tags in the directory #####

output <- count_nested_s_tags(input_directory = "data/anon/")

# output[intersect(names(output1),
#                   names(output2))] == output2[intersect(names(output1),
#                                                         names(output2))]
# output2[intersect(names(output2),
#                   names(output1))] == output1[intersect(names(output2),
#                                                         names(output1))]
#
# names_long <- names(output1)
# names_short <- names(output)
# setdiff(names_long, names_short)


##### Run the lines below to rename xml elements in all files in a directory #####

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

### INSERT YOUR PARAMETERS HERE ###
rename_xml_files_in_directory(input_directory = "",
                              output_directory = "")


##### Run the lines below to replace xml nodes in all files in a directory #####

replace_xml_files_in_directory <-  function(input_directory,
                                             output_directory) {

  all_filenames <- gather_files(input_directory = input_directory,
                                output_directory = output_directory)

  for (file in all_filenames) {

    # Parse the file
    parsed_file <- parse_file(directory = input_directory,
                              filename = file)
    xml_file <- parsed_file$xml_file
    namespaces <- parsed_file$namespaces

    ### INSERT YOUR PARAMETERS HERE ###
    replace_xml_content(
      xml_nodes = xml_file, namespaces = namespaces,
      node = "", # The name of the attribute (do not add xPath language!)
      attr = "", # The name of the attribute (do not add xPath language!)
      type = "", # The type of object: either "node" or "attribute"
      extent = "", # The extent of the replacement: either "all" or "part"
      content = "", # The content to be replaced in the node/attribute
      regex = "", # A character string or regex pattern that captures the old
      # content that is to be kept in the replaced node/attribute
      direction = "" # The paste direction for content and regex: "cr" or "rc"
      )

    # Create an output file for each file
    output_file <- create_output_path(filepath = file,
                                      output_directory = output_directory)

    # Write new file to the output file path
    write_xml(xml_file, file = output_file)

    print(paste("Replaced xml content accordingly in file", output_file))

  }

  print("All content was replaced in the corpus files.")

}

### INSERT YOUR PARAMETERS HERE ###
replace_xml_files_in_directory(input_directory = "",
                               output_directory = "")
