## input for Shiny App

# all types

types.grade <- c("EF", "Q1", "Q2")
types.t.curr <- c("analysis", "argumentative", "creative", "int.reading", "mediation")
types.operator.14 <- c(
  "summarize", "analyze", "comment", "magazine", "e-mail_informal", "describe",
  "letter_formal", "diary", "dialogue", "characterize", "story", "monologue",
  "speech", "paraphrase_sonnet"
)
types.operator.25 <- c(
  "summarize", "analyze", "comment", "magazine", "outline", "e-mail_informal",
  "letter_informal", "describe", "letter_formal", "diary", "blog", "dialogue",
  "discuss", "characterize", "point_out", "story", "monologue", "speech", "assess",
  "news", "explain", "report", "soliloquy", "present", "paraphrase_sonnet"
)

# all labels

labels.grade <- c("EF", "Q1", "Q2")
labels.t.curr <- c("Analysis", "Argumentative Writing", "Creative Writing", "Integrated Reading Comprehension", "Mediation")
labels.t.curr.short <- c("Analysis", "Argumentative", "Creative", "Integrated Read. Comp.", "Mediation")
labels.operator.14 <- c(
  "Summary", "Analysis", "Comment", "Magazine", "Informal E-Mail", "Description",
  "Formal Letter", "Diary Entry", "Dialogue", "Characterization", "Story", "Monologue",
  "Speech", "Sonnet Paraphrase"
)
labels.operator.25 <- c(
  "Summary", "Analysis", "Comment", "Magazine", "Outline", "Informal E-Mail",
  "Informal Letter", "Description", "Formal Letter", "Diary Entry", "Blog Entry", "Dialogue",
  "Discussion", "Characterization", "Point out", "Story", "Monologue", "Speech", "Assessment",
  "News", "Explanation", "Report", "Soliloquy", "Presentation", "Sonnet Paraphrase"
)


# dim2label mapping has been loaded from "data.rda" # Steph

dim_label <- c(
  "LD1" = "School Dimension 1",
  "LD2" = "School Dimension 2",
  "LD3" = "School Dimension 3",
  "LD4" = "School Dimension 4"
)
dim_label_short <- c(
  "LD1" = "Dim 1: School Dim. 1", # short labels for some plots
  "LD2" = "Dim 2: School Dim. 2",
  "LD3" = "Dim 3: School Dim. 3",
  "LD4" = "Dim 4: School Dim. 4"
)

label_dim <- inverse.map(dim_label)
label_dim_short <- inverse.map(dim_label_short) # shorter labels

label_cat.14 <- mk.map(labels.operator.14, types.operator.14)
cat_label.14 <- inverse.map(label_cat.14)

label_cat.25 <- mk.map(labels.operator.25, types.operator.25)
cat_label.25 <- inverse.map(label_cat.25)

label_t.curr <- mk.map(labels.t.curr, types.t.curr)
cat_label_t.curr <- inverse.map(label_t.curr)


# Data replacing data.rda #Stephanie

c5.vec <- structure(c5, names = types.t.curr)
c14.vec <- structure(c14interactive, names = types.operator.14)
c25.vec <- structure(c25, names = types.operator.25)

symbols.vec.grade <- structure(qw("circle triangle square"), names = types.grade)
symbols.vec.t.curr <- structure(qw("circle triangle square diamond cross"), names = types.t.curr)




#
# dim2label <- c(dim2label[1:4],
#                Orig1="Original LDA dim 1", Orig2="Original LDA dim 2")
# dim2label2 <- c(dim2label2[1:4],
#                 Orig1="Original LDA dim 1", Orig2="Original LDA dim 2")
# Dimensions <- cbind(ByType4.P, lda.type.P[, 1:2])
# colnames(Dimensions)[5:6] <- c("Orig1", "Orig2")
# Dimensions32 <- cbind(ByType32.P, lda.type32.P[, 1:2])
# colnames(Dimensions32)[5:6] <- c("Orig1", "Orig2")


# colors

c4_corp <- c(
  "#00559f", "#cc071e", "#57ab27", "#f6a800"
)

c5_corp <- c(
  "#57ab27", "#cc071e", "#612158", "#00559f", "#f6a800"
)

c5grey <- c(
  "#494848", "#636363", "#909090", "#B4B4B4", "#D4D4D4"
)

c14corp <- c(
  "#00559f", "#c7ddf2", "#006265", "#0099a1", "#57ab27", "#ddebce", "#bdcd00",
  "#f6a800", "#cc071e", "#f3cdbb", "#612158", "#7a6fac", "#dedaeb", "#000000"
)

c14 <- c(
  "blue1", "#E31A1C", "green4", "green1", "gold1", "#6A3D9A", "#FF7F00", "black",
  "gray70", "orchid1", "darkturquoise", "brown", "steelblue4", "#FB9A99"
)

c14interactive <- c(
  "#4363d8", "#cc071e", "#3cb44b", "#469990", "#911eb4", "#000000", "#f032e6",
  "#f58231", "#9a6324", "#000075", "#FF007F", "#808000", "#42d4f4", "#a11035"
)

c14palette <- c(
  "#fe0000", "#800001", "#ffd800", "#fe6a00", "#803400", "#806b00", "#00fe21",
  "#000000", "#007f0e", "#08E8DE", "#b100fe", "#590080", "#A2AAB5", "#183EFA"
)

c25 <- c(
  "dodgerblue2", "#E31A1C", "green4", "#6A3D9A", "#FF7F00", "black", "gold1",
  "skyblue2", "#FB9A99", "palegreen2", "#CAB2D6", "#FDBF6F", "gray70", "khaki2",
  "maroon", "orchid1", "deeppink1", "blue1", "steelblue4", "darkturquoise",
  "green1", "yellow4", "yellow3", "darkorange4", "brown"
)


# Shiny Weights

save(ZLC, MetaC, Dimensions_14, Dimensions_25, weights, feature.names.tp,
  c5.vec, c14.vec, c25.vec, dim_label, dim_label_short, label_dim, label_dim_short,
  # types.short32, types.short20, types.short12,
  types.operator.14, types.operator.25, types.grade, types.t.curr,
  labels.grade, labels.operator.14, labels.operator.25, labels.t.curr, labels.t.curr.short,
  label_cat.14, cat_label.14, label_cat.25, cat_label.25,
  symbols.vec.grade, symbols.vec.t.curr, label_t.curr, cat_label_t.curr,
  file = "data.rda"
)

# Shiny Scatter

save(ByType4.df, ByType32.df, dim2label, dim2label2,
  symbols.vec, rainbow32.vec, rainbow20.vec, rainbow12.vec,
  types.variety, types.mode,
  types.short32, types.short20, types.short12,
  types.textcat32, types.textcat20, types.textcat12,
  file = "shiny/NeumannEvert2021_scatterplot/data.rda"
)
