Presets <- list(
  preset_1 = list(
    name = "S1: Default PCA", x = "PC2", y = "PC1", lda = "pca",
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
    name = "S2: PCA focus analysis, description, comment, letter and e-mail",
    x = "PC2", y = "PC1", lda = "pca", granularity = "n17", filter_col = "Operator 17",
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
    name = "S3: Creative task PCA", x = "PC2", y = "PC1", lda = "pca",
    granularity = "n17", filter_col = "Operator 17", filter_sym = "Genre",
    ellipses = TRUE, focus_t.curr = "creative", focus_genre = c(
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
      xmin = -4.55523, xmax = 4.54193, ymin = -5.58795, ymax = 3.50921
    )
  ),
  preset_4 = list(
    name = "S4: PCA broadcast texts", x = "PC2", y = "PC1",
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
    name = "S5: PCA descriptions and informal e-mails", x = "PC2",
    y = "PC1", lda = "pca", granularity = "n17", filter_col = "Operator 17",
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
  )
)
