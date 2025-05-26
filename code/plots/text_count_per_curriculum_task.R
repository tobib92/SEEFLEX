#### Set working directory to the SEEFLEX root folder ####

library(tidyverse)

source("code/data_pipeline/meta_data.R")

# Set operator granularity: TRUE = 17, FALSE = 25
OPERATOR_MODE <- FALSE

if (OPERATOR_MODE) {
  OPERATOR <- "OPERATOR.17"
} else {
  OPERATOR <- "OPERATOR.25"
}

WD_sum <- WD %>%
  group_by(get(OPERATOR), T.CURR) %>%
  dplyr::summarise(total_count = n(), .groups = "drop") %>%
  arrange(desc(total_count)) %>%
  ungroup() %>%
  mutate(T.CURR = case_when(
    T.CURR == "int.reading" ~ "t1_int.reading",
    T.CURR == "analysis" ~ "t2_analysis",
    T.CURR == "argumentative" ~ "t3_argumentative",
    T.CURR == "creative" ~ "t3_creative",
    T.CURR == "mediation" ~ "t4_mediation",
    TRUE ~ T.CURR # Keep other values unchanged
  )) %>%
  dplyr::rename(OPERATOR = 1) %>%
  group_by(OPERATOR, T.CURR, total_count)
# mutate(cum_count = cumsum(total_count))

WD_sum_t.curr <- WD %>%
  # dplyr::select(-OPERATOR) %>%
  group_by(T.CURR) %>%
  dplyr::summarise(total_count = n()) %>%
  mutate(T.CURR = case_when(
    T.CURR == "int.reading" ~ "t1_int.reading",
    T.CURR == "analysis" ~ "t2_analysis",
    T.CURR == "argumentative" ~ "t3_argumentative",
    T.CURR == "creative" ~ "t3_creative",
    T.CURR == "mediation" ~ "t4_mediation",
    TRUE ~ T.CURR # Keep other values unchanged
  ))

count_int.reading <- WD_sum_t.curr %>%
  filter(T.CURR == "t1_int.reading") %>%
  pull(total_count)
count_analysis <- WD_sum_t.curr %>%
  filter(T.CURR == "t2_analysis") %>%
  pull(total_count)
count_argumentative <- WD_sum_t.curr %>%
  filter(T.CURR == "t3_argumentative") %>%
  pull(total_count)
count_creative <- WD_sum_t.curr %>%
  filter(T.CURR == "t3_creative") %>%
  pull(total_count)
count_mediation <- WD_sum_t.curr %>%
  filter(T.CURR == "t4_mediation") %>%
  pull(total_count)
count_analyze <- WD_sum %>%
  filter(T.CURR == "t4_mediation") %>%
  pull(total_count)


if (OPERATOR_MODE) {
  manual_order <- c(
    "analyze", "summarize", "comment", "e-mail_informal",
    "letter_formal", "point_out", "describe", "report", "blog", "magazine",
    "dialogue", "speech", "interior_monologue",
    "paraphrase_sonnet", "characterize", "diary", "story"
  )

  manual_order_revision <- c(
    "analyze", "summarize", "comment (on)", "write an informal e-mail",
    "write a formal letter", "point out", "describe", "report", "write a blog entry", "write a magazine text",
    "write a dialogue", "write a speech", "write an interior monologue",
    "paraphrase a sonnet", "characterize", "write a diary entry", "write a story"
  )

  manual_order_reversed <- rev(manual_order_revision)

  new_value_names <- c(
    "analyze", "summarize", "comment (on)", "write an informal e-mail",
    "write a formal letter", "point out", "describe", "report", "write a blog entry", "write a magazine text",
    "write a dialogue", "analyze", "write an interior monologue", "write an informal e-mail", "paraphrase a sonnet",
    "write a speech", "characterize", "write a diary entry", "write a speech", "write a story"
  )

  WD_sum$OPERATOR <- new_value_names
} else {
  manual_order <- c(
    "analyze", "comment", "informal_e-mail", "summarize", "outline", "formal_letter",
    "point_out", "describe", "discuss", "report", "blog", "dialogue", "explain",
    "speech", "magazine", "present", "sonnet_paraphrase",
    "characterize", "diary", "soliloquy", "informal_letter", "interior_monologue",
    "news", "story", "assess"
  )

  manual_order_revision <- c(
    "analyze", "comment (on)", "write an informal e-mail", "summarize", "outline", "write a formal letter",
    "point out", "describe", "discuss", "write a report", "write a blog entry", "write a dialogue", "explain",
    "write a speech", "write a magazine text", "present", "paraphrase a sonnet",
    "characterize", "write a diary entry", "write a soliloquy", "write an informal letter", "write an interior monologue",
    "write a news text", "write a story", "assess"
  )

  manual_order_reversed <- rev(manual_order_revision)

  new_value_names <- c(
    "analyze", "comment (on)", "summarize", "write an informal e-mail", "outline", "write a formal letter",
    "point out", "describe", "discuss", "write a report", "write a blog entry", "write a dialogue", "explain",
    "write a magazine text", "present", "write an informal e-mail", "paraphrase a sonnet", "write a speech",
    "characterize", "write a diary entry", "write a soliloquy", "write an informal letter", "write an interior monologue",
    "write a news text", "write a speech", "write a story", "assess"
  )

  WD_sum$OPERATOR <- new_value_names
}


