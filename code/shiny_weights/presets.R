Presets <-
  list(
    W1 = list(
      name = "Preset W1",
      lda = "lda20", dim = "LD1",
      y = "contribution",
      granularity = "n20",
      focus_variety = "all",
      show_textcat20 = c("conversations/phonecalls", "news reports")
    ),
    W2 = list(
      name = "Preset W2",
      lda = "lda20", dim = "LD1",
      y = "contribution",
      granularity = "n20",
      focus_variety = "all",
      show_textcat20 = c(
        "conversations/phonecalls",
        "academic writing",
        "popular-scientific writing",
        "news reports",
        "press editorials"
      )
    ),
    W2a = list(
      name = "Preset W2a",
      lda = "lda20",
      dim = "LD1",
      y = "contribution",
      granularity = "n20",
      focus_variety = "all",
      show_textcat20 = c(
        "parliamentary debates",
        "scripted monologues",
        "academic writing",
        "popular-scientific writing",
        "news reports",
        "press editorials"
      )
    ),
    W3 = list(
      name = "Preset W3",
      lda = "lda20",
      dim = "LD2", y = "contribution", granularity = "n20", focus_variety = "all",
      show_textcat20 = c("unscripted monologues", "social letters")
    ), W4 = list(
      name = "Preset W4", lda = "lda20", dim = "LD2",
      y = "contribution", granularity = "n20", focus_variety = "all",
      show_textcat20 = c(
        "conversations/phonecalls", "unscripted monologues",
        "social letters", "creative writing"
      )
    ), W5 = list(
      name = "Preset W5",
      lda = "lda20", dim = "LD3", y = "contribution", granularity = "n20",
      focus_variety = "all", show_textcat20 = c(
        "news reports",
        "administrative writing"
      )
    ), W6 = list(
      name = "Preset W6",
      lda = "lda20", dim = "LD3", y = "contribution", granularity = "n20",
      focus_variety = "all", show_textcat20 = c(
        "business letters",
        "administrative writing", "skills and hobbies"
      )
    ), W7 = list(
      name = "Preset W7", lda = "lda20", dim = "LD4", y = "contribution",
      granularity = "n20", focus_variety = "all", show_textcat20 = c(
        "unscripted monologues",
        "business letters"
      )
    ), W8 = list(
      name = "Preset W8", lda = "lda20",
      dim = "LD4", y = "contribution", granularity = "n20", focus_variety = "all",
      show_textcat20 = c(
        "conversations/phonecalls", "legal cross-examinations",
        "unscripted monologues", "business letters"
      )
    ), W9 = list(
      name = "Preset W9", lda = "lda20", dim = "LD1", y = "contribution",
      granularity = "n20", focus_variety = "NZ", show_textcat20 = c(
        "conversations/phonecalls",
        "news reports"
      )
    ), W10 = list(
      name = "Preset W10", lda = "lda20",
      dim = "LD1", y = "contribution", granularity = "n20", focus_variety = "JA",
      show_textcat20 = c("conversations/phonecalls", "news reports")
    ), W11 = list(
      name = "Preset W11", lda = "lda20", dim = "LD1",
      y = "contribution", granularity = "n20", focus_variety = "HK",
      show_textcat20 = c("conversations/phonecalls", "news reports")
    ), W12 = list(
      name = "Preset W12", lda = "lda20", dim = "LD2",
      y = "contribution", granularity = "n20", focus_variety = "NZ",
      show_textcat20 = c("unscripted monologues", "social letters")
    ), W13 = list(
      name = "Preset W13", lda = "lda20", dim = "LD2",
      y = "contribution", granularity = "n20", focus_variety = "JA",
      show_textcat20 = c("unscripted monologues", "social letters")
    ), W14 = list(
      name = "Preset W14", lda = "lda20", dim = "LD2",
      y = "contribution", granularity = "n20", focus_variety = "HK",
      show_textcat20 = c("unscripted monologues", "social letters")
    ), W15 = list(
      name = "Preset W15", lda = "lda20", dim = "LD3",
      y = "contribution", granularity = "n20", focus_variety = "NZ",
      show_textcat20 = c("news reports", "administrative writing")
    ), W17 = list(
      name = "Preset W17", lda = "lda20", dim = "LD3",
      y = "contribution", granularity = "n20", focus_variety = "HK",
      show_textcat20 = c("news reports", "administrative writing")
    ), W18 = list(
      name = "Preset W18", lda = "lda20", dim = "LD4",
      y = "contribution", granularity = "n20", focus_variety = "NZ",
      show_textcat20 = c("unscripted monologues", "business letters")
    ), W19 = list(
      name = "Preset W19", lda = "lda20", dim = "LD4",
      y = "contribution", granularity = "n20", focus_variety = "JA",
      show_textcat20 = c("unscripted monologues", "business letters")
    ), W20 = list(
      name = "Preset W20", lda = "lda20", dim = "LD4",
      y = "contribution", granularity = "n20", focus_variety = "HK",
      show_textcat20 = c("unscripted monologues", "business letters")
    ), W21 = list(
      name = "Preset W21", lda = "lda20", dim = "LD1",
      y = "contribution", granularity = "n20", focus_variety = "all",
      show_textcat20 = c(
        "student writing", "academic writing",
        "popular-scientific writing", "news reports", "administrative writing",
        "press editorials"
      )
    ), W22 = list(
      name = "Preset W22", lda = "lda20",
      dim = "LD2", y = "contribution", granularity = "n20", focus_variety = "all",
      show_textcat20 = c(
        "student writing", "academic writing",
        "popular-scientific writing", "news reports", "administrative writing",
        "press editorials"
      )
    ), W23 = list(
      name = "Preset W23", lda = "lda20",
      dim = "LD3", y = "contribution", granularity = "n20", focus_variety = "all",
      show_textcat20 = c(
        "conversations/phonecalls", "classroom lessons",
        "broadcast interactions", "business transactions", "demonstrations"
      )
    ), W24 = list(
      name = "Preset W24", lda = "lda20", dim = "LD3",
      y = "contribution", granularity = "n20", focus_variety = "all",
      show_textcat20 = c(
        "conversations/phonecalls", "classroom lessons",
        "broadcast interactions", "business transactions", "demonstrations",
        "business letters", "administrative writing", "skills and hobbies"
      )
    ),
    W25 = list(
      name = "Preset W25",
      lda = "lda20",
      dim = "LD2",
      y = "contribution",
      granularity = "n20",
      focus_variety = "all",
      show_textcat20 = c(
        "broadcast interactions",
        "unscripted monologues"
      )
    ),
    W26 = list(
      name = "Preset W26",
      lda = "lda20", dim = "LD4",
      y = "contribution",
      granularity = "n20",
      focus_variety = "all",
      show_textcat20 = c(
        "unscripted monologues",
        "skills and hobbies"
      )
    )
  )
