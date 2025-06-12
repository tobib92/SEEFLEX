#### Set working directory to the SEEFLEX root folder ####

source("code/data_pipeline/meta_data.R")

# Data preparation

long_lextale <- MD %>%
  pivot_longer(cols = matches("LexTALE.+"),
               names_to = "Score_Type",
               values_to = "Score_Value")

long_lextale$GRADE <- as.factor(long_lextale$GRADE)


# Plot

plot <- ggplot(long_lextale, aes(x = Score_Type, y = Score_Value, fill = GRADE)) +
  geom_bar(position = position_dodge(width = 0.92), stat = "summary", fun = "mean") +
  geom_text(aes(label = round(after_stat(y), 2)),
            stat = "summary", fun = "mean",
            position = position_dodge(0.91),
            hjust = 0.5,
            vjust = 1.2,
            colour = "#FFFFFF"
            # size = 4.5
            # angle = 90
            ) + # Adjust vertical position of text
  labs(title = "LexTALE results",
       x = "Test",
       y = "Score", legend = element_text("test")) +
  scale_fill_manual(values = c("#00B1B7", "#407FB7", "#2D7F83")) +
  scale_x_discrete(labels = c("LexTALE English", "LexTALE German")) +
  theme_minimal()


plot


##### Save the plot to a .pdf file #####

output_filename <- paste0("output/plots/", format(Sys.Date(), "%Y%m%d"),
                          "_lextale_plot.pdf")

ggsave(filename = output_filename,
       plot = plot,
       device = "pdf",
       width = 210,
       height = 150,
       units = "mm",
       dpi = 300)
