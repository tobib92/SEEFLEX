current_working_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(current_working_dir)

source("../data_pipeline/meta_data.R")

WD_sum <- WD %>%
  group_by(OPERATOR.14, T.CURR) %>%
  dplyr::summarise(total_count = n(), .groups = 'drop') %>%
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
  group_by(OPERATOR.14, T.CURR, total_count)
  # mutate(cum_count = cumsum(total_count))

WD_sum_t.curr <- WD %>%
  # dplyr::select(-OPERATOR.14) %>%
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



# Manual order for OPERATOR.14
manual_order <- c("analyze", "summarize", "comment", "e-mail_informal", 
                  "letter_formal", "describe", "report", "blog", "magazine", 
                  "dialogue", "speech", "interior_monologue", 
                  "paraphrase_sonnet", "characterize", "diary", "story")
manual_order_reversed <- rev(manual_order)


# Horizontal barplot sorted by OPERATOR.14 and filled by T.CURR

plot <- ggplot(WD_sum,
            aes(x = total_count,
                y = reorder(OPERATOR.14, 
                            match(OPERATOR.14, manual_order_reversed)),
                fill = T.CURR)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = total_count), 
            position = position_stack(vjust = 0),
            hjust = 0,
            colour = "#FFFFFF", 
            fontface = "bold") +
   labs(y = 'Operators',
       x = '# of Texts') +
  theme_minimal() +
  theme(
    legend.position = "inside",
    legend.position.inside = c(0.75, 0.5),
    legend.box = "horizontal",
    text = element_text(size = 16),
    panel.grid = element_blank()) +
  # scale_x_discrete(guide = guide_axis(n.dodge = 2)) +
  guides(fill = guide_legend(title = NULL)) +
  scale_fill_manual(
    values = c("#00559f", "#57ab27", "#cc071e", "#612158", "#f6a800"),
    # values = c("#8ebae5", "#b8d698", "#e69679", "#a8859e", "#fdd58f"),
    labels = c(paste0("t1: Integrated reading comprehension (n = ",
                      count_int.reading, ")"),
               paste0("t2: Analysis (n = ", count_analysis, ")"),
               paste0("t3a: Argumentative (n = ", count_argumentative, ")"),
               paste0("t3c: Creative (n = ", count_creative, ")"),
               paste0("t4: Mediation (n = ", count_mediation, ")")))

plot

# Plot sorted by T.CURR and filled with OPERATOR.14

T.CURR_order <- c("t1_int.reading", "t2_analysis", "t3_argumentative", 
                  "t3_creative", "t4_mediation")
T.CURR_order_reversed <- rev(T.CURR_order)

plot <- ggplot(WD_sum,
            aes(x = total_count,
                y = factor(T.CURR, levels = T.CURR_order_reversed),
                fill = OPERATOR.14)) +
  geom_bar(stat = "identity", colour = "#000000", size = 0.5) +
  geom_text(aes(label = total_count),
            position = position_stack(vjust = 0),
            hjust = 0,
            colour = "#000000",
            fontface = "bold") +
   labs(y = 'Curricular tasks',
       x = '# of Texts') +
  theme_minimal() +
  theme(
    # legend.position = "top",
    # legend.box = "vertical",
    panel.grid = element_blank()) +
  # scale_x_discrete(guide = guide_axis(n.dodge = 2)) +
  guides(fill = guide_legend(title = NULL)) +
  scale_fill_manual(
    values = c("#00559f", "#006265", "#0099a1", "#57ab27", "#bdcd00", "#f6a800",
               "#cc071e", "#a11035", "#612158", "#7a6fac", "#8EBAE5", "#7DA4A7", 
               "#89CCCF", "#B8D698", "#E0E69A", "#FDD499"))


plot

ggsave(filename = "../../output/plots/plot_text_count_per_curriculum_task_new.pdf",
       plot = plot,
       device = "pdf",
       width = 297,
       height = 150,
       units = "mm",
       dpi = 300)
