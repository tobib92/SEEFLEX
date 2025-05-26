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
  geom_bar(position = "dodge", stat = "summary", fun = "mean") +
  geom_text(aes(label = round(after_stat(y), 2)),
            stat = "summary", fun = "mean",
            position = position_dodge(0.91),
            hjust = 'right',
            # vjust = 0,
            colour = "#FFFFFF",
            angle = 90
            ) + # Adjust vertical position of text
  labs(title = "LexTALE results",
       x = "Scores",
       y = "Score Value", legend = element_text("test")) +
  scale_fill_manual(values = c("#0099a1", "#00559f", "#006265")) +
  scale_x_discrete(labels = c("LexTALE English", "LexTALE German")) +
  theme_minimal()


plot


##### Save the plot to a .pdf file #####

current_date <- format(Sys.Date(), "%Y%m%d")
output_filename <- paste0("output/plots/", current_date,
                          "_text-count-per-tcurr.pdf")

ggsave(filename = output_filename,
       plot = plot,
       device = "pdf",
       width = 210,
       height = 150,
       units = "mm",
       dpi = 300)
