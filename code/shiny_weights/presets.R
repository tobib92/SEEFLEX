Presets <- list(
  preset_ = list(
    name = "W1: All pronouns per word across operators", lda = "pca",
    dim = "PC1", y = "contribution", granularity = "n17", focus_t.curr = c(
      "analysis",
      "argumentative", "creative", "int.reading", "mediation"
    ),
    focus_genre = c(
      "describing", "entertaining", "explaining",
      "inquiring", "persuading", "recounting", "responding"
    ), focus_grade = c(
      "10",
      "11", "12"
    ), feature_deselect = "selected_features", focus_feature = "pall_W",
    focus_weight = 0L, plot_size = "M", use_legend = TRUE, use_ylim_box = FALSE,
    use_ylim_disc = FALSE, show_OPERATOR.17 = c(
      "analyze", "blog",
      "characterize", "comment", "describe", "dialogue", "diary",
      "formal_letter", "informal_e-mail", "interior_monologue",
      "magazine", "point_out", "report", "sonnet_paraphrase", "speech",
      "story", "summarize"
    ), show_OPERATOR.25 = character(0)
  ),
  preset_2 = list(
    name = "W2: Pronouns in dialogues and speeches", lda = "pca",
    dim = "PC1", y = "contribution", granularity = "n17", focus_t.curr = c(
      "analysis",
      "argumentative", "creative", "int.reading", "mediation"
    ),
    focus_genre = c(
      "describing", "entertaining", "explaining",
      "inquiring", "persuading", "recounting", "responding"
    ), focus_grade = c(
      "10",
      "11", "12"
    ), feature_deselect = "selected_features", focus_feature = c(
      "pall_W",
      "ppers1_P", "ppers2_P", "ppers3_P"
    ), focus_weight = 0L, plot_size = "M",
    use_legend = TRUE, use_ylim_box = FALSE, use_ylim_disc = FALSE,
    show_OPERATOR.17 = c("dialogue", "speech"), show_OPERATOR.25 = character(0)
  ),
  preset_3 = list(
    name = "W3: Pronouns in descriptions and informal e-mails",
    lda = "pca", dim = "PC2", y = "contribution", granularity = "n17",
    focus_t.curr = c(
      "analysis", "argumentative", "creative",
      "int.reading", "mediation"
    ), focus_genre = c(
      "describing",
      "entertaining", "explaining", "inquiring", "persuading",
      "recounting", "responding"
    ), focus_grade = c(
      "10", "11",
      "12"
    ), feature_deselect = "selected_features", focus_feature = c(
      "pall_W",
      "ppers1_P", "ppers2_P", "ppers3_P"
    ), focus_weight = 0L, plot_size = "M",
    use_legend = TRUE, use_ylim_box = FALSE, use_ylim_disc = FALSE,
    show_OPERATOR.17 = c("describe", "informal_e-mail"), show_OPERATOR.25 = character(0)
  )
)
