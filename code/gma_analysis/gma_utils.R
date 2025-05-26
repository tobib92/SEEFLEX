##
## SIGIL Unit 7:
## Support functions for multivariate analysis
##

library(corpora)   # requires corpora >= 0.5
library(wordspace) # requires wordspace >= 0.2
library(ggplot2)   # for ggbar.weights() and ggbox.features
library(reshape2)  # (same)
library(MASS)      # for LDA discriminants
if (!require("rgl", quietly=TRUE)) warning("gma.3d() and associated functions will not work without the 'rgl' package")

##
## small utility functions
##

## signed logarithmic transformation that is smooth at 0
signed.log <- function (x, base=exp(1)) {
  sign(x) * log(1 + abs(x), base=base)
}

## check whether argument is a single NA (as argument default value)
isNA <- function (x) {
  !is.null(x) && length(x) == 1 && is.na(x)
}

## sort column vector, keeping rownames; a plain vector is coerced to a column vector first
sort.column <- function (x, decreasing=FALSE) {
  if (is.vector(x)) x <- colVector(x)
  stopifnot(ncol(x) == 1)
  idx <- order(x, decreasing=decreasing)
  x[idx, ]
}

## jitter factor variable by randomly shuffling a certain percentage of entries
jitter.factor <- function (x, amount=.05) {
  n <- length(x)
  k <- floor(amount * n)
  stopifnot(k >= 2)
  idx <- sample(1:n, k)    # k items to be shuffled
  x[idx] <- sample(x[idx]) # swapped into random order
  x
}

## expand range of values by a specificed fraction on either side (for plots)
expand.range <- function(x, by=.2) {
  rg <- range(x)
  rg + diff(rg) * by * c(-1, 1)
}

## unit vector for k-th axis in n-dimensional Euclidean space
axis.vector <- function (n, k, column=!byrow, byrow=FALSE) {
  v <- rep(0, n)
  v[k] <- 1
  if (column) matrix(v, n, 1) else matrix(v, 1, n)
}

## Gram-Schmidt orthogonalization (by QR decomposition)
orthogonalize <- function (M, fail=TRUE) {
  stopifnot(is.matrix(M))
  d <- ncol(M) # dimensionality of basis
  res <- qr(M)
  if (res$rank < d) {
    if (fail) stop("vectors to be orthogonalized do not have full rank (not a basis)")
    return(NULL)
  }
  Q <- qr.Q(res) # orthogonal basis
  sign.adj <- sign(colSums(M * Q)) # 1 if orthogonal vector has same orientation as corresponding input vector
  scaleMargins(Q, cols=sign.adj)   # so orthogonal vectors are projections of original basis vectors
}

## Cohen's d (scale-adjusted effect size of t-test)
##  - if conf.level is specified, returns confidence interval derived from t-test (ignoring uncertainty of the denominator)
##  - NB corrected to direction mean(x) - mean(y), in order to be compatible with t.test()
cohen.d <- function (x, y, conf.level=NULL) {
  nx <- length(x)
  ny <- length(y)
  s2 <- ((nx-1) * var(x) + (ny-1) * var(y)) / (nx + ny - 2) # within-group variance
  if (is.null(conf.level)) (mean(x) - mean(y)) / sqrt(s2) else t.test(x, y, conf.level=conf.level)$conf.int / sqrt(s2)
}


## simple version of a parallel coordinates plot with feature weighting and cluster-based colours
##  - M = row matrix of feature vectors to be visualized
##  - weights = (optional) weightings for the columns of M
##  - idx = (optional) display only selected rows of M
##  - feature.names = feature names shown on x-axis (defaults to colnames(M))
##  - n = number of features to plot (default: all features)
##  - clusters = number of clusters for colouring the profiles
##  - lwd, alpha, ylim, ylab, main ... the usual graphics parameters
parcoord.plot <- function (M, weights=NULL, idx=NULL, feature.names=NULL, n=ncol(M), lwd=.5, alpha=.5, clusters=5, ylim=NULL, ylab="z-score", main="") {
  if (is.null(weights)) weights <- rep(1, ncol(M))
  if (is.null(idx)) idx <- 1:nrow(M)
  if (is.null(feature.names)) feature.names <- colnames(M)
  n <- min(ncol(M), n)
  stopifnot(length(weights) == ncol(M))
  stopifnot(length(feature.names) == ncol(M))
  M <- M[idx, , drop=FALSE]
  cluster.id <- pam(dist.matrix(M, method="euclidean"), diss=TRUE, k=clusters)$clustering
  M <- scaleMargins(M, cols=weights)
  if (is.null(ylim)) ylim <- range(M[, 1:n])
  plot(0, 0, type="n", xlim=c(1, n), ylim=ylim, axes=FALSE, xlab="", ylab=ylab, main=main)
  abline(h=seq(floor(ylim[1]), ceiling(ylim[2]), .5), col="grey70")
  abline(h=0, col="grey50", lwd=2)
  matplot(1:n, t(M[, 1:n, drop=FALSE]), type="l", col=alpha(ten.colors, alpha)[cluster.id], lty="solid", lwd=lwd, add=TRUE)
  axis(1, at=1:n, labels=feature.names[1:n], las=2)
  axis(2)
}


##
## GMA: a class for orthogonal subspace projections
##
GMA <- setRefClass("GMA", fields = list(
  P = "matrix",     # orthonormal basis of subspace (column vectors)
  Q = "matrix",     # orthonormal basis of complement space (column vectors)
  axes = "matrix",  # basis spanning subspace, as specified by user (column vectors)
  data = "matrix",  # data matrix in original coordinates (row vectors)
  n = "integer",    # dimensionality of the space
  rotated = "logical" # whether rotation has been applied, invalidating user-specified basis
))

## Constructor for a GMA object
##  - M = data matrix M to be analysed, or alternatively:
##  - n.dim = dimensionality of space
##  - NB: GMA() creates a useless 0-dimensional GMA space, but doesn't raise error
GMA$methods(
  initialize = function (M=NULL, n.dim=0L, ...) {
    if (!is.null(M)) {
      if (!is.matrix(M)) stop("M must be a dense data matrix")
      if (n.dim != 0L && n.dim != ncol(M)) stop("n.dim inconsistent with data matrix M")
      n.dim <- ncol(M)
    }
    else {
      n.dim <- as.integer(n.dim)
      M <- diag(n.dim)
    }
    if (n.dim > 0L) {
      n <<- n.dim
      data <<- M
      P <<- axes <<- matrix(0, nrow=n.dim, ncol=0L)
      Q <<- prcomp(M, center=TRUE, scale=FALSE)$rotation
    }
    rotated <<- FALSE
    callSuper(...)
  })

## Print GMA object
GMA$methods(
  show = function () {
    "Show a brief description of the GMA object."
    k <- nrow(data)
    d1 <- ncol(P)
    cat(sprintf("GMA object representing projection of %d x %d data matrix into %d-dimensional subspace", k, n, d1))
    if (isTRUE(rotated)) cat(", with rotation")
    cat("\n")
  })

## Retrieve basis for subspace and/or complement
##   - space = select desired basis vectors
##       both       ... orthonormal basis of subspace + complement
##       space      ... orthonormal basis of subspace (default)
##       complement ... orthonormal basis of complement
##       axes       ... user-specified basis of subspace (need not be orthonormal)
##   - dim = return only these dimensions of the selected basis
GMA$methods(
  basis = function (space=c("space", "both", "complement", "axes"), dim=NULL) {
    "Retrieve basis for target subspace and/or complement."
    space <- match.arg(space)
    res <- switch(space,
                  "both" = cbind(P, Q),
                  "space" = P,
                  "complement" = Q,
                  "axes" = axes)
    if (!is.null(dim)) res[, dim, drop=FALSE] else res
  })

