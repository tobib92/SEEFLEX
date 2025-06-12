##
## boxplots of feature distributions grouped by user-specified categories
##
##  - M = text-feature matrix
##  - Meta = metadata for texts, a data frame corresponding to the rows of M
##  - what = "features" (original features), "weighted" (weighted by abs(weights)), "contribution" (contribution to axis scores)
##  - weights = feature weights (for feature contribution to axis scores)
##  - group = make side-by-side boxplots for levels of this factor (evaluated in environment Meta)
##  - group.palette = colour palette for this grouping (must be aligned with levels(group))
##  - subset = work on subset of texts (evaluated in environment Meta)
##  - select = display boxplots for a subset of features (matched against colnames(M))
##  - feature.names = feature names (to override colnames(M))
##  - id.var = variable specifying unique text ID in Meta
##  - nrow = number of rows for arrangement of boxplot facets
##  - bw = if TRUE, produce a b/w version of the plot
##  - base_size = basic font size for the plot (see ggplot documentation)
##  - diamond.size = size of diamonds indicating group means
##  - group.labels = whether to show group labels on x-axis ticks
##  - ylim = display range on y-axis (NULL or two-element vector)
## returns a ggplot object that has to be printed to display the graph

ggbox.features <- function(M, Meta, what = c("features", "weighted", "contribution"),
                           weights = rep(1, ncol(M)), group = NULL, group.palette = NULL,
                           subset = NULL, select = NULL, feature.names = NULL, id.var = "id",
                           main = NULL, nrow = 2, bw = FALSE, base_size = 12,
                           diamond.size = 2.5, group.labels = TRUE, ylim = NULL, group.var = NULL) {
  n <- nrow(M)
  k <- ncol(M)
  stopifnot(nrow(Meta) == n)
  what <- match.arg(what)
  if (is.null(feature.names)) {
    feature.names <- colnames(M)
    stopifnot(!is.null(feature.names))
  } else {
    stopifnot(length(feature.names) == k)
    colnames(M) <- feature.names
  }
  names(weights) <- feature.names

  subset <- eval(substitute(subset), Meta, parent.frame())
  if (!is.null(subset)) {
    M <- M[subset, , drop = FALSE]
    Meta <- Meta[subset, ]
    n <- nrow(M)
  }
  if (!is.null(select)) {
    M <- M[, select]
    feature.names <- colnames(M)
    weights <- weights[feature.names]
  }

  if (what == "contribution") {
    M <- scaleMargins(M, cols = weights)
    colnames(M) <- ifelse(weights < 0, paste("(\U{2013})", feature.names), feature.names)
  } else if (what == "weighted") {
    M <- scaleMargins(M, cols = abs(weights))
  }

  group <- eval(substitute(group), Meta, parent.frame())
  if (is.null(group)) group <- rep("all texts", n)
  table.wide <- data.frame(id = Meta[[id.var]], group = group)
  table.wide <- cbind(table.wide, M)
  table.long <- reshape2::melt(table.wide, id = c("id", "group"))

  #### output print statements ####
  ## Check individual weights values by writing output to a file
  write.csv(table.long, "output_file.csv", row.names = FALSE)
  filtered_data <- as.data.frame(table.long)

  # Filter out 'other'
  filtered_data <- filtered_data %>%
    dplyr::filter(group != "other")

  # Create summary values
  nrow_filtered <- paste("n_ids:", nrow(filtered_data))
  ngroup_filtered <- paste("n_groups:", length(unique(filtered_data$group)))
  nvar_filtered <- paste("n_var:", length(unique(filtered_data$variable)))
  sum_filtered <- paste("sum:", sum(filtered_data$value))
  mean_filtered <- paste("mean:", mean(filtered_data$value))
  weights_filtered <- paste(
      names(weights), round(weights, digits = 3), sep = " ", collapse = ", ")


  # # Create print df
  # print_data <- filtered_data %>%
  #   dplyr::mutate(value = as.character(value)) %>%
  #   tibble::add_row(
  #     id = nrow_filtered,
  #     group = ngroup_filtered,
  #     variable = nvar_filtered,
  #     value = sum_filtered,
  #     .before = 1
  #     ) %>%
  #   tibble::add_row(
  #     id = "SUMMARY:",
  #     group = "_______",
  #     variable = "_______",
  #     value = mean_filtered,
  #     .after = 1
  #   )
  # options(max.print=10000)
  # print("SUMMARY DF OF SELECTIONS IN FEATURE WEIGHTS APP:")
  # print(paste("Current selected weights:", weights_filtered))
  # print(print_data)

  bp <- ggplot(table.long, aes(x = group, y = value, colour = group)) +
    facet_wrap(~variable, nrow = nrow, scales = "free_x")
  bp <- bp +
    geom_boxplot(notch = FALSE, lwd = .6, outlier.shape = 18, outlier.colour = "#666666") +
    stat_summary(fun = "mean", geom = "point", shape = 23, fill = "white", size = diamond.size) +
    theme_bw(base_size = base_size) +
    geom_hline(yintercept = 0, color = "#666666", linetype = "dashed") +
    theme(strip.text.x = element_text(angle = 90, hjust = 0),
          legend.key.width = unit(0.5, "cm"), legend.box =
          ) +
    ggtitle(main) + xlab("") + labs(color = ifelse(!is.null(group.var), group.var, "group")) +
    ylab(switch(what,
      features = "feature values",
      weighted = "weighted feature values",
      contribution = "contribution to axis scores"
    ))
  bp <- bp + if (group.labels) theme(axis.text.x = element_text(angle = 60, hjust = 1)) else theme(axis.text.x = element_blank())
  if (!is.null(group.palette)) {
    bp <- bp + scale_colour_manual(values = group.palette)
  } else if (bw) {
    bp <- bp + scale_colour_grey(start = 0, end = .6)
  }
  if (!is.null(ylim)) bp <- bp + lims(y = ylim)
  bp
}

