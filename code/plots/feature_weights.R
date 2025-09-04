#### Set working directory to the SEEFLEX root folder ####

## NB: The functions in this script were published in the online supplement to
## Neumann & Evert (2021) (https://www.stephanie-evert.de/PUB/NeumannEvert2021/)
## The functions were adapted by Tobias Pauls in the scripts sourced below.

source("code/gma_analysis/gma_utils.R")
source("code/shiny_weights/utilities.R")
load("data/gma/shiny_data.rda")


# Plot the feature weights overview

# Adjust basis with different weight dfs
pca_weights_plot <- gma.plot.weights(
  basis = weights_PCA,
  feature.names = feature.names,
  # main = "LDA Genre",
  dim = 1:4)

pca_weights_plot

output_filename <- paste0(
  "output/plots/", format(Sys.time(), "%Y%m%d_%H%M%S"),
  "_lda_feature_weights.pdf"
)

ggsave(
  filename = output_filename,
  plot = pca_weights_plot,
  device = "pdf",
  width = 210,
  # height = 80, # for one PC/LD
  height = 240, # for four PCs/LDs
  units = "mm",
  dpi = 300
)


# Plot the (weighted) feature values per text in faceted boxplots.
# NB: This script requires tampering with the respective variables, adding and
# removing of commas, as well as adjusting the plot parameters to one's liking.

################################################################################
############################### Feature selection ##############################
################################################################################

selected_features <- feature.names # (Uncommenting affects plot size! See l. 117)
selected_features <- c(
  # "word_S",
  # "lexd"
  # "nn_W",
  "np_W",
  # "nom_W",
  # "neo_W",
  # "pall_W",
  # "pposs_W",
  # "prefx_W",
  # "ppers1_P",
  # "ppers2_P",
  # "ppers3_P",
  # "pit_P",
  # "adj_W",
  # "atadj_W",
  # "prep_W",
  "fin_S",
  "past_F",
  # "will_F",
  # "inf_F",
  # "pass_F",
  # "modal_V",
  "verb_W",
  # "coord_F",
  # "subord_F",
  # "interr_S",
  # "imper_S",
  # "title_W",
  # "salutgreet_S"
  # "adv_place_W",
  # "adv_time_W",
  # "ttex_conj_S",
  # "ttex_disc_S",
  # "tint_S",
  # "ttop_adv_S",
  # "ttop_nom_S",
  "ttop_prep_S"
  # "ttop_wh_S",
  # "ttop_nonfin_S",
  # "ttop_subcl_S",
  # "ttop_interr_S",
  # "ttop_verb_S"
)

################################################################################
############################## Operator selection ##############################
################################################################################

selected_operators <- c(
  "analyze",
  # "blog",
  "characterize",
  "comment"
  # "describe",
  # "dialogue",
  # "diary",
  # "formal_letter",
  # "informal_e-mail",
  # "interior_monologue",
  # "magazine",
  # "point_out",
  # "report",
  # "sonnet_paraphrase",
  # "speech",
  # "summarize",
  # "story"
)

################################################################################
################################ Genre selection ###############################
################################################################################

selected_genres <- c(
  "responding",
  # "inquiring",
  "describing",
  "recounting",
  # "persuading",
  "explaining"
)

################################################################################
########################### curricular task selection ##########################
################################################################################

selected_tcurr <- c(
  # "argumentative",
  # "mediation",
  "int.reading",
  # "analysis",
  "creative"
)

################################################################################
############################## Operator selection ##############################
################################################################################

group_var <- "Operator"
selection_var <- selected_operators # selected_operators selected_genres selected_tcurr

selected_seeflex_zl <- as.matrix(seeflex_zl[, selected_features])
colnames(selected_seeflex_zl) <- selected_features
selected_weights <- as.matrix(weights_LDA_t.curr[selected_features,])
# rownames(selected_weights) <- selected_features
n_feat <- ifelse(
  length(selected_features) == length(get("feature.names", envir = .GlobalEnv)),
  length(get("feature.names", envir = .GlobalEnv)) - 1,
  length(selected_features) - 1
)

# Adjust plot size settings to create equally sized plots
plot_width <- 110 + (48 * n_feat)
plot_rows <- ifelse(n_feat + 1 <= 5, 1, 2) # for a maximum of 10 features

# Choose the correct color variable
if (exists("selected_operators") && all(selection_var %in% selected_operators)) {
  col_var <- c17_corp.vec
} else if (exists("selected_genres") && all(selection_var %in% selected_genres)) {
  col_var <- c7_corp.vec
} else if (exists("selected_tcurr") && all(selection_var %in% selected_tcurr)) {
  col_var <- c5_corp.vec
} else {
  stop("No fitting color variable found!")
}

# Create the plot
feature_plot <- ggbox.selected(
  M = selected_seeflex_zl,
  Meta = seeflex_meta,
  cats = selection_var,
  feature.names = selected_features,
  weights = weights_LDA_t.curr[selected_features, 3], # Dimension
  variable = "OPERATOR.17", # OPERATOR.17 T.CURR GENRE
  group.var = paste0(group_var, "                  "), # legend label (10 spaces)
  colours = col_var,
  nrow = plot_rows, # number of rows in the plot
  what = "contribution" # "features", "weighted" or "contribution"
  # main = "PCA Feature weights"
)
feature_plot

# Create the filename (NB: Always run to avoid overwriting plots in output dir!)
output_filename <- paste0(
  "output/plots/", format(Sys.time(), "%Y%m%d_%H%M%S"),
  "_feature_weight_plot.pdf"
)

# Save the plot
ggsave(
  filename = output_filename,
  plot = feature_plot,
  device = "pdf",
  width = plot_width,
  height = 150,
  units = "mm",
  dpi = 300
)