## Project data points into subspace and/or complement
##   - space = select target space / type of projection
##       both       ... transform into orthonormal basis of subspace + complement
##       space      ... orthogonal projection into subspace (default)
##       complement ... orthogonal projection into complement space
##       axes       ... subspace coordinates in user-specified basis
##   - dim = return only these dimensions of the selected basis
##   - M = data matrix of row vectors to project (defaults to internal data matrix)
##   - byrow=FALSE if M is a matrix of column vectors
GMA$methods(
  projection = function (space=c("space", "both", "complement", "axes"), dim=NULL, M=NULL, byrow=TRUE) {
    "Project data points into subspace and/or complement."
    space <- match.arg(space)
    if (space == "axes") stop("space='axes' is not supported yet")
    if (is.null(M)) {
      M <- data
      if (!byrow) stop("byrow=FALSE not allowed for internal data matrix")
    } else {
      n. <- if (byrow) ncol(M) else nrow(M)
      if (n. != n) stop("dimensionality of specified data matrix M doesn't match GMA space")
    }
    P. <- basis(space, dim=dim) # orthonormal basis for the projection
    if (byrow) M %*% P. else crossprod(P., M)
  })

## Compute proportion of variance (R2) captured by subspace projection;
## return value is vector of R2 contributions (%) for each selected dimension
##   - M   = row matrix of data points (defaults to original data matrix)
##   - dim = vector of dimensions for which R2 is computed (defaults to full subspace)
GMA$methods(
  R2 = function (M=NULL, dim=NULL) {
    "Compute proportion of variance (R2) captured by subspace projection."
    if (is.null(M)) M <- data
    if (is.null(dim)) dim <- seq_len(ncol(P))
    M <- scale(M, center=TRUE, scale=FALSE) # center data set
    full.ss <- sum(M^2) # denominator (n-1) of variance is constant and can be ignored
    Mproj <- projection(space="both", M=M)
    Mproj <- Mproj[, dim, drop=FALSE] # select relevant dimensions
    if (ncol(Mproj) == 0L) return(0)
    partial.ss <- colSums(Mproj^2) # Mproj is also centered
    100 * partial.ss / full.ss
  })

## Add one or more basis dimensions to subspace
##   - basis = column matrix of basis vectors to be added
##             (single basis vector can be given as plain vector)
##   - space = orthonormal coordinate system for specified basis vectors
##             (orig=original dimensions, both=projected space + complement, complement=complement only)
##   - names = optional names for the additional dimensions
##   - normalize=TRUE ... normalize specified basis vectors to unit length
GMA$methods(
  add = function (basis, space=c("orig", "both", "complement"), names=colnames(basis), normalize=FALSE, tol=1e-7) {
    "Add one or more basis dimensions to subspace."
    space <- match.arg(space)
    if (is.vector(basis)) basis <- colVector(basis) # propagate vector to 1-column matrix
    d1 <- ncol(P)     # dimensionality of current subspace
    d2 <- ncol(basis) # number of basis vectors to be added
    nb <- nrow(basis) # dimensionality of basis vectors

    if (space == "complement") {
      if (nb != n - d1) stop(sprintf("basis vectors of length %d don't match %d-dimensional complement space", nb, n-d1))
      basis <- Q %*% basis  # transform into original space
    } else if (space == "both") {
      if (nb != n) stop(sprintf("basis vectors of length %d don't match %d-dimensional orthonormal space", nb, n))
      basis <- cbind(P, Q) %*% basis # transform into original space
    } else {
      if (nb != n) stop(sprintf("basis vectors of length %d don't match %d-dimensional original space", nb, n))
    }
    if (normalize) basis <- scaleMargins(basis, cols=1 / colNorms(basis, method="euclidean"))

    Pnew <- orthogonalize(cbind(P, basis)) # extend projection subspace
    if (ncol(Pnew) < d1 + d2) stop("basis vectors do not form a linearly independent extension of the current subspace")
    if (d1 > 0) {
      if (max(abs(Pnew[, seq_len(d1), drop=FALSE] - P)) > tol) stop("internal error -- QR decomposition does not preserve existing orthonormal basis")
    }
    if (!is.null(names)) {
      if (length(names) != d2) stop("length of names= doesn't match number of basis vectors")
      colnames(basis) <- names
    }
    axes <<- cbind(axes, basis) # extend list of original basis vectors
    colnames(Pnew) <- colnames(axes)
    P <<- Pnew # orthonormal basis of new subspace

    M <- data
    Mcomp <- M - M %*% tcrossprod(Pnew) # M * (I - P P') = projection of row matrix M into new complement space
    Qnew <- prcomp(Mcomp, center=TRUE, scale=FALSE)$rotation # PCA orthogonalization of complement space
    Qnew <- Qnew[, seq_len(n - d1 - d2), drop=FALSE]
    PQnew <- cbind(Pnew, Qnew)
    if (max(abs(crossprod(PQnew) - diag(n))) > tol) stop("internal error -- basis of subspace + complement is not orthonormal")
    Q <<- Qnew

    rownames(P) <<- rownames(Q) <<- rownames(axes) <<- colnames(data)
    invisible(.self)
  })

## **TODO** implement drop() method to remove basis dimensions
##   - NB: cannot drop user axes= after rotation (because they no longer match up with P)

## Apply rotation to (selected dimensions of) target subspace
##   - type= selects the rotation to be performed:
##      "pca":   performs a PCA on M= (or internal data) in the subspace and rotates the dimensions to principal components
##      "swap":  reorder dimensions according to the permutation in perm= (default: reverse order)
##      "flip":  reverse sign of selected dimensions
##      "match": reorder and flip dimensions to give best match to those in basis=
##  - dim = subset of the target subspace dimensions on which rotation will be performed
##          (since the dimensions are orthogonal, rotations on disjoint subsets are completely independent)
## CAVEAT: rotations invalidate the user-specified basis vectors ($axes), which are replaced with $P
##
## **TODO**
##  - improve "match" mode
##    - pick best matchng pair of dimensions basis[i] and P1[j], then insert in P1.new[i]
##    - remove basis[i] from basis and P1[j] from P1, then repeat until all dimensions have been matched
##  - implement "manual" rotation to user-specified dimensions
##    - must check they're in the subspace (or use subspace coordinates)
##    - orthogonalise if necessary
##    - complement with further orthogonal dimensions in the subspace
##      (needs a "robust" version of the orthogonalize() function)
##  - implement rotations from factor analysis (varimax(), packages GPArotation and psych)
##    - use same interface as factanal() rotations, so an arbitrary function can be supplied by user
##      (which means we must pass something that can be interpreted as a loadings matrix)
##    - only orthogonal rotations will be allowed, of course
GMA$methods(
  rotation = function (type=c("pca", "swap", "flip", "match"), dim=NULL, M=NULL, perm=NULL, basis=NULL) {
    "Apply rotation to (selected dimensions of) target subspace."
    type <- match.arg(type)
    k <- ncol(P) # dimensionality of target space
    if (k == 0L) stop("cannot apply rotation to empty target space")
    if (is.null(dim)) dim <- seq_len(k)
    stopifnot(length(dim) >= 1, all(1 <= dim & dim <= k), !any(duplicated(dim)))
    P1 <- P[, dim, drop=FALSE] # subspace for the rotation (of dimensionality d)
    d <- length(dim)
    if (type == "pca") {
      if (is.null(M)) M <- data
      M1 <- M %*% P1  # projection of M into rotation subspace
      R <- prcomp(M1)$rotation # PCA rotation in the subspace
      if (ncol(R) < d) stop(sprintf("M is singular in %d-dim subspace [%s], PCA returned only %d dimensions", d, paste(dims, collapse=", "), ncol(R)))
      P1.new <- P1 %*% R # principal components in original coordinate form new basis vectors
      ## sign matching against old basis vectors
      cos.mat <- crossprod(P1.new, P1) # find closest original dim to each new dim
      sign.vec <- apply(cos.mat, 1, function (x) if (x[which.max(abs(x))] < 0) -1 else 1) # flip sign if best match has opposite direction
      P1.new <- scaleMargins(P1.new, cols=sign.vec)
    }
    else if (type == "swap") {
      if (is.null(perm)) perm <- rev(seq_len(d))
      if (!all.equal(sort(perm), seq_len(d))) stop("perm= is not a suitable permutation of the selected dimensions")
      P1.new <- P1[, perm, drop=FALSE]
    }
    else if (type == "flip") {
      P1.new <- -P1
    }
    else if (type == "match") {
      if (is.null(basis)) stop("basis= must be specified for type='match'")
      stopifnot(ncol(basis) == d)
      stopifnot(nrow(basis) == nrow(P1))
      P1.new <- matrix(0, nrow=nrow(P1), ncol=d)
      for (i in seq_len(d)) {
        cos.vec <- crossprod(basis[, i, drop=FALSE], P1) # cosine between basis[i] and remaining P1
        j <- which.max(abs(cos.vec)) # find best match
        sign.adj <- if (cos.vec[j] < 0) -1 else 1
        P1.new[, i] <- sign.adj * P1[, j]
        P1 <- P1[, -j, drop=FALSE]
      }
    }
    else {
      stop("not yet implemented")
    }
    P[, dim] <<- P1.new
    axes <<- P # user-specified basis is invalidate, overwrite with orthonormal
    rotated <<- TRUE
    invisible(.self)
  })

