#### Set working directory to the SEEFLEX root folder ####

source("code/data_pipeline/xml_utils.R")

vars <- load("data/gma/shiny_data.rda")
input_directory <- "data/anon/"

all_file_paths <- gather_files(input_directory)
