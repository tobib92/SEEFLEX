#### Set working directory to the SEEFLEX root folder ####

## NB: The functions in this script were published in the online supplement to
## Neumann & Evert (2021) (https://www.stephanie-evert.de/PUB/NeumannEvert2021/)
## The functions were adapted by Tobias Pauls in the scripts sourced below.

source("code/gma_analysis/gma_utils.R")
source("code/shiny_weights/utilities.R")
load("data/gma/20250519_shiny_data.rda")


# Plot the (weighted) feature values per text in faceted boxplots.
# NB: This script requires tampering with the respective variables, adding and
# removing of commas, as well as adjusting the plot parameters to one's liking.

################################################################################
############################### Feature selection ##############################
################################################################################

all_features <- feature.names # (Uncommenting affects plot size! See l. 117)
# selected_features <- c(
#   "word_S",
#   "lexd",
  # "nn_W",
  # "np_W",
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
  # "fin_S",
  # "past_F",
  # "will_F",
  # "inf_F",
  # "pass_F",
  # "modal_V",
  # "verb_W"
  # "coord_F",
  # "subord_F",
  # "interr_S",
  # "imper_S",
  # "title_W",
  # "salutgreet_S",
  # "adv_place_W",
  # "adv_time_W",
  # "ttex_conj_S",
  # "ttex_disc_S",
  # "tint_S",
  # "ttop_adv_S",
  # "ttop_nom_S",
  # "ttop_prep_S",
  # "ttop_wh_S",
  # "ttop_nonfin_S",
  # "ttop_subcl_S",
  # "ttop_interr_S",
  # "ttop_verb_S"
# )

################################################################################
############################## Operator selection ##############################
################################################################################

selected_operators <- c(
  # "analyze",
  # "blog",
  # "characterize",
  # "comment",
  "describe",
  # "dialogue",
  # "diary",
  # "formal_letter",
  # "informal_e-mail"
  # "interior_monologue"
  # "magazine",
  "point_out",
  # "report",
  # "sonnet_paraphrase",
  # "speech",
  "summarize"
  # "story"
)

################################################################################
########################## Curricular task selection ###########################
################################################################################

selected_tcurr <- c(
  "int.reading"
  # "analysis",
  # "argumentative",
  # "creative",
  # "mediation"
)

################################################################################

par(mar = c(2, 4, 0, 1))
# ymax <- if (input$use_ylim_disc) 2.2 else NULL

selected_seeflex_zl <- as.matrix(seeflex_zl[, all_features])
colnames(selected_seeflex_zl) <- all_features
selected_weights <- as.matrix(weights_PCA[selected_features,])
rownames(selected_weights) <- selected_features



selected_seeflex_meta <- seeflex_meta$id[seeflex_meta$OPERATOR.17 %in% selected_operators]
seeflex_meta_selected <- seeflex_meta %>%
  dplyr::filter(id %in% selected_seeflex_meta)

# Step 2: Subset the matrix using the filtered ids
selected_seeflex_zl <- selected_seeflex_zl[rownames(selected_seeflex_zl) %in% selected_seeflex_meta, ]


densities_plot <- discriminant.plot(
  selected_seeflex_zl,
  discriminant = weights_PCA[,2],
  categories = seeflex_meta_selected$OPERATOR.17,
  # idx = selected_operators,
  col.vals = c17_corp.vec,
  # rug = TRUE,
  legend.cex = 0.5,
  # legend.colsize = 10,
  # y.max = 1,
  # xlim = c(-4, 4),
  # ylim = c(0, 5),
  xaxs = "i"
)

densities_plot

# Create the filename (NB: Always run to avoid overwriting plots in output dir!)
output_filename <- paste0(
  "output/plots/", format(Sys.time(), "%Y%m%d_%H%M%S"),
  "_densities_plot.pdf"
)

# Save the plot
ggsave(
  filename = output_filename,
  plot = densities_plot,
  device = "pdf",
  width = 200,
  height = 100,
  units = "mm",
  dpi = 300
)















# Adjust plot size settings to create equally sized plots
plot_width <- 110 + (48 * n_feat)
plot_rows <- ifelse(n_feat + 1 <= 5, 1, 2) # for a maximum of 10 features

# Create the plot
feature_plot <- ggbox.selected(
  M = selected_seeflex_zl,
  Meta = seeflex_meta,
  cats = selected_operators,
  feature.names = selected_features,
  weights = weights_PCA[selected_features, 1], # Dimension
  variable = "OPERATOR.17", # metadata variable
  group.var = "Operator                  ", # legend label (10 spaces)
  colours = c17_corp.vec,
  nrow = plot_rows, # number of rows in the plot
  what = "contribution" # "features", "weighted" or "contribution"
  # main = "PCA Feature weights"
)