## Apply operation in subspace coordinates and re-transform resulting vectors into original space
##   - M = data matrix of row or column vectors to be operated on
##   - FUN = function applied to projected data matrix (any additional arguments ... are passed to FUN)
##   - space = select desired subspace (space, complement, both), defaults to "space"
##   - dim = return only these dimensions of the selected subspace
##   - byrow.in = whether input (M) is a row or column matrix
##   - byrow.out = whether result of FUN is a row or column matrix
GMA$methods(
  subspace.apply = function (M, FUN, ..., space=c("space", "both", "complement"), dim=NULL, byrow.in=byrow, byrow.out=byrow, byrow=TRUE) {
    "Apply operation in subspace coordinates and re-transform resulting vectors into original space."
    space <- match.arg(space)
    n.in <- if (byrow.in) ncol(M) else nrow(M)
    if (n.in != n) stop("dimensionality of data matrix doesn't match GMA space")
    P. <- basis(space, dim)
    d <- ncol(P.)
    M1 <- if (byrow.in) M %*% P. else crossprod(P., M)
    res1 <- FUN(M1, ...)
    d.out <- if (byrow.out) ncol(res1) else nrow(res1)
    if (d.out != d) stop("dimensionality of result doesn't match subspace -- did you forget to set byrow.out?")
    if (byrow.out) tcrossprod(res1, P.) else P. %*% res1
  })

## Identify LDA dimensions in full space or specified subspace
##   - categories = vector of categories to be separated by LDA (must match rows of M)
##   - M = data matrix of row vectors (defaults to internal data matrix)
##   - space = select desired subspace (space, complement, both), defaults to "both"
##   - dim = use only these dimensions of the selected subspace
##   - idx = perform LDA on subset of M
GMA$methods(
  discriminant = function (categories, M=NULL, space=c("both", "complement", "space"), dim=NULL, idx=NULL) {
    "Identify LDA dimensions in full space or specified subspace."
    space <- match.arg(space)
    if (is.null(M)) M <- data
    if (nrow(M) != length(categories)) stop("length of categories= must correspond to number of row vectors in M=")
    categories <- as.factor(categories)
    if (!is.null(idx)) {
      M <- M[idx, , drop=FALSE]
      categories <- droplevels(categories[idx])
    }
    lda.dims <- function (x) MASS::lda(x, categories)$scaling
    res <- subspace.apply(M, lda.dims, space=space, dim=dim, byrow.out=FALSE)
    rownames(res) <- colnames(M)
    res
  })

## Extend subspace with LDA dimensions
##   - categories = vector of categories to be separated by LDA (must match rows of M)
##   - M = data matrix of row vectors (defaults to internal data matrix)
##   - idx = perform LDA on subset of M
GMA$methods(
  add.discriminant = function (categories, M=NULL, idx=NULL) {
    "Extend subspace with LDA dimensions."
    new.dim <- discriminant(categories, M, space="complement", idx=idx)
    invisible(add(new.dim))
  })

## **TODO** rewrite as class method or separate function?
## round-robin cross-validation for two-class LDA
##  - if train.idx is given, train LDA only on specified data points (but apply to full M)
##  - if coord=TRUE, project all data points into LDA+PCA subspace for each fold
## returns list with two or three components
##  - discriminants = column matrix of discriminant vectors for each fold
##  - predictions = data frame of predictions for data points in test fold
##      - class = category predicted by LDA classifier
##      - x = normalized projection coordinate of data point
##  - coord = list of LDA+PCA coordinates of all data points for each fold (if coord=TRUE)
lda.cv <- function (M, categories, train.idx=NULL, folds=10, coord=FALSE) {
  n <- nrow(M)
  stopifnot(length(unique(categories)) == 2)
  if (is.null(train.idx))
    train.idx <- rep(TRUE, n)
  else
    stopifnot(length(train.idx) == n)
  disc.list <- list()
  coord.list <- list()
  predictions <- data.frame(class=character(n), x=numeric(n), stringsAsFactors=FALSE)
  for (k in 1:folds) {
    test.set <- (1:n) %% folds == k - 1
    res <- lda(M[train.idx & !test.set, , drop=FALSE], categories[train.idx & !test.set])
    disc.list[[k]] <- res$scaling
    M.test <- M[test.set, , drop=FALSE]
    res2 <- predict(res, M.test)
    predictions$class[test.set] <- as.character(res2$class)
    ## don't use scores from predict.lda because they're re-centered (unlike our MVar space)
    predictions$x[test.set] <- drop(M.test %*% normalize.cols(res$scaling)) # projection coordinates
    if (coord)
      coord.list[[k]] <- mvar.projection(mvar.space(M, res$scaling, normalize=TRUE), "both")
  }
  rownames(predictions) <- rownames(M)
  discriminants <- do.call(cbind, disc.list)
  colnames(discriminants) <- paste("fold", 1:folds)
  list(discriminants=discriminants, predictions=predictions, coord=coord.list)
}

## Compute similarity between subspaces A and B (cf. SIGIL Unit 7)
##  - A = column matrix of basis vectors of subspace A
##  - B = column matrix of basis vectors of subspace B
##  - if orthogonalize=FALSE, A and B must already be column-orthonormal
##  - tol = tolerance for testing orthogonality
##  - method = "dim" / "R2" / "sigma"
##      dim: shared dimensions = sum of singular values (= Sim_1) with range [0, dim(B)]
##      R2:  average preserved variance for random vectors (= Sim_2) with range [0, 1]
##      sigma: return raw vector of singular values for further analysis
##  - if dim(A) = dim(B) then both measures are symmetric: Sim(A, B) = Sim(B, A)
##  - otherwise similarity is computed for a projection from B into A (and can be maximal only if dim(B) <= dim(A))
## **TODO**
##  - optionally return matching basis vectors
##  - may need additional vectors from SVD with nu= and nv= argument
##  - but better as method of GMA object so extra dims default to PCA rather than random
mvar.similarity <- function (A, B, method=c("dimensions", "R2", "sigma"), orthogonalize=TRUE, tol=1e-7) {
  method <- match.arg(method)
  nA <- ncol(A)
  nB <- ncol(B)
  if (nA == 0L || nB == 0L) {
    return( if (method == "sigma") numeric(0) else 0 )
  }
  if (orthogonalize) {
    A <- orthogonalize(A, fail=TRUE)
    B <- orthogonalize(B, fail=TRUE)
  } else {
    if (max(abs(crossprod(A) - diag(nA))) > tol) stop("basis of subspace A is not orthonormal")
    if (max(abs(crossprod(B) - diag(nB))) > tol) stop("basis of subspace B is not orthonormal")
  }
  res <- svd(crossprod(A, B), nu=nA, nv=nB) # A'B = UDV'
  U <- res$u
  sigma <- res$d
  V <- res$v
  switch(
    method,
    dimensions = sum(sigma),
    R2 = mean(sigma^2),
    sigma = sigma,
    stop("internal error"))
}

## Compute similarity between two GMA target spaces
##  - other = a second GMA object with same underlying dimensionality
##  - method = "dim" / "R2" / "sigma"
GMA$methods(
  similarity = function (other, method=c("dimensions", "R2", "sigma")) {
    method <- match.arg(method)
    if (!inherits(other, "GMA")) stop("other= must be a GMA object")
    if (n != other$n) stop("both GMA objects must have the same underlying dimensionality n")
    A <- basis()
    B <- other$basis()
    mvar.similarity(A, B, method=method, orthogonalize=FALSE)
  })