# Horizontal barplot sorted by OPERATOR and filled by T.CURR

plot <- ggplot(
  WD_sum,
  aes(
    x = total_count,
    y = reorder(
      OPERATOR,
      match(OPERATOR, manual_order_reversed)
    ),
    fill = T.CURR
  )
) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = total_count),
    position = position_stack(vjust = 0),
    hjust = 0,
    # colour = "#FFFFFF",
    colour = "#FFFFFF",
    fontface = "bold"
  ) +
  labs(
    y = "Operators",
    x = "# of Texts"
  ) +
  theme_minimal() +
  theme(
    legend.position = "inside",
    legend.position.inside = c(0.75, 0.5),
    legend.box = "horizontal",
    text = element_text(size = 16),
    panel.grid = element_blank()
  ) +
  # scale_x_discrete(guide = guide_axis(n.dodge = 2)) +
  guides(fill = guide_legend(title = NULL)) +
  scale_fill_manual(
    values = c("#00559f", "#57ab27", "#cc071e", "#612158", "#f6a800"),
    # values = c("#8ebae5", "#b8d698", "#e69679", "#a8859e", "#fdd58f"),
    labels = c(
      paste0(
        "t1: Integrated reading comprehension (n = ",
        count_int.reading, ")"
      ),
      paste0("t2: Analysis (n = ", count_analysis, ")"),
      paste0("t3a: Argumentative (n = ", count_argumentative, ")"),
      paste0("t3c: Creative (n = ", count_creative, ")"),
      paste0("t4: Mediation (n = ", count_mediation, ")")
    )
  )

plot

# Plot sorted by T.CURR and filled with OPERATOR

T.CURR_order <- c(
  "t1_int.reading", "t2_analysis", "t3_argumentative",
  "t3_creative", "t4_mediation"
)
T.CURR_order_reversed <- rev(T.CURR_order)

tcurr_count_plot <- ggplot(
  WD_sum,
  aes(
    x = total_count,
    y = factor(T.CURR, levels = T.CURR_order_reversed),
    fill = OPERATOR
  )
) +
  geom_bar(stat = "identity", colour = "#000000", size = 0.5) +
  geom_text(aes(label = total_count),
    position = position_stack(vjust = 0),
    hjust = 0,
    colour = "#000000",
    fontface = "bold"
  ) +
  labs(
    y = "Curricular tasks",
    x = "# of Texts"
  ) +
  theme_minimal() +
  theme(
    # legend.position = "top",
    # legend.box = "vertical",
    panel.grid = element_blank()
  ) +
  # scale_x_discrete(guide = guide_axis(n.dodge = 2)) +
  guides(fill = guide_legend(title = NULL)) +
  scale_fill_manual(
    values = c(
      "#00559f", "#006265", "#0099a1", "#57ab27", "#bdcd00", "#f6a800",
      "#cc071e", "#a11035", "#612158", "#7a6fac", "#8EBAE5", "#7DA4A7",
      "#89CCCF", "#B8D698", "#E0E69A", "#FDD499", "#e69679"
    )
  )


tcurr_count_plot


##### Save the plot to a .pdf file #####

output_filename <- paste0(
  "output/plots/", format(Sys.Date(), "%Y%m%d"),
  "_operator-count-plot.pdf"
)

ggsave(
  filename = output_filename,
  plot = plot,
  device = "pdf",
  width = 297,
  height = 150,
  units = "mm",
  dpi = 300
)