scaleMargins <- function(M, cols) {
  d <- ncol(M)
  stopifnot(length(cols) == d)
  structure(M %*% diag(cols, nrow = d, ncol = d),
    dimnames = dimnames(M)
  )
}

## Wrapper to display side-by-side boxplots for selected text categories <cats>
## from variable <variable>, with colour scheme <colours>.
## All other arguments are passed through to ggbox.features() and documented above.

ggbox.selected <- function(M, Meta, weights, cats, variable,
                           colours, what = "contribution",
                           main = "", group.labels = FALSE, ...) {
  # Input Validation
  Meta[[variable]] <- factor(Meta[[variable]])
  stopifnot(
    all(cats %in% names(colours)),
    all(cats %in% levels(Meta[[variable]]))
  )

  # Create a vector based on the values in Meta under this variable
  group.vec <- as.character(Meta[[variable]])
  # Replace all values not found in the cats variable with "other"
  Meta$grouping <- factor(ifelse(group.vec %in% cats, group.vec, "other"),
    levels = c("other", cats)
  )

  # Create a vector of color values to use in the plot
  col.values <- c("#666666", colours[cats])

  ggbox.features(M, Meta,
    what = what,
    weights = weights, id.var = "id", # Steph id.var = "file"
    group = grouping, group.palette = col.values, # Where is "grouping" defined?
    main = main, group.labels = group.labels, ...
  ) +
    theme(strip.text.x = element_text(angle = 70, hjust = 0.2, vjust = 0.2))
}

##
## density plot for projection into single dimension (typically a linear discriminant)
##
##  - M = text-feature matrix
##  - discriminant = dimension vector for linear discriminant
##  - categories = a factor of text categories for each row of M
##  - col.vals = vector of colours for category densities (lookup by name if possible)
##  - lwd.vals, lty.vals = additional line style (name lookup not yet implemented)
discriminant.plot <- function(M, discriminant, categories, col.vals = palette(), lwd.vals = 4, lty.vals = "solid",
                              bw.adjust = .7, bw = "SJ", freq = FALSE, rug = FALSE, bottomline = TRUE, idx = NULL,
                              xlab = "discriminant score", ylab = "density", legend.cex = 1, legend.colsize = 8,
                              y.max = NULL, xlim = NULL, ...) {
  categories <- as.factor(categories)
  stopifnot(length(categories) == nrow(M))
  scores <- drop(M %*% discriminant) # vector of discriminant scores
  M.rownames <- rownames(M)
  if (is.null(xlim)) xlim <- range(scores)
  if (!is.null(idx)) {
    scores <- scores[idx]
    categories <- droplevels(categories[idx])
    M.rownames <- M.rownames[idx]
  }
  levels <- levels(categories)
  n.levels <- length(levels)
  if (length(col.vals) == 1) col.vals <- rep(col.vals, n.levels) # recycle single style value as often as needed
  if (length(lwd.vals) == 1) lwd.vals <- rep(lwd.vals, n.levels)
  if (length(lty.vals) == 1) lty.vals <- rep(lty.vals, n.levels)
  if (n.levels > min(length(col.vals), length(lwd.vals), length(lty.vals))) stop("too many different categories")

  if (!is.null(names(col.vals))) {
    stopifnot(all(levels %in% names(col.vals))) # look up colors by category name
    col.vals <- col.vals[levels]
  }
  ## should do the same for lwd.vals and lty.vals, but we don't need this yet

  densities <- lapply(levels, function(l) {
    res <- density(scores[categories == l], from = xlim[1], to = xlim[2], n = 512, bw = bw, adjust = bw.adjust)
    res$points <- scores[categories == l] # for rug plots
    if (freq) res$y <- res$y * sum(categories == l)
    res
  })
  if (is.null(y.max)) y.max <- do.call(max, lapply(densities, function(d) d$y))
  plot(0, 0, type = "n", xlim = xlim, ylim = c(0, y.max), xlab = xlab, ylab = ylab, ...)
  for (i in 1:n.levels) {
    d <- densities[[i]]
    lines(d, col = col.vals[i], lwd = lwd.vals[i], lty = lty.vals[i])
    if (rug) rug(d$points, col = col.vals[i])
  }
  if (bottomline) abline(h = 0, lwd = 4, col = "#666666")

  legend("topright",
    inset = .02, legend = levels,
    col = col.vals[1:n.levels], lwd = lwd.vals[1:n.levels], lty = lty.vals[1:n.levels],
    cex = legend.cex, ncol = ceiling(n.levels / legend.colsize), bg = "white"
  )

  names(scores) <- M.rownames
  invisible(scores) # return vector of discriminant scores
}