##
## Density plot for linear discriminant
discriminant.plot <- function (M, discriminant, categories, col.vals=corpora.palette("simple"), lwd.vals=4, lty.vals="solid", xlab="discriminant score", ylab="density", bw.adjust=.7, bw="SJ", freq=FALSE, legend.cex=1, rug=FALSE, bottomline=TRUE, y.max=NULL, xlim=NULL, ...) {
  categories <- as.factor(categories)
  scores <- drop(M %*% discriminant) # vector of discriminant scores
  if (is.null(xlim)) xlim <- range(scores)
  levels <- levels(categories)
  n.levels <- length(levels)
  if (length(col.vals) == 1) col.vals <- rep(col.vals, n.levels) # recycle single style value as often as needed
  if (length(lwd.vals) == 1) lwd.vals <- rep(lwd.vals, n.levels)
  if (length(lty.vals) == 1) lty.vals <- rep(lty.vals, n.levels)
  if (n.levels > min(length(col.vals), length(lwd.vals), length(lty.vals))) stop("too many different categories")

  densities <- lapply(levels, function (l) {
    res <- density(scores[categories==l], from=xlim[1], to=xlim[2], n=512, bw=bw, adjust=bw.adjust)
    res$points <- scores[categories==l] # for rug plots
    if (freq) res$y <- res$y * sum(categories == l)
    res
  })
  if (is.null(y.max)) y.max <- do.call(max, lapply(densities, function (d) d$y))
  plot(0, 0, type="n", xlim=xlim, ylim=c(0, y.max), xlab=xlab, ylab=ylab, ...)
  for (i in 1:n.levels) {
    d <- densities[[i]]
    lines(d, col=col.vals[i], lwd=lwd.vals[i], lty=lty.vals[i])
    if (rug) rug(d$points, col=col.vals[i])
  }
  if (bottomline) abline(h=0, lwd=4, col="#666666")

  legend("topright", inset=.02, legend=levels, col=col.vals[1:n.levels], lwd=lwd.vals[1:n.levels], lty=lty.vals[1:n.levels], cex=legend.cex, bg="white")

  names(scores) <- rownames(M)
  invisible(scores) # return vector of discriminant scores
}

## b/w version for proceedings
discriminant.plot.bw <- function (M, discriminant, categories, col.vals=rep("black", 10), lty.vals=1:10, lwd.vals=rep(5, 10), legend.cex=1.5, ...) {
  discriminant.plot(M, discriminant, categories, col.vals=col.vals, lty.vals=lty.vals, lwd.vals=lwd.vals, legend.cex=legend.cex, ...)
}


##
## Correlation plot with optional grouping and cor.test
##  - x, y = coordinates of data points
##  - col, pch = integer or factor vectors selecting colours (from col.vals) and plot symbols (from pch.vals)
##  - if test=TRUE, carry out Pearson correlation test and plot regression line (separately for each level of optional factor group)
correlation.plot <- function (x, y, col=1, col.vals=corpora.palette("simple"), pch=1, pch.vals=1:10, cex=1, legend.cex=1.2 * cex, test=FALSE, verbose=TRUE, group=NULL, ...) {
  n <- length(x)
  stopifnot(length(y) == n)
  if (length(col) == 1) col <- rep(col, n)
  if (length(pch) == 1) pch <- rep(pch, n)
  stopifnot(length(col) == n)
  stopifnot(length(pch) == n)
  if (is.character(col)) col <- as.factor(col)
  if (is.character(pch)) pch <- as.factor(pch)
  plot(x, y, col=col.vals[col], pch=pch.vals[pch], cex=cex, ...)
  if (test) {
    if (is.null(group)) group <- rep(1, n)
    group <- as.factor(group)
    cor.info <- character(0)
    for (i in 1:nlevels(group)) {
      idx <- as.integer(group) == i
      correl <- lm(y[idx] ~ x[idx])
      abline(correl, lwd=2, col=col.vals[i])
      if (verbose && nlevels(group) > 1) cat(sprintf("-- Group %d: %s\n", i, levels(group)[i]))
      res <- cor.test(x[idx], y[idx])
      if (verbose) print(res)
      cor.info <- append(cor.info, sprintf("r = %.3f (%.3f .. %.3f)", res$estimate, res$conf.int[1], res$conf.int[2]))
    }
    par.save <- par(family="mono")
    legend("bottomright", inset=.02, bg="white", legend=cor.info, lwd=2, col=col.vals[1:nlevels(group)], cex=legend.cex)
    par(par.save)
  }
  if (is.factor(col) && is.factor(pch) && nlevels(col) == nlevels(pch) && all(levels(col) == levels(pch)) && all(col == pch)) {
    legend("topright", inset=.02, bg="white", legend=levels(col), pch=pch.vals[1:nlevels(pch)], col=col.vals[1:nlevels(col)], cex=legend.cex)
  } else {
    if (is.factor(col)) legend("topleft", inset=.02, bg="white", legend=levels(col), col=col.vals[1:nlevels(col)], pch=20, cex=legend.cex, pt.cex=1.4 * legend.cex)
    if (is.factor(pch)) legend("topright", inset=.02, bg="white", legend=levels(pch), pch=pch.vals[1:nlevels(pch)], col="black", cex=legend.cex)
  }
}


##
## Barplot of feature weights for a given dimension
##  - basis = column matrix of basis vectors
##  - dim = dimensions to be shown in plot; if more than one is selected, the barplots will be stacked vertically
##  - idx = (optional) index vector indicating a subset of weights to be displayed
##  - names, feature.names = labels for dimensions and features in the plot
##  - bw = if TRUE, produce a b/w version of the plot
##  - base_size = basic font size for the plot (see ggplot documentation)
##  - ylim = display range on y-axis (NULL or two-element vector)
## returns a ggplot object that has to be printed to display the graph
gma.plot.weights <- function (basis, dim=seq_len(ncol(basis)), idx=NULL, names=NA, feature.names=NA, ylab="normalized feature weights", main=NULL, bw=FALSE, base_size=12, ylim=NULL) {
  n <- nrow(basis)
  k <- length(dim)
  stopifnot(all(dim >= 1 & dim <= ncol(basis)))
  if (isNA(names)) names <- if (!is.null(colnames(basis))) colnames(basis)[dim] else paste("dim", dim)
  if (isNA(feature.names)) feature.names <- sprintf("feature #%d", 1:n)
  stopifnot(length(names) == k)
  stopifnot(length(feature.names) == n)
  if (!is.null(idx)) {
    basis <- basis[idx, , drop=FALSE]
    feature.names <- feature.names[idx]
    n <- nrow(basis)
  }

  info.tbl <- data.frame(feature=factor(rep(feature.names, k), levels=feature.names), dimension=factor(rep(names, each=n), levels=names), weight=as.vector(basis[, dim]))
  bp <- ggplot(info.tbl, aes(x=feature, y=weight)) + facet_grid(dimension ~ .) + geom_bar(aes(fill=weight), stat="identity", position="identity")
  bp <- bp + ylab(ylab) + xlab("")
  if (!is.null(main)) bp <- bp + ggtitle(main)
  bp <- bp + theme_bw(base_size=base_size) + theme(axis.text.x=element_text(angle=45, hjust=1))
  if (bw) {
    bp <- bp + scale_fill_gradient2(low="black", mid="white", high="black")
  } else {
    bp <- bp + scale_fill_gradient2(low="#CC071E", mid="white", high="#57AB27")
  }
  if (!is.null(ylim)) bp <- bp + lims(y=ylim)
  bp
}

