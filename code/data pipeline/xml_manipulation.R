current_working_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(current_working_dir)

source("xml_utils.R")


################################################################################
###### Run the lines below to count the nested <s> tags in the directory #######
################################################################################

output <- count_nested_s_tags(input_directory = "../../data/anon/")

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


################################################################################
#### Run the lines below to rename xml elements in all files in a directory ####
################################################################################

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
                       node_old = "####",
                       node_new = "####",
                       type = "",
                       attr_old = "####",
                       attr_new = "####")

    # create an output file
    output_file <- create_output_path(filepath = file,
                                      output_directory = output_directory)

    # Write new file to output file path
    write_xml(xml_nodes, file = output_file)

  }
}

### INSERT YOUR PARAMETERS HERE ###
rename_xml_files_in_directory(input_directory = "",
                              output_directory = "")


################################################################################
### Run the lines below to replace xml elements in all files in a directory ####
################################################################################

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
    replace_xml_content(xml_nodes = xml_file, namespaces = namespaces,
                        node = "",
                        attr = "",
                        type = "",
                        extent = "",
                        content = "",
                        regex = "",
                        direction = "")

    # Create an output file for each file
    output_file <- create_output_path(filepath = file,
                                      output_directory = output_directory)

    # Write new file to the output file path
    write_xml(xml_file, file = output_file)

  }

  print("All content was replaced in the corpus files.")

}

### INSERT YOUR PARAMETERS HERE ###
replace_xml_files_in_directory(input_directory = "",
                               output_directory = "")
