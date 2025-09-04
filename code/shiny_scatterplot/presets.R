Presets <- list(
  preset_1 = list(
    name = "S1: PCA overview (Dim 1:2)", x = "Dim2", y = "Dim1", lda = "pca",
    granularity = "n17", focus_t.curr = c(
      "analysis", "argumentative",
      "creative", "int.reading", "mediation"
    ), focus_grade = c(
      "10",
      "11", "12"
    ), ellipses = TRUE, transitions = FALSE, pointsize = 4.5,
    show_OPERATOR.17 = c(
      "analyze", "blog", "characterize", "comment",
      "describe", "dialogue", "diary", "formal_letter", "informal_e-mail",
      "interior_monologue", "magazine", "point_out", "report",
      "sonnet_paraphrase", "speech", "story", "summarize"
    ), show_OPERATOR.25 = c(
      "analyze",
      "assess", "blog", "characterize", "comment", "describe",
      "dialogue", "diary", "discuss", "explain", "formal_letter",
      "informal_e-mail", "informal_letter", "interior_monologue",
      "magazine", "news", "outline", "point_out", "present", "report",
      "soliloquy", "sonnet_paraphrase", "speech", "story", "summarize"
    ), viewport = list(
      xmin = -4.55522655890357, xmax = 4.54193310913972,
      ymin = -5.58794710793681, ymax = 3.50921256010647
    )
  ),
  preset_2 = list(
    name = "S2: PCA analyze, describe, point out and summarize (Dim 1:2)",
    x = "Dim2", y = "Dim1", lda = "pca", granularity = "n17",
    filter_col = "Operator 17", filter_sym = "Genre", ellipses = TRUE,
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
    ), transitions = FALSE, pointsize = 4.5, show_OPERATOR.17 = c(
      "analyze",
      "describe", "point_out", "summarize"
    ), show_OPERATOR.25 = c(
      "analyze",
      "assess", "blog", "characterize", "comment", "describe",
      "dialogue", "diary", "discuss", "explain", "formal_letter",
      "informal_e-mail", "informal_letter", "interior_monologue",
      "magazine", "news", "outline", "point_out", "present", "report",
      "soliloquy", "sonnet_paraphrase", "speech", "story", "summarize"
    ), viewport = list(
      xmin = -4.1446232261447, xmax = 3.90526677385529,
      ymin = -4.41474769660958, ymax = 3.63514230339042
    )
  ),
  preset_3 = list(
    name = "S3: PCA CRE tasks (Dim 1:2)", x = "Dim2", y = "Dim1",
    lda = "pca", granularity = "n17", filter_col = "Operator 17",
    filter_sym = "Genre", ellipses = TRUE, focus_t.curr = "creative",
    focus_genre = c(
      "describing", "entertaining", "explaining",
      "inquiring", "persuading", "recounting", "responding"
    ), focus_grade = c(
      "10",
      "11", "12"
    ), transitions = FALSE, pointsize = 4.5, show_OPERATOR.17 = c(
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
    ), viewport = list(
      xmin = -4.55523, xmax = 4.54193, ymin = -5.58795, ymax = 3.50921
    )
  ),
  preset_4 = list(
    name = "S4: PCA broadcast texts (Dim 1:2)", x = "Dim2", y = "Dim1",
    lda = "pca", granularity = "n17", filter_col = "Operator 17",
    filter_sym = "Curricular task", ellipses = TRUE, focus_t.curr = c(
      "analysis",
      "argumentative", "creative", "int.reading", "mediation"
    ),
    focus_genre = c(
      "describing", "entertaining", "explaining",
      "inquiring", "persuading", "recounting", "responding"
    ), focus_grade = c(
      "10",
      "11", "12"
    ), transitions = FALSE, pointsize = 4.5, show_OPERATOR.17 = c(
      "blog",
      "magazine", "report", "speech"
    ), show_OPERATOR.25 = c(
      "analyze",
      "assess", "blog", "characterize", "comment", "describe",
      "dialogue", "diary", "discuss", "explain", "formal_letter",
      "informal_e-mail", "informal_letter", "interior_monologue",
      "magazine", "news", "outline", "point_out", "present", "report",
      "soliloquy", "sonnet_paraphrase", "speech", "story", "summarize"
    ), viewport = list(
      xmin = -4.55523, xmax = 4.54193, ymin = -5.58795,
      ymax = 3.50921
    )
  ),
  preset_5 = list(
    name = "S5: PCA describe and informal e-mail (Dim 1:2)", x = "Dim2",
    y = "Dim1", lda = "pca", granularity = "n17", filter_col = "Operator 17",
    filter_sym = "Curricular task", ellipses = TRUE, focus_t.curr = c(
      "analysis",
      "argumentative", "creative", "int.reading", "mediation"
    ),
    focus_genre = c(
      "describing", "entertaining", "explaining",
      "inquiring", "persuading", "recounting", "responding"
    ), focus_grade = c(
      "10",
      "11", "12"
    ), transitions = FALSE, pointsize = 4.5, show_OPERATOR.17 = c(
      "describe",
      "informal_e-mail"
    ), show_OPERATOR.25 = c(
      "analyze", "assess",
      "blog", "characterize", "comment", "describe", "dialogue",
      "diary", "discuss", "explain", "formal_letter", "informal_e-mail",
      "informal_letter", "interior_monologue", "magazine", "news",
      "outline", "point_out", "present", "report", "soliloquy",
      "sonnet_paraphrase", "speech", "story", "summarize"
    ), viewport = list(
      xmin = -3.61524806802411, xmax = 4.30428969437085, ymin = -4.70804387055181,
      ymax = 3.21149389184316
    )
  ),
  preset_6 = list(
    name = "S6: PCA IRC tasks (Dim 1:2)",
    x = "Dim2", y = "Dim1", lda = "pca", granularity = "n17",
    filter_col = "Operator 17", filter_sym = "Genre", ellipses = TRUE,
    focus_t.curr = "int.reading", focus_genre = c(
      "describing",
      "entertaining", "explaining", "inquiring", "persuading",
      "recounting", "responding"
    ), focus_grade = c(
      "10", "11",
      "12"
    ), transitions = FALSE, pointsize = 4.5, show_OPERATOR.17 = c(
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
    ), viewport = list(
      xmin = -4.23462988690871, xmax = 3.68491011309129, ymin = -4.39489135413442,
      ymax = 3.52464864586558
    )
  ),
  preset_7 = list(
    name = "S7: PCA dialogue and speech (Dim 1:2)", x = "Dim3", y = "Dim2",
    lda = "pca", granularity = "n17", filter_col = "Operator 17",
    filter_sym = "Genre", ellipses = TRUE, focus_t.curr = c(
      "analysis",
      "argumentative", "creative", "int.reading", "mediation"
    ),
    focus_genre = c(
      "describing", "entertaining", "explaining",
      "inquiring", "persuading", "recounting", "responding"
    ), focus_grade = c(
      "10",
      "11", "12"
    ), transitions = FALSE, pointsize = 4.5, show_OPERATOR.17 = c(
      "dialogue",
      "speech"
    ), show_OPERATOR.25 = c(
      "analyze", "assess", "blog",
      "characterize", "comment", "describe", "dialogue", "diary",
      "discuss", "explain", "formal_letter", "informal_e-mail",
      "informal_letter", "interior_monologue", "magazine", "news",
      "outline", "point_out", "present", "report", "soliloquy",
      "sonnet_paraphrase", "speech", "story", "summarize"
    ), viewport = list(
      xmin = -4.10111228168434, xmax = 3.81842548071063, ymin = -3.88913878838249,
      ymax = 4.03039897401247
    )
  ),
  preset_8 = list(
    name = "S8: LDAg overview (Dim 1:2)", x = "Dim2", y = "Dim1",
    lda = "lda_genre", granularity = "n17", filter_col = "Operator 17",
    filter_sym = "Curricular task", ellipses = TRUE, focus_t.curr = c(
      "analysis",
      "argumentative", "creative", "int.reading", "mediation"
    ),
    focus_genre = c(
      "describing", "entertaining", "explaining",
      "inquiring", "persuading", "recounting", "responding"
    ), focus_grade = c(
      "10",
      "11", "12"
    ), transitions = FALSE, pointsize = 4.5, show_OPERATOR.17 = c(
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
    ), viewport = list(
      xmin = -1.95708267542779, xmax = 1.85836243020335, ymin = -2.14303117713329,
      ymax = 1.67241392849785
    )
  ),
  preset_9 = list(
    name = "S9: LDAg argumentative texts (Dim 1:2)", x = "Dim2", y = "Dim1",
    lda = "lda_genre", granularity = "n17", filter_col = "Operator 17",
    filter_sym = "Curricular task", ellipses = TRUE, focus_t.curr = "argumentative",
    focus_genre = c(
      "describing", "entertaining", "explaining",
      "inquiring", "persuading", "recounting", "responding"
    ), focus_grade = c(
      "10",
      "11", "12"
    ), transitions = FALSE, pointsize = 4.5, show_OPERATOR.17 = c(
      "comment",
      "formal_letter", "informal_e-mail", "speech"
    ), show_OPERATOR.25 = c(
      "analyze",
      "assess", "blog", "characterize", "comment", "describe",
      "dialogue", "diary", "discuss", "explain", "formal_letter",
      "informal_e-mail", "informal_letter", "interior_monologue",
      "magazine", "news", "outline", "point_out", "present", "report",
      "soliloquy", "sonnet_paraphrase", "speech", "story", "summarize"
    ), viewport = list(
      xmin = -1.95708, xmax = 1.85836, ymin = -2.14303,
      ymax = 1.67241
    )
  ),
  preset_10 = list(
    name = "S10: LDAg broadcast-related tests (Dim 1:2)", x = "Dim2", y = "Dim1",
    lda = "lda_genre", granularity = "n17", filter_col = "Genre",
    filter_sym = "Curricular task", ellipses = TRUE, focus_t.curr = c(
      "analysis",
      "argumentative", "creative", "int.reading", "mediation"
    ),
    focus_genre = c(
      "describing", "entertaining", "explaining",
      "inquiring", "persuading", "recounting", "responding"
    ), focus_grade = c(
      "10",
      "11", "12"
    ), transitions = FALSE, pointsize = 4.5, show_OPERATOR.17 = c(
      "blog",
      "magazine", "report"
    ), show_OPERATOR.25 = c(
      "analyze", "assess",
      "blog", "characterize", "comment", "describe", "dialogue",
      "diary", "discuss", "explain", "formal_letter", "informal_e-mail",
      "informal_letter", "interior_monologue", "magazine", "news",
      "outline", "point_out", "present", "report", "soliloquy",
      "sonnet_paraphrase", "speech", "story", "summarize"
    ), viewport = list(
      xmin = -1.95708, xmax = 1.85836, ymin = -2.14303, ymax = 1.67241
    )
  ),
  preset_11 = list(
    name = "S11: LDAg CRE, ANA, and IRC (Dim 2:3)", x = "Dim3", y = "Dim2",
    lda = "lda_genre", granularity = "n17", filter_col = "Operator 17",
    filter_sym = "Monochrome", ellipses = TRUE, focus_t.curr = c(
      "analysis",
      "creative", "int.reading"
    ), focus_genre = c(
      "describing",
      "entertaining", "explaining", "inquiring", "persuading",
      "recounting", "responding"
    ), focus_grade = c(
      "10", "11",
      "12"
    ), transitions = FALSE, pointsize = 4L, show_OPERATOR.17 = c(
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
    ), viewport = list(
      xmin = -2.77242813991819, xmax = 1.7103795222046, ymin = -2.16826641029745,
      ymax = 2.31454125182534
    )
  ),
  preset_12 = list(
    name = "S12: LDAg overview (Dim 3:4)", x = "Dim4", y = "Dim3",
    lda = "lda_genre", granularity = "n17", filter_col = "Operator 17",
    filter_sym = "Monochrome", ellipses = TRUE, focus_t.curr = c(
      "analysis",
      "argumentative", "creative", "int.reading", "mediation"
    ),
    focus_genre = c(
      "describing", "entertaining", "explaining",
      "inquiring", "persuading", "recounting", "responding"
    ), focus_grade = c(
      "10",
      "11", "12"
    ), transitions = FALSE, pointsize = 5L, show_OPERATOR.17 = c(
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
    ), viewport = list(
      xmin = -2.82403333563955, xmax = 2.21046992743978, ymin = -3.01838387966864,
      ymax = 2.01611938341069
    )
  ),
  preset_13 = list(
    name = "S13: LDAg personal vs. impersonal (Dim 3:4)", x = "Dim4",
    y = "Dim3", lda = "lda_genre", granularity = "n17", filter_col = "Operator 17",
    filter_sym = "Genre", ellipses = TRUE, focus_t.curr = c(
      "analysis",
      "argumentative", "creative", "int.reading", "mediation"
    ),
    focus_genre = c(
      "describing", "entertaining", "explaining",
      "inquiring", "persuading", "recounting", "responding"
    ), focus_grade = c(
      "10",
      "11", "12"
    ), transitions = FALSE, pointsize = 5L, show_OPERATOR.17 = c(
      "characterize",
      "describe", "dialogue", "diary", "interior_monologue", "report"
    ), show_OPERATOR.25 = c(
      "analyze", "assess", "blog", "characterize",
      "comment", "describe", "dialogue", "diary", "discuss", "explain",
      "formal_letter", "informal_e-mail", "informal_letter", "interior_monologue",
      "magazine", "news", "outline", "point_out", "present", "report",
      "soliloquy", "sonnet_paraphrase", "speech", "story", "summarize"
    ), viewport = list(
      xmin = -2.81699120237679, xmax = 2.21750879762321,
      ymin = -3.13803955959455, ymax = 1.89646044040545
    )
  ),
  preset_14 = list(
    name = "S14: LDAt overview (Dim 1:2)", x = "Dim2", y = "Dim1",
    lda = "lda_t.curr", granularity = "n17", filter_col = "Operator 17",
    filter_sym = "Curricular task", ellipses = TRUE, focus_t.curr = c(
      "analysis",
      "argumentative", "creative", "int.reading", "mediation"
    ),
    focus_genre = c(
      "describing", "entertaining", "explaining",
      "inquiring", "persuading", "recounting", "responding"
    ), focus_grade = c(
      "10",
      "11", "12"
    ), transitions = FALSE, pointsize = 5L, show_OPERATOR.17 = c(
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
    ), viewport = list(
      xmin = -2.48793165564555, xmax = 1.99487600647723, ymin = -1.92442326241295,
      ymax = 2.55838439970983
    )
  ),
  preset_15 = list(
    name = "S15: LDAt selected operators (Dim 1:2)", x = "Dim2", y = "Dim1",
    lda = "lda_t.curr", granularity = "n17", filter_col = "Operator 17",
    filter_sym = "Curricular task", ellipses = FALSE, focus_t.curr = c(
      "analysis",
      "argumentative", "creative", "int.reading", "mediation"
    ),
    focus_genre = c(
      "describing", "entertaining", "explaining",
      "inquiring", "persuading", "recounting", "responding"
    ), focus_grade = c(
      "10",
      "11", "12"
    ), transitions = FALSE, pointsize = 5L, show_OPERATOR.17 = c(
      "analyze",
      "blog", "characterize", "describe", "dialogue", "diary",
      "formal_letter", "informal_e-mail", "interior_monologue",
      "point_out", "report", "speech", "story", "summarize"
    ), show_OPERATOR.25 = c(
      "analyze",
      "assess", "blog", "characterize", "comment", "describe",
      "dialogue", "diary", "discuss", "explain", "formal_letter",
      "informal_e-mail", "informal_letter", "interior_monologue",
      "magazine", "news", "outline", "point_out", "present", "report",
      "soliloquy", "sonnet_paraphrase", "speech", "story", "summarize"
    ), viewport = list(
      xmin = -2.33681690137414, xmax = 2.14599309862585,
      ymin = -1.78988585580743, ymax = 2.69292414419255
    )
  ),
  preset_16 = list(
    name = "S16: LDAt genre distribution (Dim 1:2)", x = "Dim2", y = "Dim1",
    lda = "lda_t.curr", granularity = "n17", filter_col = "Genre",
    filter_sym = "Curricular task", ellipses = FALSE, focus_t.curr = c(
      "analysis",
      "argumentative", "creative", "int.reading", "mediation"
    ),
    focus_genre = c("describing", "entertaining", "responding"), focus_grade = c("10", "11", "12"), transitions = FALSE,
    pointsize = 5L, show_OPERATOR.17 = c(
      "analyze", "blog", "characterize",
      "comment", "describe", "dialogue", "diary", "formal_letter",
      "informal_e-mail", "interior_monologue", "magazine", "point_out",
      "report", "sonnet_paraphrase", "speech", "story", "summarize"
    ), show_OPERATOR.25 = c(
      "analyze", "assess", "blog", "characterize",
      "comment", "describe", "dialogue", "diary", "discuss", "explain",
      "formal_letter", "informal_e-mail", "informal_letter", "interior_monologue",
      "magazine", "news", "outline", "point_out", "present", "report",
      "soliloquy", "sonnet_paraphrase", "speech", "story", "summarize"
    ), viewport = list(
      xmin = -2.46488934286844, xmax = 2.01792065713155,
      ymin = -1.78820062530919, ymax = 2.6946093746908
    )
  ),
  preset_17 = list(
    name = "S17: LDAt ANA, IRC tasks (Dim 1:2)", x = "Dim2", y = "Dim1", lda = "lda_t.curr",
    granularity = "n17", filter_col = "Operator 17", filter_sym = "Curricular task",
    ellipses = TRUE, focus_t.curr = c("analysis", "int.reading"), focus_genre = c(
      "describing", "entertaining", "explaining",
      "inquiring", "persuading", "recounting", "responding"
    ), focus_grade = c(
      "10",
      "11", "12"
    ), transitions = FALSE, pointsize = 5L, show_OPERATOR.17 = c(
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
    ), viewport = list(
      xmin = -2.34627195695455, xmax = 2.13653570516825, ymin = -1.81674989983694,
      ymax = 2.66605776228586
    )
  ),
  preset_18 = list(
    name = "S18: LDAt sonnet paraphrase, story (Dim 1:2)", x = "Dim2",
    y = "Dim1", lda = "pca", granularity = "n17", filter_col = "Operator 17",
    filter_sym = "Curricular task", ellipses = TRUE, focus_t.curr = c(
      "analysis",
      "argumentative", "creative", "int.reading", "mediation"
    ),
    focus_genre = c(
      "describing", "entertaining", "explaining",
      "inquiring", "persuading", "recounting", "responding"
    ), focus_grade = c(
      "10",
      "11", "12"
    ), transitions = FALSE, pointsize = 5L, show_OPERATOR.17 = c(
      "sonnet_paraphrase",
      "story"
    ), viewport = list(
      xmin = -4.51859556639462, xmax = 4.44702443360537,
      ymin = -4.31139192600871, ymax = 4.65422807399129
    )
  )
)
