Presets <- list(
  preset_ = list(
    name = "W1: PCA all pronouns per word across operators (Dim 1)", lda = "pca",
    dim = "Dim1", y = "contribution", granularity = "n17", focus_t.curr = c(
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
    name = "W2: PCA pronouns in dialogue and speech (Dim 1)", lda = "pca",
    dim = "Dim1", y = "contribution", granularity = "n17", focus_t.curr = c(
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
    name = "W3: PCA pronouns in describe and informal e-mail (Dim 2)",
    lda = "pca", dim = "Dim2", y = "contribution", granularity = "n17",
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
    name = "W4: PCA adjectives and attributive adjectives across operators (Dim 2)",
    lda = "pca", dim = "Dim2", y = "contribution", granularity = "n17",
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
    name = "W5: PCA overview blog, report, and comment (Dim 3)",
    lda = "pca", dim = "Dim3", y = "contribution", granularity = "n17",
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
    name = "W6: PCA IRC overview (Dim 2)",
    lda = "pca", dim = "Dim2", y = "contribution", granularity = "n17",
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
    name = "W7: PCA strong negative weights across operators (Dim 3)",
    lda = "pca", dim = "Dim3", y = "contribution", granularity = "n17",
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
    name = "W8: PCA modal verbs across operators (Dim 3)",
    lda = "pca", dim = "Dim3", y = "features", granularity = "n17",
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
    name = "W9: PCA selected features and operators (Dim 4)", lda = "pca",
    dim = "Dim4", y = "contribution", granularity = "n17", focus_t.curr = c(
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
  ),
  preset_10 = list(
    name = "W10: LDAg selected operator density (Dim 2)", lda = "lda_genre",
    dim = "Dim2", y = "contribution", granularity = "n17", focus_t.curr = c(
      "analysis",
      "argumentative", "creative", "int.reading", "mediation"
    ),
    focus_genre = c(
      "describing", "entertaining", "explaining",
      "inquiring", "persuading", "recounting", "responding"
    ), focus_grade = c(
      "10",
      "11", "12"
    ), feature_deselect = "all_features", focus_feature = "word_S",
    focus_weight = 0L, plot_size = "M", use_legend = TRUE, use_ylim_box = FALSE,
    use_ylim_disc = FALSE, show_OPERATOR.17 = c(
      "analyze", "blog",
      "describe", "formal_letter", "informal_e-mail", "summarize"
    ), show_OPERATOR.25 = character(0)
  ),
  preset_11 = list(
    name = "W11: LDAg CRE and IRC selected features (Dim 1)", lda = "lda_genre",
    dim = "Dim1", y = "contribution", granularity = "n5", focus_t.curr = c(
      "creative",
      "int.reading"
    ), focus_genre = c(
      "describing", "entertaining",
      "explaining", "inquiring", "persuading", "recounting", "responding"
    ), focus_grade = c("10", "11", "12"), feature_deselect = "selected_features",
    focus_feature = c("pall_W", "past_F", "verb_W", "ttex_disc_S"), focus_weight = 0L, plot_size = "M", use_legend = TRUE,
    use_ylim_box = FALSE, use_ylim_disc = FALSE, show_OPERATOR.17 = character(0),
    show_OPERATOR.25 = character(0)
  ),
  preset_12 = list(
    name = "W12: LDAg CRE dialogue vs. narration (Dim 1)", lda = "lda_genre",
    dim = "Dim1", y = "contribution", granularity = "n17", focus_t.curr = "creative",
    focus_genre = c(
      "describing", "entertaining", "explaining",
      "inquiring", "persuading", "recounting", "responding"
    ), focus_grade = c(
      "10",
      "11", "12"
    ), feature_deselect = "selected_features", focus_feature = c(
      "ppers1_P",
      "ppers3_P", "past_F", "verb_W"
    ), focus_weight = 0L, plot_size = "M",
    use_legend = TRUE, use_ylim_box = FALSE, use_ylim_disc = FALSE,
    show_OPERATOR.17 = c(
      "dialogue", "diary", "interior_monologue",
      "story"
    ), show_OPERATOR.25 = character(0)
  ),
  preset_13 = list(
    name = "W13: LDAg broadcast-related texts (Dim 1)", lda = "lda_genre",
    dim = "Dim1", y = "contribution", granularity = "n17", focus_t.curr = c(
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
      "np_W",
      "pall_W", "ppers1_P", "ppers3_P", "prep_W", "past_F", "pass_F",
      "verb_W"
    ), focus_weight = 0L, plot_size = "M", use_legend = TRUE,
    use_ylim_box = FALSE, use_ylim_disc = FALSE, show_OPERATOR.17 = c(
      "blog",
      "magazine", "report", "speech"
    ), show_OPERATOR.25 = character(0)
  ),
  preset_14 = list(
    name = "W14: LDAg ttop_prep_S across operators (Dim 1)", lda = "lda_genre",
    dim = "Dim1", y = "contribution", granularity = "n17", focus_t.curr = c(
      "analysis",
      "argumentative", "creative", "int.reading", "mediation"
    ),
    focus_genre = c(
      "describing", "entertaining", "explaining",
      "inquiring", "persuading", "recounting", "responding"
    ), focus_grade = c(
      "10",
      "11", "12"
    ), feature_deselect = "selected_features", focus_feature = "ttop_prep_S",
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
  preset_15 = list(
    name = "W15: LDAg salutgreet_S across operators (Dim 2)", lda = "lda_genre",
    dim = "Dim2", y = "contribution", granularity = "n17", focus_t.curr = c(
      "analysis",
      "argumentative", "creative", "int.reading", "mediation"
    ),
    focus_genre = c(
      "describing", "entertaining", "explaining",
      "inquiring", "persuading", "recounting", "responding"
    ), focus_grade = c(
      "10",
      "11", "12"
    ), feature_deselect = "selected_features", focus_feature = "salutgreet_S",
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
  preset_16 = list(
    name = "W16: LDAg imper_S and ttop_verb_S across operators (Dim 3)",
    lda = "lda_genre", dim = "Dim3", y = "weighted", granularity = "n17",
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
      "imper_S",
      "ttop_verb_S"
    ), focus_weight = 0L, plot_size = "M", use_legend = TRUE,
    use_ylim_box = FALSE, use_ylim_disc = FALSE, show_OPERATOR.17 = c(
      "analyze",
      "blog", "characterize", "comment", "describe", "dialogue",
      "diary", "formal_letter", "informal_e-mail", "interior_monologue",
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
  preset_17 = list(
    name = "W17: LDAg selected operators and features (Dim 4)", lda = "lda_genre",
    dim = "Dim4", y = "contribution", granularity = "n17", focus_t.curr = c(
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
      "ppers1_P", "atadj_W", "fin_S", "interr_S", "title_W"
    ), focus_weight = 0L,
    plot_size = "M", use_legend = TRUE, use_ylim_box = FALSE,
    use_ylim_disc = FALSE, show_OPERATOR.17 = c(
      "characterize",
      "describe", "dialogue", "diary", "interior_monologue", "report"
    ), show_OPERATOR.25 = character(0)
  ),
  preset_18 = list(
    name = "W18: LDAt selected operators and features (Dim 1)", lda = "lda_t.curr",
    dim = "Dim1", y = "contribution", granularity = "n17", focus_t.curr = c(
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
      "lexd",
      "nn_W", "np_W", "ppers1_P", "ppers2_P", "past_F", "modal_V",
      "salutgreet_S"
    ), focus_weight = 0L, plot_size = "M", use_legend = TRUE,
    use_ylim_box = FALSE, use_ylim_disc = FALSE, show_OPERATOR.17 = c(
      "analyze",
      "comment", "dialogue", "diary", "formal_letter", "informal_e-mail",
      "summarize"
    ), show_OPERATOR.25 = character(0)
  ),
  preset_19 = list(
    name = "W19: LDAt influential features and selected operators (Dim 2)", lda = "lda_t.curr",
    dim = "Dim2", y = "contribution", granularity = "n17", focus_t.curr = c(
      "analysis",
      "argumentative", "creative", "int.reading", "mediation"
    ),
    focus_genre = c(
      "describing", "entertaining", "explaining",
      "inquiring", "persuading", "recounting", "responding"
    ), focus_grade = c(
      "10",
      "11", "12"
    ), feature_deselect = "weights_limit_features",
    focus_feature = c(
      "word_S", "np_W", "ppers1_P", "adj_W",
      "atadj_W", "prep_W", "fin_S", "modal_V", "subord_F", "salutgreet_S",
      "tint_S"
    ), focus_weight = 0.15, plot_size = "M", use_legend = TRUE,
    use_ylim_box = FALSE, use_ylim_disc = FALSE, show_OPERATOR.17 = c(
      "analyze",
      "blog", "comment", "dialogue", "diary", "formal_letter",
      "informal_e-mail", "point_out", "summarize"
    ), show_OPERATOR.25 = character(0)
  )
)
