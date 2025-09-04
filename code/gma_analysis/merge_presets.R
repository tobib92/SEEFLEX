#### Set working directory to the SEEFLEX root folder ####

library(styler)

# Choose app (TRUE = scatter, FALSE = weights)
app <- TRUE

append_and_write_presets <- function(presets_file, presets_folder,
                                     output_file = presets_file) {

  # Load the master file in a new environment.
  master_env <- new.env()
  source(presets_file, local = master_env)

  # Confirm that the master file creates "Presets".
  if (!exists("Presets", envir = master_env)) {
    stop("The master file did not create an object named 'Presets'")
  }

  # Retrieve the current presets
  current_presets <- master_env$Presets
  last_preset <- tail(current_presets, 1)
  last_preset_no <- sub(".*?([0-9]+).*", "\\1", last_preset)
  last_preset_no <- as.numeric(last_preset_no)

  # List all .R files in the presets folder.
  preset_files <- list.files(
    presets_folder, pattern = "\\.R$", full.names = TRUE)

  # Build a new list of presets
  new_presets <- list()
  count <- last_preset_no
  for (preset_file in preset_files) {
    count <- count + 1L
    preset_value <- source(preset_file, local = TRUE)$value
    new_presets[[paste0("preset_", count)]] <- preset_value
  }

  # Combine current presets with the newly loaded presets
  updated_presets <- c(current_presets, new_presets)

  # Manually build the R code string to define the updated Presets
  # with each element on a new line.
  preset_lines <- sapply(names(updated_presets), function(name) {
    preset_code <- paste(deparse(updated_presets[[name]]), collapse = "\n")
    paste0("  ", name, " = ", preset_code)
  })

  code_to_write <- paste0(
    "Presets <- list(\n", paste(preset_lines, collapse = ",\n"), "\n)")

  # Apply styler package to format the generated code.
  code_styled <- styler::style_text(code_to_write)

  # Write the formatted code to the output file.
  writeLines(code_styled, con = output_file)

  # Update the master environment variable and return the updated presets.
  master_env$Presets <- updated_presets
  return(updated_presets)
}

if (app) {
  filepath_presets_file <- "code/shiny_scatterplot/presets.R"
  filepath_presets_folder <- "output/presets/scatter/"
} else {
  filepath_presets_file <- "code/shiny_weights/presets.R"
  filepath_presets_folder <- "output/presets/weights/"
}

append_and_write_presets(
  presets_file = filepath_presets_file,
  presets_folder = filepath_presets_folder
  )
