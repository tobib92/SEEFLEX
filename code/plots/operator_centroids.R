#### Set working directory to the SEEFLEX root folder ####

# Load necessary libraries, data, and source utilities files
library(scatterD3)
source("code/gma_analysis/gma_utils.R")
source("code/gma_analysis/seeflex_gma_utils.R")
load(file = "data/gma/20250519_shiny_data.rda")

# Set the desired principal components for the x and y axis.
PC_x_axis <- "PC4" # Change this value as needed
PC_y_axis <- "PC3" # Change this value as needed


# Calculate centroids
centroids <- PCA4.df %>%
  stats::aggregate(cbind(get(PC_x_axis), get(PC_y_axis)) ~ OPERATOR.17, FUN = mean) %>%
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
  xlab = PC_x_axis, ylab = PC_y_axis,
  ellipses = TRUE
)

# Create ggplot with confidence ellipses scatterD3 layout
centroid_plot <- ggplot(
  PCA4.df, aes(x = get(PC_x_axis), y = get(PC_y_axis))
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
    x = -Inf, y = Inf, label = "Principal component 1",
    angle = 90, hjust = 1.05, vjust = 1.25
  ) +
  annotate("text",
    x = Inf, y = -Inf, label = "Principal component 2",
    hjust = 1.05, vjust = -0.5
  ) +
  geom_hline(yintercept = 0, linetype = "dashed", size = .4) +
  geom_vline(xintercept = 0, linetype = "dashed", size = .4) +
  # Replicate the Preset 1 axes limits and the breaks
  scale_x_continuous(
    limits = c(-4.55522655890357, 4.54193310913972),
    breaks = seq(-4, 4), expand = expansion()
  ) +
  scale_y_continuous(
    limits = c(-5.58794710793681, 3.50921256010647),
    breaks = seq(-5, 3), expand = expansion()
  ) +
  geom_text(
    data = centroids, aes(
      x = PC_x, y = PC_y, label = OPERATOR.17, colour = OPERATOR.17
      ),
    vjust = -1
  ) +
  scale_fill_manual(values = c17_corp) +
  scale_color_manual(values = c17_corp)


##### Save the plot to a .pdf file #####

output_filename <- paste0(
  "output/plots/", format(Sys.Date(), "%Y%m%d"),
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
