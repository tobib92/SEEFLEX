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
  ),
  preset_4 = list(
    name = "W4: Adjectives and attributive adjectives across operators",
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
      "adj_W",
      "atadj_W"
    ), focus_weight = 0L, plot_size = "M", use_legend = TRUE,
    use_ylim_box = FALSE, use_ylim_disc = FALSE, show_OPERATOR.17 = c(
      "analyze",
      "blog", "characterize", "comment", "describe", "dialogue",
      "diary", "formal_letter", "informal_e-mail", "interior_monologue",
      "magazine", "point_out", "report", "sonnet_paraphrase", "speech",
      "story", "summarize"
    ), show_OPERATOR.25 = character(0)
  ),
  preset_5 = list(
    name = "W5: Feature overview blog, report and comment",
    lda = "pca", dim = "PC3", y = "contribution", granularity = "n17",
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
    ), feature_deselect = "all_features", focus_feature = "word_S",
    focus_weight = 0L, plot_size = "M", use_legend = TRUE, use_ylim_box = FALSE,
    use_ylim_disc = FALSE, show_OPERATOR.17 = c(
      "blog", "comment",
      "report"
    ), show_OPERATOR.25 = character(0)
  ),
  preset_6 = list(
    name = "W6: Integrated reading comprehension overview",
    lda = "pca", dim = "PC2", y = "contribution", granularity = "n17",
    focus_t.curr = "int.reading", focus_genre = c(
      "describing",
      "entertaining", "explaining", "inquiring", "persuading",
      "recounting", "responding"
    ), focus_grade = c(
      "10", "11",
      "12"
    ), feature_deselect = "all_features", focus_feature = "word_S",
    focus_weight = 0L, plot_size = "M", use_legend = TRUE, use_ylim_box = FALSE,
    use_ylim_disc = FALSE, show_OPERATOR.17 = c(
      "describe", "point_out",
      "sonnet_paraphrase", "speech", "summarize"
    ), show_OPERATOR.25 = character(0)
  ),
  preset_7 = list(
    name = "W7: PC3 features with strong negative weights",
    lda = "pca", dim = "PC3", y = "contribution", granularity = "n17",
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
      "word_S",
      "fin_S", "modal_V", "subord_F"
    ), focus_weight = 0L, plot_size = "M",
    use_legend = TRUE, use_ylim_box = FALSE, use_ylim_disc = FALSE,
    show_OPERATOR.17 = c(
      "analyze", "blog", "characterize", "comment",
      "describe", "dialogue", "diary", "formal_letter", "informal_e-mail",
      "interior_monologue", "magazine", "point_out", "report",
      "sonnet_paraphrase", "speech", "story", "summarize"
    ), show_OPERATOR.25 = character(0)
  ),
  preset_8 = list(
    name = "W8: Modal verbs across operators (feature values)",
    lda = "pca", dim = "PC1", y = "features", granularity = "n17",
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
    ), feature_deselect = "selected_features", focus_feature = "modal_V",
    focus_weight = 0L, plot_size = "M", use_legend = TRUE, use_ylim_box = FALSE,
    use_ylim_disc = FALSE, show_OPERATOR.17 = c(
      "analyze", "blog",
      "characterize", "comment", "describe", "dialogue", "diary",
      "formal_letter", "informal_e-mail", "interior_monologue",
      "magazine", "point_out", "report", "sonnet_paraphrase", "speech",
      "story", "summarize"
    ), show_OPERATOR.25 = c(
      "analyze", "assess",
      "blog", "characterize", "comment", "describe", "dialogue",
      "diary", "discuss", "explain", "formal_letter", "informal_e-mail",
      "informal_letter", "interior_monologue", "magazine", "news",
      "outline", "point_out", "present", "report", "soliloquy",
      "sonnet_paraphrase", "speech", "story", "summarize"
    )
  ),
  preset_9 = list(
    name = "W9: PC4 selected features and operators", lda = "pca",
    dim = "PC4", y = "contribution", granularity = "n17", focus_t.curr = c(
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
      "pposs_W",
      "ppers3_P", "pit_P", "prep_W", "ttop_nom_S", "ttop_prep_S"
    ), focus_weight = 0L, plot_size = "M", use_legend = TRUE,
    use_ylim_box = FALSE, use_ylim_disc = FALSE, show_OPERATOR.17 = c(
      "blog",
      "characterize", "comment", "interior_monologue", "magazine",
      "report", "speech", "story"
    ), show_OPERATOR.25 = character(0)
  )
)
