library(stringr)

#' This function formats a plain text file with one (set of) word(s) per line
#' into a CQP macro that can be used to query for multiword sequences.
#'
#' @param input_file The input file (CQP wordlist with multiword sequences)
#' @param macro_name The name assigned to the macro
#' @details The words are formatted depending on certain operators. The function
#' supports the boolean operator "?" for entire words, the boolean operator for
#' parts of a word "(.*)?", a negation before a word "!", and plain words.

format_string <- function(input_file, macro_name) {
  # Split the input string by new lines to get individual phrases
  phrases <- unlist(strsplit(input_file, "\n"))

  # Remove any empty strings resulting from splitting
  phrases <- phrases[phrases != ""]

  # Initialize an empty vector to store formatted phrases
  formatted_phrases <- c()

  # Loop through each phrase
  for (phrase in phrases) {
    # Split each phrase into words
    words <- unlist(strsplit(phrase, " "))

    # Initialize an empty vector to store formatted words for this phrase
    formatted_words <- c()

    # Check each word for an exclamation mark at the beginning
    for (word in words) {
      if (startsWith(word, "!")) {
        # If the word starts with "!", set it up for negation using a
        # zero-width assertion.
        formatted_words <- c(formatted_words, paste0(
          "[: word != \"", substring(word, 2), "\"%cd :]"))
      } else if (endsWith(word, "?") & !str_detect(word, ".*\\(.*\\)")) {
        # If it ends with "?", add a boolean operator
        formatted_words <- c(formatted_words, paste0(
          "[word = \"", substring(word, 1, nchar(word) - 1), "\"%cd]?"))
      } else if (str_detect(word, ".*\\(.*\\)")) {
        # If there are parentheses, format them. CQP recognizes boolean parts.
        formatted_words <- c(formatted_words, paste0(
          "[word = \"", word, "\"%cd]"))
      } else {
        # Else, format normally
        formatted_words <- c(formatted_words, paste0(
          "[word = \"", word, "\"%cd]"))
      }
    }

    # Concatenate formatted words with spaces in between
    formatted_phrase <- paste(formatted_words, collapse = " ")

    # Append the formatted phrase followed by a pipe symbol
    formatted_phrases <- c(formatted_phrases, formatted_phrase)
  }

  # Combine all formatted phrases with a pipe separator
  result <- paste(formatted_phrases, collapse = " | ")

  # Wrap the string in the CQP macro format
  output_macro_name <- paste0("MACRO ", macro_name, "()")
  final_output <- paste(output_macro_name,
                        "(",
                        result,
                        sep = "\n")
  final_output <- paste(final_output,
                        "\n)\n;\n",
                        sep = "")

  if (nchar(final_output) > 4096) {
    cat("WARNING: The CQP macro exceeds the maximum length of 4096 characters.
        A post-hoc manual split is necessary")
  }

  return(final_output)
}


# Read the input_files
input_conj_adj <- readLines(
  "code/gma_analysis/gma_materials/wordlists/seeflex_conj-adj.txt")
input_mod_adj <- readLines(
  "code/gma_analysis/gma_materials/wordlists/seeflex_mod-adj.txt")

# Create the output_strings
output_conj_adj <- format_string(input_conj_adj, macro_name = "ConjAdj")
output_mod_adj <- format_string(input_mod_adj, macro_name = "ModAdj")

# Concatenate all strings and write to macro file
output_file <- c(output_conj_adj, output_mod_adj)
# cat(output_file)
writeLines(output_file,
           "code/gma_analysis/gma_materials/wordlists/seeflex_macros.m")
