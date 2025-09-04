#### Set working directory to the SEEFLEX root folder ####

# Load necessary libraries, data, and source utilities files
library(scatterD3)
source("code/gma_analysis/gma_utils.R")
source("code/gma_analysis/seeflex_gma_utils.R")
load(file = "data/gma/shiny_data.rda")

# Set the desired principal components for the x and y axis.
data_centroids <- LDA4_t.curr.df # Change this value as needed
cent_x_axis <- "LD2" # Change this value as needed
cent_y_axis <- "LD1" # Change this value as needed


# Calculate centroids
centroids <- data_centroids %>%
  stats::aggregate(cbind(get(cent_x_axis), get(cent_y_axis)) ~ OPERATOR.17, FUN = mean) %>%
  dplyr::rename(PC_x = V1) %>%
  dplyr::rename(PC_y = V2)

# Create scatterD3 plot
scatterD3(
  x = PC_x,
  y = PC_y,
  data = centroids,
  colors = c17_corp.vec,
  col_var = OPERATOR.17,
  point_size = 50,
  xlab = cent_x_axis, ylab = cent_y_axis,
  ellipses = TRUE
)

# Create ggplot with confidence ellipses scatterD3 layout
centroid_plot <- ggplot(
  data_centroids, aes(x = get(cent_x_axis), y = get(cent_y_axis))
) +
  geom_point(color = "white", alpha = 0.0001) +
  stat_ellipse(aes(color = OPERATOR.17), alpha = .8, size = .4) +
  geom_point(
    data = centroids,
    aes(
      x = PC_x,
      y = PC_y,
      color = OPERATOR.17,
      fill = OPERATOR.17
    ),
    size = 4,
    shape = 21
  ) +
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
    label = "Linear discriminant 1", # Change this value as needed for x-axis
    angle = 90, hjust = 1.05, vjust = 1.25
  ) +
  annotate("text",
    x = Inf, y = -Inf,
    # label = "Principal component 3", # Change this value as needed for y-axis
    label = "Linear discriminant 2", # Change this value as needed for y-axis
    hjust = 1.05, vjust = -0.5
  ) +
  geom_hline(yintercept = 0, linetype = "dashed", linewidth = .4) +
  geom_vline(xintercept = 0, linetype = "dashed", linewidth = .4) +
  # Replicate the Preset 1 axes limits and the breaks
  scale_x_continuous(
    # limits = c(-2.48793165564555, 1.99487600647723),
    limits = c(-2.4, 1.7), # Change these values as needed
    breaks = seq(-2, 1), expand = expansion()
  ) +
  scale_y_continuous(
    # limits = c(-1.92442326241295, 2.55838439970983),
    limits = c(-1.7, 2.2), # Change these values as needed
    breaks = seq(-1, 2), expand = expansion()
  ) +
  geom_text(
    data = centroids, aes(
      x = PC_x, y = PC_y, label = OPERATOR.17, colour = OPERATOR.17
      ),
    vjust = -1
  ) +
  scale_fill_manual(values = c17_corp) +
  scale_color_manual(values = c17_corp)


centroid_plot

##### Save the plot to a .pdf file #####

output_filename <- paste0(
  "output/plots/", format(Sys.time(), "%Y%m%d_%H%M%S"),
  "_centroid-plot.pdf"
)

ggsave(
  filename = output_filename,
  plot = centroid_plot,
  device = "pdf",
  width = 200,
  height = 200,
  units = "mm",
  dpi = 300
)
