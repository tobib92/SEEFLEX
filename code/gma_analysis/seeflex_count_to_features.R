## Template for converting per-text counts to features (relative frequencies)
## (C) 2021 Stefan Evert

#### Set working directory to the SEEFLEX root folder ####

## read all tables tbl/*.tsv with per-text frequency counts
# filenames <- sort(Sys.glob("data/gma/*.tsv"))
filenames <- "data/gma/20250409_seeflex_orig.tsv"
if (!length(filenames)) stop("No files matching tbl/*.tsv found. Aborted.")
SEEFLEX.list <- lapply(filenames, function (fn) read.delim(
  fn, check.names=FALSE, stringsAsFactors=FALSE))
SEEFLEX <- do.call(rbind, SEEFLEX.list)

## check correct format
stopifnot(!any(duplicated(SEEFLEX$id)))         # IDs must be unique
stopifnot(all(sapply(SEEFLEX[-1], is.numeric))) # all columns must be numeric

## compute features
Features <- with(SEEFLEX,
  data.frame(
    id = id,
    sent = n_sent,
    token = n_token,
    word = n_word,
    word_S = n_word / n_sent,
    lexd = ld / n_word,
    nn_W = nn / n_word,
    np_W = np / n_word,
    nom_W = nom / n_word,
    neo_W = neo / n_word,
    pall_W = pall / n_word,
    pposs_W = pposs / n_word,
    prefx_W = prefx / n_word,
    ppers1_P = ppers1 / pall,
    ppers2_P = ppers2 / pall,
    ppers3_P = ppers3 / pall,
    pit_P = pit / pall,
    # p1_pall_W = pron1 / n_word,         # Deselected for high correlation
    # p2_pall_W = pron2 / n_word,         # Deselected for high correlation
    # p3_pall_W = pron3 / n_word,         # Deselected for high correlation
    adj_W = adj / n_word,                 # Three co-linear features,
    atadj_W = atadj / n_word,             # must select two of them
    # predadj_W = (adj - atadj) / n_word,   # in data preparation
    prep_W = prep / n_word,
    fin_S = fin / n_sent,
    past_F = past / fin,
    will_F = will / fin,
    inf_F = inf / fin,
    pass_F = pass / fin,
    modal_V = vm / v,
    verb_W = v / n_word,
    coord_F = coord / fin,
    subord_F = subord / fin,
    interr_S = interr / n_sent,
    imper_S = imper / n_sent,
    title_W = title / n_word,
    # salute_S = salut / n_sent,              # 3 co-linear features, must select
    # greet_S = greet / n_sent,               # either individual or combined
    salutgreet_S = salutgreet / n_sent,       # version in data preparation
    adv_place_W = rl / n_word,
    adv_time_W = rt / n_word,
    # ttex_cont_S = textual_theme_cont / n_sent, # 3 co-linear features, must select
    ttex_conj_S = textual_theme_conj / n_sent, # either individual or combined
    # ttex_S = textual_theme / n_sent,           # version in data preparation
    ttex_disc_S = textual_theme_disc / n_sent, # co-linear with textual_theme_cont
    tint_S = interpersonal_theme / n_sent, # co-linear with textual_theme_cont
    ttop_adv_S = advtheme / n_sent,
    ttop_nom_S = nptheme / n_sent,
    ttop_prep_S = pptheme / n_sent,
    ttop_wh_S = whtheme / n_sent,
    ttop_nonfin_S = infcltheme / n_sent,  # 3 co-linear features, must select
    ttop_subcl_S = subcltheme / n_sent,   # either individual or combined
    # ttop_subord_S = subordtheme / n_sent, # version in data preparation
    ttop_interr_S = interrotheme / n_sent,
    ttop_verb_S = verbtheme / n_sent,
    stringsAsFactors=FALSE
  )
)

## check for value errors
idx <- apply(as.matrix(Features[, -1]), 1, function (x) any(is.na(x)))
if (any(idx)) {
  cat(sprintf("Warning: %d rows have invalid features\n", sum(idx)))
  print(Features[idx, , drop=FALSE], digits=3)
  cat("Setting invalid feature scores to zero ...\n")
  na.zero <- function (x) { if (is.numeric(x)) x[is.na(x)] <- 0; x }
  Features <- as.data.frame(lapply(Features, na.zero), stringsAsFactors=FALSE)
}

##### Save complete feature matrix in .tsv format #####

corpus_version <- "orig" # Change this string if needed
output_filename <- paste0("data/gma/", format(Sys.Date(), "%Y%m%d"),
                          "_seeflex_", corpus_version, "_features.tsv")

write.table(Features, file = output_filename, quote = FALSE,
            sep = "\t", row.names = FALSE, col.names = TRUE)
