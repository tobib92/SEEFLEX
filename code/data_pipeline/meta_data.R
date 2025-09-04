#### Set working directory to the SEEFLEX root folder ####

library(xlsx)

source("code/data_pipeline/meta_utils.R")
source("code/data_pipeline/xml_utils.R")

# Create a list of the meta data on each individual text
WD <- gather_text_info(directory = "data/anon/")

# Include information on the curricular task and create different groups of
# the operators.

WD <- group_operators(meta = WD)

# Read the raw meta data table
MD <- read_delim("data/metadata_anon.csv", delim = ",")

# Calculate the scores for the English LexTALE
MD <- calculate_lextale(meta = MD, words = "LexTALE.eng.w",
                        nonwords = "LexTALE.eng.nw", score = "LexTALE.ENG")

# Calculate the scores for the German LexTALE
MD <- calculate_lextale(meta = MD, words = "LexTALE.ger.w",
                        nonwords = "LexTALE.ger.nw", score = "LexTALE.GER")

# Calculate the scores for the (New) Vocabulary Levels Test
MD <-  calculate_vlt(meta = MD, pattern = ".{0,1}VLT.+")

# Normalize the language experience scores
MD <- normalize_sum_scores(meta = MD, pattern = "EXP[1-5]",
                           sum_column = "SUM.EXP")

# Normalize the language experience scores
MD <- normalize_sum_scores(meta = MD, pattern = "EXPO\\.[A-Z]+",
                           sum_column = "SUM.EXPO")

# Calculate the score for the Need for Cognition Scale
MD <- calculate_nfc(meta = MD, pattern = "PERS[1-9]{1,2}")


##### Write the data to a file #####

# write.xlsx(x = MD, file = "data/meta_data_output.xlsx")
# write.csv(x = MD, file = "data/meta_data_output.csv")
