#### Set working directory to the SEEFLEX root folder ####

library(data.table)
library(tidyverse)
library(grDevices)

load("data/gma/20250412_shiny_data.rda")
source("code/gma_analysis/seeflex_gma_utils.R")

# Create manual gradients, starting at the -.7 color (-1 color in cor.colors above)
blue_gradient <- colorRampPalette(c("#78A4CC", "#E9F0F7"))(7) # Blue to White
red_gradient <- colorRampPalette(c("#FAECE9", "#d85c41"))(10)   # White to Red
cor.colours <- c(blue_gradient, "white", red_gradient)
breaks <- seq(-1, 1, by = 0.1)

# Convert matrix to long format
cor_matrix <- cor(seeflex_zl)
# cor_matrix[cor_matrix<=0.7]=NA # replace all values lower than .7 with NA
cor_melted <- melt(cor_matrix)

# Create the heatmap
heatplt <- ggplot(cor_melted, aes(Var1, Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradientn(colors = cor.colours) +   # Use custom colors here
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        axis.title = element_blank(),
        legend.key.size = unit(1, "cm"),
        legend.text = element_text(size = 12),
        legend.title = element_text(size = 14),
        axis.text = element_text(size = 12),
        axis.text.y = element_text(size = 12)) +
  scale_y_discrete(limits=rev) +
  ggtitle("SEEFLEX Linguistic Features Heatmap") +
  geom_text(aes(label = round(value, 2)), color = "black", size = 3.5) +
  labs(fill="Correlation") +
  theme(
    legend.position = "none",
    plot.title = element_text(hjust = 0.5)
  )

# svg("output/plots/heatmap.svg", width = 20, height = 18)
# print(heatplt)
# dev.off()

ggsave(
  filename = "output/plots/heatmap.pdf",
  plot = heatplt,
  device = "pdf",
  width = 45,
  height = 40,
  units = "cm"
  )
