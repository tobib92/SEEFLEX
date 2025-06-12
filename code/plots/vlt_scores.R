#### Set working directory to the SEEFLEX root folder ####

source("code/data_pipeline/meta_data.R")


# Data preparation

long_vlt <- MD %>%
  pivot_longer(
    cols = matches(".{0,1}VLT.+"),
    names_to = "Score_Type",
    values_to = "Score_Value",
    values_drop_na = TRUE
    )

long_vlt$GRADE <- as.factor(long_vlt$GRADE)


# Plot

vlt_plot <- ggplot(long_vlt, aes(x = Score_Type, y = Score_Value, fill = GRADE)) +
  geom_bar(position = "dodge", stat = "summary", fun = "mean") +
  geom_text(aes(label = round(after_stat(y), 2)),
            stat = "summary", fun = "mean",
            position = position_dodge(0.91),
            hjust = 1.2,
            # vjust = 0,
            colour = "#FFFFFF",
            angle = 90
            ) + # Adjust vertical position of text
  geom_hline(yintercept = 80, linetype = "dashed", color = "#000000") +
  annotate("text", x = 5, y = 82, label="Passing line (80%)") +
  labs(title = "VLT results",
       x = "Levels",
       y = "Score") +
  scale_fill_manual(values = c("#00B1B7", "#407FB7", "#2D7F83")) +
  scale_x_discrete(labels = c("Lvl. 1000", "Lvl. 2000", "Lvl. 3000", "Lvl. 4000", "Lvl. 5000", "Lvl. 10000", "Lvl. Academic", "Overallscore")) +
  theme_minimal()


vlt_plot


##### Save the plot to a .pdf file #####

output_filename <- paste0("output/plots/", format(Sys.Date(), "%Y%m%d"),
                          "_vlt_plot.pdf")

ggsave(filename = output_filename,
       plot = vlt_plot,
       device = "pdf",
       width = 297,
       height = 150,
       units = "mm",
       dpi = 300)