##
## Boxplots of feature distributions grouped by user-specified categories
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
gma.plot.features <- function (M, Meta, what=c("features", "weighted", "contribution"), weights=rep(1, ncol(M)), group=NULL, group.palette=NULL, subset=NULL, select=NULL, feature.names=NULL, id.var="filename", main=NULL, nrow=2, bw=FALSE, base_size=12, diamond.size=2.5, group.labels=TRUE, ylim=NULL) {
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
    M <- M[subset, , drop=FALSE]
    Meta <- Meta[subset, ]
    n <- nrow(M)
  }
  if (!is.null(select)) {
    M <- M[, select]
    feature.names <- colnames(M)
    weights <- weights[feature.names]
  }

  if (what == "contribution") {
    M <- scaleMargins(M, cols=weights)
    colnames(M) <- ifelse(weights < 0, paste("(\U{2013})", feature.names), feature.names)
  } else if (what == "weighted") {
    M <- scaleMargins(M, cols=abs(weights))
  }

  group <- eval(substitute(group), Meta, parent.frame())
  if (is.null(group)) group <- rep("all texts", n)
  table.wide <- data.frame(id=Meta[[id.var]], group=group)
  table.wide <- cbind(table.wide, M)
  table.long <- reshape2::melt(table.wide, id=c("id", "group"))

  bp <- ggplot(table.long, aes(x=group, y=value, colour=group)) + facet_wrap(~ variable, nrow=nrow)
  bp <- bp +
    geom_boxplot(notch=FALSE, lwd=.6, outlier.shape=18, outlier.colour="#666666") +
    stat_summary(fun="mean", geom="point", shape=23, fill="white", size=diamond.size) +
    theme_bw(base_size=base_size) +
    theme(strip.text.x=element_text(angle=90, hjust=0)) +
    ggtitle(main) + xlab("") +
    ylab(switch(what,
                features="feature values",
                weighted="weighted feature values",
                contribution="contribution to axis scores"))
  bp <- bp + if (group.labels) theme(axis.text.x=element_text(angle=60, hjust=1)) else theme(axis.text.x = element_blank())
  if (!is.null(group.palette)) {
    bp <- bp + scale_colour_manual(values=group.palette)
  }
  else if (bw) {
    bp <- bp + scale_colour_grey(start=0, end=.6)
  }
  if (!is.null(ylim)) bp <- bp + lims(y=ylim)
  bp
}


##
## Scatterplot matrix with different kinds of meta information
## - must provide matrix M and corresponding data frame with metadata (Meta)
## - parameters select, pch, col are evaluated within data frame Meta
## - if Meta=NULL, a dummy data frame without information is provided
## - pch.cols is used only in the legend box (if pch/col convey overlapping information)
gma.pairs <- function (M, dims=NULL, Meta=NULL, select=NULL, pch=NULL, col=NULL, pch.vals=1:4, pch.cols=NULL, col.vals=NULL, cex=1,
                       legend.cex=0.7*cex, randomize=TRUE, gap=.2, oma=c(2,2,2,2), iso=FALSE, compact=FALSE, ...) {
  if (is.null(dims)) dims <- seq_len(ncol(M))
  n.dim <- length(dims)
  stopifnot(n.dim >= 2)
  if (!all(dims %in% seq_len(ncol(M)))) stop("invalid dimensions selected")

  select.expr <- substitute(select) # evaluate arguments in context of metadata
  pch.expr <- substitute(pch)
  col.expr <- substitute(col)

  if (is.null(Meta)) {
    item.ids <- rownames(M)
    if (is.null(item.ids)) item.ids <- sprintf("%d04d", 1:nrow(M))
    Meta <- data.frame(id=item.ids) # provide dummy metadata
  } else {
    if (nrow(Meta) != nrow(M)) stop("metadata table Meta must have the same number of rows in the same order as the data matrix M")
  }

  select <- eval(select.expr, Meta, parent.frame())
  if (is.logical(select)) select <- which(select) # ensure that subset index is given as line numbers (NULL is not affected)
  pch <- eval(pch.expr, Meta, parent.frame())
  if (length(pch) == 1) pch <- rep(pch, nrow(M))  # NULL has length 0 and is not affected
  col <- eval(col.expr, Meta, parent.frame())
  if (length(col) == 1) col <- rep(col, nrow(M))

  if (!is.null(pch)) {
    stopifnot(length(pch) == nrow(M))
    if (is.character(pch)) pch <- factor(pch)
  }
  if (!is.null(col)) {
    stopifnot(length(col) == nrow(M))
    if (is.character(col)) col <- factor(col)
  }
  if (!is.null(select)) {
    ## reduce to selected subset of points
    M <- M[select, , drop=FALSE]
    if (!is.null(pch)) pch <- pch[select]
    if (!is.null(col)) col <- col[select]
  }
  labels <- if (compact || is.null(colnames(M))) rep("", n.dim) else colnames(M)[dims]

  k <- if (compact && n.dim > 2) 2 else 1
  if (is.null(pch)) {
    pch <- rep(pch.vals[1], nrow(M))
  } else {
    pch <- if (is.numeric(pch)) factor(pch, levels=1:max(pch)) else as.factor(pch)
    pch.levels <- levels(pch)
    pch.codes <- as.integer(pch)
    pch.n <- length(pch.levels)
    pch.ncol <- if (pch.n > 5) 2 else 1
    stopifnot(length(pch.vals) >= pch.n)
    pch <- pch.vals[pch.codes]
    if (!is.null(pch.cols)) {
      stopifnot(length(pch.cols) >= pch.n)
    } else {
      pch.cols <- rep("black", pch.n)
    }
    labels[k] <- ":pch:"; k <- k+1
  }

  if (is.null(col)) {
    col <- rep(col.vals[1], nrow(M))
  } else {
    col <- if (is.numeric(col)) factor(col, levels=1:max(col)) else as.factor(col)
    col.levels <- levels(col)
    col.codes <- as.integer(col)
    col.n <- length(col.levels)
    col.ncol <- if (col.n > 5) 2 else 1
    stopifnot(length(col.vals) >= col.n)
    col <- col.vals[col.codes]
    if (compact && n.dim == 3 && k > 2) {
      labels[2] <- ":pch:col:" # special case for compact layout
    } else {
      labels[k] <- ":col:"; k <- k+1
    }
  }

  my.panel <- function (x, y, label, ...) {
    if (label == ":pch:") legend(x, y, xjust=0.5, yjust=0.5, legend=pch.levels, pch=pch.vals[1:pch.n], col=pch.cols[1:pch.n], pt.cex=1.2, pt.lwd=1.2, cex=legend.cex, ncol=pch.ncol) else
    if (label == ":col:") legend(x, y, xjust=0.5, yjust=0.5, legend=col.levels, fill=col.vals[1:col.n], border=col.vals[1:col.n], cex=legend.cex, ncol=col.ncol) else
    if (label == ":pch:col:") {
      legend(x, y, xjust=0.5, yjust=1.1, legend=pch.levels, pch=pch.vals[1:pch.n], col=pch.cols[1:pch.n], pt.cex=1.2, pt.lwd=1.2, cex=legend.cex, ncol=pch.ncol)
      legend(x, y, xjust=0.5, yjust=-0.1, legend=col.levels, fill=col.vals[1:col.n], border=col.vals[1:col.n], cex=legend.cex, ncol=col.ncol)
    } else
      text(x, y, label, adj=c(0.5, 0.5), cex=legend.cex)
  }

  if (randomize) {
    nR <- nrow(M)
    idx <- sample.int(nR)
    pch <- pch[idx]
    col <- col[idx]
    M <- M[idx, , drop=FALSE]
  }

  upper.panel <- points
  lower.panel <- if (compact) function (x, y, ...) {} else upper.panel
  ## if (iso) {
  ##   M <- apply(M, 2, function (x) x - mean(range(x))) # center range of variable
  ##   limits <- range(M[, dims])
  ##   pairs(M[, dims], pch=pch, col=col, cex=cex, upper.panel=upper.panel, lower.panel=lower.panel, text.panel=my.panel, labels=labels, gap=gap, oma=oma, xlim=limits, ylim=limits, compact=compact, ...)
  ## } else {
    pairsCompact(M[, dims], pch=pch, col=col, cex=cex, upper.panel=upper.panel, lower.panel=lower.panel, text.panel=my.panel, labels=labels, gap=gap, oma=oma, compact=compact, iso=iso, ...)
  ## }
}

