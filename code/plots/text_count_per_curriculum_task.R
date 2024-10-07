current_working_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(current_working_dir)

source("../data pipeline/meta_data.R")

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


plot <- ggplot(WD_sum,
            aes(x = reorder(OPERATOR.14, -total_count),
                y = total_count,
                fill = T.CURR)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = total_count), position = position_stack(vjust = 0.97)) +
   labs(x = 'Operators',
       y = '# of Texts') +
  theme_minimal() +
  theme(
    legend.position = "top",
    legend.box = "horizontal",
    panel.grid = element_blank()) +
  scale_x_discrete(guide = guide_axis(n.dodge = 2)) +
  guides(fill = guide_legend(title = NULL)) +
  scale_fill_manual(
    values = c("#00559f", "#57ab27", "#cc071e", "#7a6fac", "#f6a800"),
    labels = c(paste0("Task 1: Integrated reading comprehension (n = ",
                      count_int.reading, ")"),
               paste0("Task 2: Analysis (n = ", count_analysis, ")"),
               paste0("Task 3: Argumentative (n = ", count_argumentative, ")"),
               paste0("Task 3: Creative (n = ", count_creative, ")"),
               paste0("Task 4: Mediation (n = ", count_mediation, ")")))
plot

ggsave(filename = "../../output/plots/plot_text_count_per_curriculum_task.pdf",
       plot = plot,
       device = "pdf",
       width = 297,
       height = 210,
       units = "mm",
       dpi = 300)
