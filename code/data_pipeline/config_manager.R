library(yaml)
library(R6)
library(log4r)

# logger <- create.logger()

CONFIG_FILE <- "code/data_pipeline/config.yml"
BUNDLES_FILE <- "code/data_pipeline/bundles.yml"


ConfigManager <- R6::R6Class(
  "ConfigManager",
  public = list(
    config = NULL,
    bundles = NULL,
    initialize = function() {
      info(logger, "Loading configuration files...")
      self$config <- yaml::yaml.load_file(CONFIG_FILE)
      self$bundles <- yaml::yaml.load_file(BUNDLES_FILE)
    },
    final_config = function() {
      bundle_name <- self$config$use_bundle
      if (bundle_name != "default") {
        info(logger, paste("Applying bundle:", bundle_name))
        bundle_config <- self$bundles$bundles[[bundle_name]]
        self$config$text_cleaning <- private$update_config(self$config$text_cleaning, bundle_config)
      } else {
        info(logger, "No bundle applied - using default configuration.")
      }
      return(self$config)
    },
    as_dataframe = function() {
      config_df <- as.data.frame(t(self$config))
      return(config_df)
    }
  ),
  private = list(
    update_config = function(default_config, bundle_config) {
      for (option in names(bundle_config)) {
        if (is.list(bundle_config[[option]])) {
          debug(logger, paste("Updating nested option:", option))
          default_config[[option]] <- private$update_config(default_config[[option]], bundle_config[[option]])
        } else if (bundle_config[[option]] != default_config[[option]]) {
          debug(logger, paste("Updating option:", option, "(", default_config[[option]], "->", bundle_config[[option]], ")"))
          default_config[[option]] <- bundle_config[[option]]
        }
      }
      return(default_config)
    }
  )
)

#' Convert settings to configuration patterns
#'
#' This function takes a settings list and converts it into a list of configuration patterns
#' that can be used to clean text.
#'
#' @param settings A list of settings as defined in the configuration file.
#' @return A list of configuration patterns where each pattern is a either a string or NULL.

convert_config <- function(settings) {
  config_patterns <- list(
    "text_cleaning" = list(
      "use_orig" = {
        if (settings$text_cleaning$use_orig) {
          "//d1:reg"
        } else {
          "//d1:orig"
        }
      },
      "use_expan" = {
        if (settings$text_cleaning$use_expan) {
          "//d1:abbr"
        } else {
          "//d1:expan"
        }
      },
      "remove_quotes" = {
        if (settings$text_cleaning$remove_quotes) {
          "//d1:quotes"
        } else {
          NULL
        }
      },
      "remove_q" = {
        if (settings$text_cleaning$remove_q) {
          "//d1:q"
        } else {
          NULL
        }
      },
      "remove_names" = list(
        "person" = if (settings$text_cleaning$remove_names$person) {
          "//d1:name[@type='person']"
        } else {
          NULL
        },
      "geo" = if (settings$text_cleaning$remove_names$geo) {
          "//d1:name[@type='geo']"
        } else {
          NULL
        },
      "misc" = if (settings$text_cleaning$remove_names$misc) {
          "//d1:name[@type='misc']"
        } else {
          NULL
        }
      ),
      "remove_references" = list(
        "author" = if (settings$text_cleaning$remove_references$author) {
          "//d1:ref[@type='author']"
        } else {
          NULL
        },
      "title" = if (settings$text_cleaning$remove_references$author) {
          "//d1:ref[@type='title']"
        } else {
          NULL
        },
      "line" = if (settings$text_cleaning$remove_references$author) {
          "//d1:ref[@type='line']"
        } else {
          NULL
        },
      "scene" = if (settings$text_cleaning$remove_references$author) {
          "//d1:ref[@type='scene']"
        } else {
          NULL
        }
      ),
      "remove_salutations" = list(
        "author" = if (settings$text_cleaning$remove_salutations$salute) {
          "//d1:salute"
        } else {
          NULL
        },
        "title" = if (settings$text_cleaning$remove_salutations$signed) {
          "//d1:signed"
        } else {
          NULL
        }
      ),
      "remove_headers" = {
        if (settings$text_cleaning$remove_headers) {
          "//d1:head"
        } else {
          NULL
        }
      },
      "remove_surplus" = {
        if (settings$text_cleaning$remove_surplus) {
          "//d1:surplus"
        } else {
          NULL
        }
      },
      "remove_add" = {
        if (settings$text_cleaning$remove_add) {
          "//d1:add"
        } else {
          NULL
        }
      },
      "remove_gaps" = {
        if (settings$text_cleaning$remove_gaps) {
          "//d1:gaps"
        } else {
          NULL
        }
      },
      "remove_foreign" = {
        if (settings$text_cleaning$remove_foreign) {
          "//d1:foreign"
        } else {
          NULL
        }
      },
      "remove_dates" = {
        if (settings$text_cleaning$remove_dates) {
          "//d1:date"
        } else {
          NULL
        }
      },
      "remove_links" = {
        if (settings$text_cleaning$remove_links) {
          "//d1:link"
        } else {
          NULL
        }
      },
      "remove_stage" = {
        if (settings$text_cleaning$remove_stage) {
          "//d1:stage"
        } else {
          NULL
        }
      },
      "remove_kinesic" = {
        if (settings$text_cleaning$remove_kinesic) {
          "//d1:kinesic"
        } else {
          NULL
        }
      },
      "remove_said" = {
        if (settings$text_cleaning$remove_said) {
          "//d1:said"
        } else {
          NULL
        }
      },
      "remove_emph" = {
        if (settings$text_cleaning$remove_emph) {
          "//d1:emph"
        } else {
          NULL
        }
      },
      # "s_tags" = {
      #   if (settings$text_cleaning$remove_structural_attributes$s_tags) {
      #     "//d1:s"
      #   } else {
      #     NULL
      #   }
      # },
      # "p_tags" = {
      #   if (settings$text_cleaning$remove_structural_attributes$p_tags) {
      #     "//d1:p"
      #   } else {
      #     NULL
      #   }
      # },
      "remove_teiHeader" = {
        if (settings$text_cleaning$remove_teiHeader) {
          "//d1:teiHeader"
        } else {
          NULL
        }
      }
    )
  )

  return(config_patterns)
}