## modified version of built-in pairs() function for scatterplot matrix
##  - row1attop = FALSE is not supported
##  - new option compact=TRUE to omit leftmost column and bottom row from plot
##  - new option iso=TRUE to force isometric scaling of all axes (but perhaps with different center)
pairsCompact <- function (x, labels, panel = points, ...,
                          horInd = 1:nc, verInd = 1:nc,
                          lower.panel = panel, upper.panel = panel,
                          diag.panel = NULL, text.panel = textPanel,
                          label.pos = 0.5 + has.diag/3, line.main = 3,
                          cex.labels = NULL, font.labels = 1,
                          row1attop = TRUE, gap = 1, log = "",
                          compact=FALSE, iso=FALSE)
{
  if (!missing(horInd) || !missing(verInd)) stop("this implementation doesn't support modified horInd or verInd")
  if(doText <- missing(text.panel) || is.function(text.panel))
    textPanel <-
      function(x = 0.5, y = 0.5, txt, cex, font)
        text(x, y, txt, cex = cex, font = font)

  localAxis <- function(side, x, y, xpd, bg, col=NULL, main, oma, ...) {
    ## Explicitly ignore any color argument passed in as
    ## it was most likely meant for the data points and
    ## not for the axis.
    xpd <- NA
    if(side %% 2L == 1L && xl[j]) xpd <- FALSE
    if(side %% 2L == 0L && yl[i]) xpd <- FALSE
    if(side %% 2L == 1L) Axis(x, side = side, xpd = xpd, ...)
    else Axis(y, side = side, xpd = xpd, ...)
  }

  localPlot <- function(..., main, oma, font.main, cex.main) plot(...)
  localLowerPanel <- function(..., main, oma, font.main, cex.main)
    lower.panel(...)
  localUpperPanel <- function(..., main, oma, font.main, cex.main)
    upper.panel(...)

  localDiagPanel <- function(..., main, oma, font.main, cex.main)
    diag.panel(...)

  dots <- list(...); nmdots <- names(dots)
  if (!is.matrix(x)) {
    x <- as.data.frame(x)
    for(i in seq_along(names(x))) {
      if(is.factor(x[[i]]) || is.logical(x[[i]]))
        x[[i]] <- as.numeric(x[[i]])
      if(!is.numeric(unclass(x[[i]])))
        stop("non-numeric argument to 'pairs'")
    }
  } else if (!is.numeric(x)) stop("non-numeric argument to 'pairs'")
  panel <- match.fun(panel)
  if((has.lower <- !is.null(lower.panel)) && !missing(lower.panel))
    lower.panel <- match.fun(lower.panel)
  if((has.upper <- !is.null(upper.panel)) && !missing(upper.panel))
    upper.panel <- match.fun(upper.panel)
  if((has.diag  <- !is.null( diag.panel)) && !missing( diag.panel))
    diag.panel <- match.fun( diag.panel)

  if(row1attop) {
    tmp <- lower.panel; lower.panel <- upper.panel; upper.panel <- tmp
    tmp <- has.lower; has.lower <- has.upper; has.upper <- tmp
  }

  nc <- ncol(x)
  if (nc < 2L) stop("only one column in the argument to 'pairs'")
  if(!all(horInd >= 1L & horInd <= nc))
    stop("invalid argument 'horInd'")
  if(!all(verInd >= 1L & verInd <= nc))
    stop("invalid argument 'verInd'")
  if(doText) {
    if (missing(labels)) {
      labels <- colnames(x)
      if (is.null(labels)) labels <- paste("var", 1L:nc)
    }
    else if(is.null(labels)) doText <- FALSE
  }
  if (compact) {
    verInd <- if (row1attop) verInd[1:(nc-1)] else verInd[-1]
    horInd <- horInd[-1]
  }
  oma <- if("oma" %in% nmdots) dots$oma
  main <- if("main" %in% nmdots) dots$main
  if (is.null(oma))
    oma <- c(4, 4, if(!is.null(main)) 6 else 4, 4)
  opar <- par(mfrow = c(length(horInd), length(verInd)),
              mar = rep.int(gap/2, 4), oma = oma)
  on.exit(par(opar))
  dev.hold(); on.exit(dev.flush(), add = TRUE)

  if (iso) axis.width <- max(apply(x, 2, function (y) diff(range(y)))) # maximal width of range on an axis
  xl <- yl <- logical(nc)
  if (is.numeric(log)) xl[log] <- yl[log] <- TRUE
  else {xl[] <- grepl("x", log); yl[] <- grepl("y", log)}
  for (i in if(row1attop) verInd else rev(verInd))
    for (j in horInd) {
      l <- paste0(ifelse(xl[j], "x", ""), ifelse(yl[i], "y", ""))
      if (iso) {
        iso.xlim <- mean(range(x[, j])) + c(-0.5, 0.5) * axis.width
        iso.ylim <- mean(range(x[, i])) + c(-0.5, 0.5) * axis.width
        localPlot(x[, j], x[, i], xlab = "", ylab = "", axes = FALSE, type = "n", xlim=iso.xlim, ylim=iso.ylim, ..., log = l)
      } else {
        localPlot(x[, j], x[, i], xlab = "", ylab = "", axes = FALSE, type = "n", ..., log = l)
      }
      if(i == j || (i < j && has.lower) || (i > j && has.upper) ) {
        box()
        if(i == min(verInd)  && (!(j %% 2L) || !has.upper || !has.lower ))
          localAxis(1L + 2L*row1attop, x[, j], x[, i], ...)
        if(i == max(verInd) && (  j %% 2L  || !has.upper || !has.lower ))
          localAxis(3L - 2L*row1attop, x[, j], x[, i], ...)
        if(j == min(horInd)  && (!(i %% 2L) || !has.upper || !has.lower ))
          localAxis(2L, x[, j], x[, i], ...)
        if(j == max(horInd) && (  i %% 2L  || !has.upper || !has.lower ))
          localAxis(4L, x[, j], x[, i], ...)
        mfg <- par("mfg")
        if(i == j) {
          if (has.diag) localDiagPanel(as.vector(x[, i]), ...)
          if (doText) {
            par(usr = c(0, 1, 0, 1))
            if(is.null(cex.labels)) {
              l.wid <- strwidth(labels, "user")
              cex.labels <- max(0.8, min(2, .9 / max(l.wid)))
            }
            xlp <- if(xl[i]) 10^0.5 else 0.5
            ylp <- if(yl[j]) 10^label.pos else label.pos
            text.panel(xlp, ylp, labels[i],
                       cex = cex.labels, font = font.labels)
          }
        } else if(i < j)
          localLowerPanel(as.vector(x[, j]), as.vector(x[, i]), ...)
        else
          localUpperPanel(as.vector(x[, j]), as.vector(x[, i]), ...)
        if (any(par("mfg") != mfg))
          stop("the 'panel' function made a new plot")
      } else par(new = FALSE)

    }
  if (!is.null(main)) {
    font.main <- if("font.main" %in% nmdots) dots$font.main else par("font.main")
    cex.main <- if("cex.main" %in% nmdots) dots$cex.main else par("cex.main")
    mtext(main, 3, line.main, outer=TRUE, at = 0.5, cex = cex.main, font = font.main)
  }
  invisible(NULL)
}


##
## Hierarchical clustering dendrogram with meta information highlighted as points
gma.clust <- function (clusters, labels=clusters$labels, pch=NULL, col=NULL, pch.vals=c(16,17,18,15,0:6), pch.cols=NULL, col.vals=corpora.palette("simple"), legend=TRUE, cex=1, legend.cex=cex, spread=.1, period=1, xlab="", ...) {
  if (is.null(labels)) labels <- FALSE # suppress labels if NULL
  plot(clusters, hang=-1, labels=labels, xlab=xlab, sub="", ...)
  n <- length(clusters$order)

  legend.pch <- FALSE
  if (is.null(pch)) pch <- rep(pch.vals[1], n) else {
    pch <- as.factor(pch)
    pch.levels <- levels(pch)
    pch.codes <- as.integer(pch)
    pch.n <- length(pch.levels)
    stopifnot(length(pch.vals) >= pch.n)
    pch <- pch.vals[pch.codes]
    if (!is.null(pch.cols)) {
      stopifnot(length(pch.cols) >= pch.n)
    } else {
      pch.cols <- rep("black", pch.n)
    }
    legend.pch <- TRUE
  }

  legend.col <- FALSE
  if (is.null(col)) col <- rep(col.vals[1], n) else {
    col <- as.factor(col)
    col.levels <- levels(col)
    col.codes <- as.integer(col)
    col.n <- length(col.levels)
    stopifnot(length(col.vals) >= col.n)
    col <- col.vals[col.codes]
    legend.col <- TRUE
  }

  y.offset <- rep(((1:period)-1)/period, length=n) * spread * max(clusters$height)
  points(1:n, y.offset, cex=cex, col=col[clusters$order], pch=pch[clusters$order])
  if (legend && legend.pch) legend("topright", inset=.02, bg="white", legend=pch.levels, pch=pch.vals[1:pch.n], col=pch.cols, pt.cex=1.2, pt.lwd=1.2, cex=legend.cex)
  if (legend && legend.col) legend("topleft", inset=.02, bg="white", legend=col.levels, fill=col.vals[1:col.n], border=col.vals[1:col.n], cex=legend.cex)
  invisible(clusters)
}

