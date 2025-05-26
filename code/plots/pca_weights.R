#### Set working directory to the SEEFLEX root folder ####

# Load the required packages
library(tidyverse)
library(ggrepel)

# Load the data
load("data/gma/20250412_shiny_data.rda")

# Create the clusters
set.seed(123)
clusters <- kmeans(weights_PCA[, c("PC1", "PC2")], centers = 10)
pca_weights <- as.data.frame(weights_PCA)
pca_weights <- pca_weights %>%
  mutate(cluster = clusters$cluster)

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
ggplot(pca_weights, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(size = 3.5) +
  geom_text_repel(aes(label = rownames(weights_PCA)), size = 5, vjust = -1, ) +
  labs(x = "PC1 weights", y = "PC2 weights", title = "SEEFLEX PCA feature weights", color = "Cluster") +
  xlim(-0.4, max(weights_PCA[, "PC1"]) + 0.1) +
  ylim(-0.4, max(weights_PCA[, "PC2"]) + 0.1) +
  geom_hline(yintercept = 0, color = "black") +
  geom_vline(xintercept = 0, color = "black") +
  scale_color_gradientn(colors = my_palette) +
  theme_minimal() +
  theme(
    legend.position = "none",
    plot.title = element_text(hjust = 0.5)
  )
