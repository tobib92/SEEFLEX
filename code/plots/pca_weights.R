#### Set working directory to the SEEFLEX root folder ####

# Load the required packages
library(tidyverse)
library(ggrepel)
library(scales)

# Load the data
load("data/gma/shiny_data.rda")

# Create the clusters
set.seed(123)
clusters <- kmeans(weights_LDA_genre[, c("LD3", "LD4")], centers = 4)
pca_weights <- as.data.frame(weights_LDA_genre)
pca_weights <- pca_weights %>%
  mutate(cluster = clusters$cluster) %>%
  dplyr::filter(abs(LD4) >= .1)

# Create the color palette
my_palette <- c(
  "#00559f",
  "#006265",
  "#0099a1",
  "#57ab27",
  "#bdcd00",
  "#f6a800",
  "#a11035",
  "#cc071e",
  "#7a6fac",
  "#612158"
)

# Plot the data

weights_plot <- ggplot(pca_weights, aes(x = LD4, y = LD3, color = cluster)) +
  geom_point(size = 3.5) +
  geom_text_repel(aes(label = rownames(pca_weights)), size = 5, vjust = -1, max.overlaps = 20) +
  scale_color_gradientn(colors = my_palette) +
  theme_bw() +
  theme(
    legend.position = "none",
    axis.title.y = element_blank(),
    axis.title.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank()
  ) +
  # Replicate the scatterD3() axes labels within the coordinate system
  annotate("text",
           x = -Inf, y = Inf,
           # label = "Principal component 2", # Change this value as needed for x-axis
           label = "Linear discriminant 3", # Change this value as needed for x-axis
           angle = 90, hjust = 1.05, vjust = 1.25
  ) +
  annotate("text",
           x = Inf, y = -Inf,
           # label = "Principal component 3", # Change this value as needed for y-axis
           label = "Linear discriminant 4", # Change this value as needed for y-axis
           hjust = 1.05, vjust = -0.5
  ) +
  geom_hline(yintercept = 0, linetype = "dashed", linewidth = .4) +
  geom_vline(xintercept = 0, linetype = "dashed", linewidth = .4) +
  # Replicate the Preset 1 axes limits and the breaks
  # scale_x_continuous(
  #   limits = c(-0.35, 0.45),
  #   breaks = seq(-0.3, 0.4, by = 0.2),
  #   labels = label_number(accuracy = 0.1)
  # ) +
  # scale_y_continuous(
  #   limits = c(-0.35, 0.82),
  #   breaks = seq(-0.3, 0.8, by = 0.2),
  #   labels = label_number(accuracy = 0.1)
  # ) +
  # coord_fixed(ratio = 1) +
  theme(
    legend.position = "none",
    plot.title = element_text(hjust = 0.5)
  )

weights_plot

##### Save the plot to a .pdf file #####

output_filename <- paste0(
  "output/plots/", format(Sys.time(), "%Y%m%d_%H%M%S"),
  "_weights-plot.pdf"
)

ggsave(
  filename = output_filename,
  plot = weights_plot,
  device = "pdf",
  width = 200,
  height = 200,
  units = "mm",
  dpi = 300
)