## determine majority labels for clusters
majorityLabels <- function (cluster.id, gold) {
  stopifnot(length(cluster.id) == length(gold))
  cluster.id <- as.character(cluster.id) # look up cluster IDs by name so we don't have to assume consecutive numbers
  ct <- table(cluster.id, gold) # cluster number vs. gold author
  maj.lab <- colnames(ct)[apply(ct, 1, which.max)] # pick out most frequent gold author in each cluster and map to name
  names(maj.lab) <- rownames(ct) # for lookup
  res <- maj.lab[cluster.id]
  if (is.factor(gold)) res <- factor(res, levels=levels(gold))
  res
}

## adjusted Rand index (ARI) for quantitative evaluation
adjustedRandIndex <- function (x, y) {
  x <- as.vector(x)
  y <- as.vector(y)
  if (length(x) != length(y)) stop("arguments must be vectors of the same length")
  tab <- table(x, y)
  if (all(dim(tab) == c(1, 1))) return(1)
  a <- sum(choose(tab, 2))
  b <- sum(choose(rowSums(tab), 2)) - a
  c <- sum(choose(colSums(tab), 2)) - a
  d <- choose(sum(tab), 2) - a - b - c
  ARI <- (a - (a + b) * (a + c)/(a + b + c + d)) /
    ((a + b + a + c)/2 - (a + b) * (a + c)/(a + b + c + d))
  ARI
}


## helper:
## 3-dimensional scatterplot with standard shapes; only single shape allowed per call;
## all other grqphics parameters (such as col=) are passed throuh
draw.3dpoints <- function (xyz, shape=c("circles", "triangles", "squares"), size=1, ...) {
  shape <- match.arg(shape)
  if (shape == "circles") {
    spheres3d(xyz, radius=size, ...)
  } else if (shape == "triangles") {
    shapelist3d(tetrahedron3d(), xyz, size=size, ...)
  } else { # shape == "squares"
    shapelist3d(cube3d(), xyz, size=size, ...)
  }
}


##
## 3D scatterplot with different kinds of meta-information
##
## - must provide matrix M and corresponding data frame with metadata (Meta)
## - parameters select, pch, col, size are evaluated within data frame Meta
## - if Meta=NULL, a dummy data frame without information is provided
## - expressions for connect.select, connect.lwd and connect.col can access metadata of start and end points as start$<var> and end$<var>
## - if connect.arrow=TRUE, points are connected by arrows rather than simple lines (expensive)
## - arrow width is automatically selected, but can be overridden by setting connect.arrow=<width>; in either case, it is further scaled by connect.lwd
## - if legend=TRUE, display legend on 2D graphics device, or write directly to PDF file if legend.pdf= is specified
gma.3d <- function (M, dims=c(2,1,3), Meta=NULL, select=NULL, pch=NULL, col=NULL, pch.vals=c("circles","triangles","squares"), pch.cols=NULL, col.vals=corpora.palette("simple"), linecol.vals=rev(corpora.palette("simple")), size=.05, legend.cex=1.4, legend=FALSE, legend.pdf=NULL, connect=NULL, connect.select=NULL, connect.lwd=1, connect.col=NULL, connect.arrow=FALSE, bbox=TRUE, ...) {
  if (length(dims) != 3) stop("need exactly 3 dimensions for 3D visualization")
  if (!is.null(legend.pdf)) legend <- TRUE
  size <- rep(size, length.out=nrow(M))
  pt.size <- max(size) # assumed point size for adjustments

  select.expr <- substitute(select) # evaluate arguments in context of metadata
  pch.expr <- substitute(pch)
  col.expr <- substitute(col)
  connect.select.expr <- substitute(connect.select)
  connect.col.expr <- substitute(connect.col)

  if (is.null(Meta)) {
    item.ids <- rownames(M)
    if (is.null(item.ids)) item.ids <- sprintf("%d04d", 1:nrow(M))
    Meta <- data.frame(id=item.ids) # provide dummy metadata
  } else {
    if (nrow(Meta) != nrow(M)) stop("metadata table Meta must have the same number of rows in the same order as the data matrix M")
  }

  select <- eval(select.expr, Meta, parent.frame())
  if (is.logical(select)) select <- which(select) # ensure that subset index is given as line numbers (NULL is not affected)
  pch <- eval(pch.expr, Meta, parent.frame())
  if (length(pch) == 1) pch <- rep(pch, nrow(M))  # NULL has length 0 and is not affected
  col <- eval(col.expr, Meta, parent.frame())
  if (length(col) == 1) col <- rep(col, nrow(M))

  if (!is.null(connect)) {
    if (!( is.matrix(connect) && ncol(connect) %in% 2:3 )) stop("connect= argument must be 2-column matrix") # accept 3rd column for compatibility with data from first version
    meta.envir <- list(from=Meta[connect[,1], ], to=Meta[connect[,2], ])
    connect.select <- eval(connect.select.expr, meta.envir, parent.frame())
    connect.col <- eval(connect.col.expr, meta.envir, parent.frame())
    if (length(connect.col) == 1) connect.col <- rep(connect.col, nrow(connect)) # NULL has length 0 and is not affected
    if (is.character(connect.col)) connect.col <- factor(connect.col)

    if (!is.null(connect.select)) {
      ## reduce to selected subset of connections (and adjust vector of colour values)
      connect <- connect[connect.select, , drop=FALSE]
      if (!is.null(connect.col)) connect.col <- connect.col[connect.select]
    }

    ## look up coordinates of start and end points before row indices may be changed by select
    P1 <- M[connect[,1], dims, drop=FALSE]
    P2 <- M[connect[,2], dims, drop=FALSE]
  }

  if (!is.null(pch)) {
    stopifnot(length(pch) == nrow(M))
    if (is.character(pch)) pch <- factor(pch)
  }
  if (!is.null(col)) {
    stopifnot(length(col) == nrow(M))
    if (is.character(col)) col <- factor(col)
  }
  if (!is.null(select)) {
    ## reduce to selected subset of points (adjusting point symbols and colour values)
    M <- M[select, , drop=FALSE]
    if (!is.null(pch)) pch <- pch[select]
    if (!is.null(col)) col <- col[select]

    if (!is.null(connect)) {
      ## drop connections if their start or end points are no longer displayed
      idx.keep <- connect[,1] %in% select & connect[,2] %in% select
      P1 <- P1[idx.keep, , drop=FALSE]
      P2 <- P2[idx.keep, , drop=FALSE]
      connect <- connect[idx.keep, , drop=FALSE]
      if (!is.null(connect.col)) connect.col <- connect.col[idx.keep]
    }
  }

  if (legend) {
    if (!is.null(legend.pdf)) {
      pdf(legend.pdf, width=6, height=8)
      par(mar=c(0,0,0,0))
      on.exit(dev.off())
    }
    plot(0:1, 0:1, type="n", ann=FALSE, axes=FALSE) # empty 2D canvas for legend boxes
  }

  if (is.null(pch)) {
    pch <- rep(pch.vals[1], nrow(M))
  } else if (!is.factor(pch)) {
    pch <- pch.vals[pch]
  } else {
    pch <- droplevels(pch)
    pch.levels <- levels(pch)
    pch.codes <- as.integer(pch)
    pch.n <- length(pch.levels)
    if (pch.n > length(pch.vals)) stop(sprintf("too few point shapes supplied (need at least %d)", pch.n))
    pch <- pch.vals[pch.codes]
    if (legend) {
      sym.names <- c("circles", "triangles", "squares")
      sym.codes <- c(16, 17, 15)
      pch.legend <- sym.codes[ pmatch(pch.vals[1:pch.n], sym.names, duplicates.ok=TRUE) ]
      col.legend <- if (!is.null(pch.cols)) pch.cols[1:pch.n] else "black"
      legend("topleft", bty="n", legend=pch.levels, pch=pch.legend, cex=legend.cex, col=col.legend)
    }
  }

  if (is.null(col)) {
    col <- rep(col.vals[1], nrow(M))
  } else if (!is.factor(col)) {
    col <- col.vals[col]
  } else {
    col <- droplevels(col)
    col.levels <- levels(col)
    col.codes <- as.integer(col)
    col.n <- length(col.levels)
    if (col.n > length(col.vals)) stop(sprintf("too few point colours supplied (need at least %d)", col.n))
    col <- col.vals[col.codes]
    if (legend) {
      legend("topright", bty="n", legend=col.levels, fill=col.vals[1:col.n], cex=legend.cex)
    }
  }

  par3d(skipRedraw=TRUE)
  clear3d()
  for (sym in levels(factor(pch))) {
    sym.idx <- pch == sym
    draw.3dpoints(M[sym.idx, dims], size=size[sym.idx], shape=sym, color=col[sym.idx])
  }

  if (!is.null(connect)) {
    ## add connections between points (lines or arrows)

    if (is.null(connect.col)) {
      connect.col <- rep(linecol.vals[1], nrow(connect))
    } else if (!is.factor(connect.col)) {
      connect.col <- linecol.vals[connect.col]
    } else {
      connect.col <- droplevels(connect.col)
      connect.levels <- levels(connect.col)
      connect.codes <- as.integer(connect.col)
      connect.n <- length(connect.levels)
      if (connect.n > length(linecol.vals)) stop(sprintf("too few line colours supplied (need at least %d)", connect.n))
      connect.col <- linecol.vals[connect.codes]
      if (legend) {
        legend("bottomright", bty="n", legend=connect.levels, col=linecol.vals[1:connect.n], lwd=4, cex=legend.cex)
      }
    }

    if (connect.arrow) {
      ## connect points by arrows (width scaled by line width)
      d <- sqrt(rowSums((P1 - P2)^2)) # arrow lengths
      arrow.width <- (2 * pt.size) / 3   # auto-scale arrow width based on point size (width of shaft = 1/3 diameter of point)
      if (is.numeric(connect.arrow)) arrow.width <- connect.arrow
      arrow.width <- arrow.width * connect.lwd
      for (i in 1:nrow(connect)) {
        p1 <- P1[i,]
        p2 <- P2[i,]
        arrow3d((p1 + p2)/2, p2 - p1, d[i] - 2 * pt.size, width=arrow.width, adj=0.5, col=connect.col[i], tipex=3, sides=32) # NB: arrows shortened by point size (radius) on either end
      }
    } else {
      ## connect points by lines with specified line width
      P.pairs <- matrix(as.vector(rbind(t(P1), t(P2))), ncol=3, byrow=TRUE) # interleave P1 and P2 by rows (must have 3 columns each)
      segments3d(P.pairs, lwd=connect.lwd, color=rep(connect.col, each=2), line_antialias=TRUE)
    }

  }

  if (bbox) {
    bbox3d(color=c("grey30", "black"), shininess=100, emission="grey60")
    for (side in c("z-", "z+", "y-", "y+")) grid3d(side, col="#999999", lwd=.5)
    for (side in c("x-", "x+")) grid3d(side, col="#777777", lwd=.5)
  } else {
    axes3d(c("x", "y", "z"))
    if (!is.null(colnames(M))) {
      axisnames <- colnames(M)[dims]
      title3d(xlab=axisnames[1], ylab=axisnames[2], zlab=axisnames[3])
    }
    ## decorate3d(box=FALSE, axes=TRUE) # -- open box, similar to standard 2D plots
  }

  aspect3d("iso")
  par3d(skipRedraw=FALSE)
}

## rotate 3D plot once around specified axis
twiddle3d <- function (axis=c(0,1,0), repeats=1, rpm=10) {
  n.sec <- repeats * (60 / rpm)
  play3d(spin3d(axis=axis, rpm=rpm), n.sec)
}

## waggle 3D plot forth and back
waggle3d <- function (axis=c(0,1,0), n=5, deg=2, hz=1.5) {
  M <- par3d("userMatrix")
  duration <- n / hz
  animator <- function (time, base=M) {
  	iter <- time * hz # (fractional) iteration
  	radians <- (deg / 180 * pi) * sin(2 * pi * iter)
  	if (iter <= 1) {
  	  amplitude <- dnorm(iter, 1, 0.5) / dnorm(1, 1, 0.5)
  	} else if (iter >= n - 1) {
  	  amplitude <- dnorm(iter, n-1, 0.5) / dnorm(n-1, n-1, 0.5)
  	} else {
  	  amplitude <- 1
  	}
  	list(userMatrix = rotate3d(base, radians * amplitude, axis[1], axis[2], axis[3]))
  }
  play3d(animator, duration)
  par3d(userMatrix=M) # ensure there is no drift
}

## add a single solid arrow to the 3D plot
##  - arguments: loc(ation), dir(ection), len(gth), width, adj(ustment of anchor point)
arrow3d <- function (loc, dir, length, width=length/40, adj=0.5, col="grey40", tipex=2, sides=32, ignoreExtent=TRUE) {
  dir <- as.vector(dir)
  dir.length <- sqrt(sum(dir^2))
  dir <- dir / dir.length # normalized direction vector
  tip.width <- width * tipex
  tip.length <- width / sin(pi/9) # 20 degrees from center line
  p1 <- loc - adj * length * dir  # tail of arrow
  p2 <- loc + ((1 - adj) * length - tip.length) * dir # start of tip
  p3 <- loc + (1 - adj) * length * dir # end of tip
  if (ignoreExtent) {
  	par.save <- par3d(ignoreExtent=TRUE)
  	on.exit(par3d(par.save), add=TRUE)
  }
  shade3d(cylinder3d(rbind(p1, p2), radius=width/2, sides=sides, closed=-1), col=col)
  shade3d(cylinder3d(rbind(p2, p3), radius=c(tip.width/2, 1e-6), sides=sides, closed=-1), col=col)
}
##  - use this variant to connect start and end point (loc, dir and length are computed automatically)
connect3d <- function (from, to, width=NULL, ...) {
  dir <- to - from
  l <- sqrt(sum(dir^2))
  if (is.null(width)) width <- l/40
  arrow3d(from, dir, l, width=width, adj=0, ...)
}

## make 3D movie (MPEG) rotating view around specified axis
##  - basename = basename for individual frames and movie file
##  - axis = rotation axis
##  - repeats = number of full revolutions (e.g. repeats=.25 for 90 degree rotation)
##  - rpm = speed in full revolutions per minute
##  - fps = frames / second
##  - theta, phi, zoom = initial view (see ?view3d)
##  - axis2 = if specified, add second part rotation <repeats> times aroudn <axis2>
##  - keep.frames = if TRUE, individual frame images are not deleted automatically
##  - out.dir, tmp.dir = directories for movie file and individual frame images
##  - dry.run = if TRUE, only run animation on screen without rendering movie
make.movie <- function (basename, axis=c(0,1,0), repeats=1, rpm=10, fps=24, theta=0, phi=20, zoom=.6, axis2=NULL, keep.frames=FALSE, out.dir=".", tmp.dir=tempdir(check=TRUE), dry.run=FALSE) {
  n.sec <- repeats * (60 / rpm)
  n.frames <- n.sec * fps
  if (n.frames > 999) stop("too many frames (> 999) -- please increase rpm or reduce fps")
  view3d(theta=theta, phi=phi, zoom=zoom)
  if (!is.null(axis2)) {
    camera1 <- spin3d(axis=axis, rpm=rpm)
    camera2 <- spin3d(axis=axis2, rpm=rpm)
    t1 <- n.sec
    camera.fnc <- function (time, ...) {
      if (time >= t1) camera2(time - t1, base=camera1(t1, ...)$userMatrix) else camera1(time, ...)
    }
    n.sec <- n.sec * 2
  } else {
    camera.fnc <- spin3d(axis=axis, rpm=rpm)
  }
  if (dry.run) {
    play3d(camera.fnc, n.sec)
  } else {
    movie3d(camera.fnc, n.sec, movie=basename, dir=tmp.dir, fps=fps, clean=!keep.frames, convert="ffmpeg -r %s -i %s%%03d.png -s 1024,768 -vcodec libx264 -pix_fmt yuv420p -preset slow -profile:v main -crf 5 %s.mp4", webshot=FALSE)
    system2("mv", c(sprintf("%s/%s.mp4", tmp.dir, basename), out.dir))
  }
}




