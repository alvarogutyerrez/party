
set.seed(290875)
library("party")
if (!require("MASS", quietly = TRUE))
    stop("cannot load package MASS")

### get rid of the NAMESPACE
attach(list2env(as.list(asNamespace("party"))))

###
###
###    Regression tests for utility functions
###
###    functions defined in file ./src/Utils.c'
###
###

### tests for function C_kronecker
for (i in 1:10) {
    A = matrix(rnorm(i*5), ncol = i, nrow = 5)
    B = matrix(rnorm(i*10), ncol = 10, nrow = i)
    Rkr = kronecker(A, B)
    mykr = .Call(R_kronecker, A, B)
    stopifnot(isequal(Rkr, mykr))
}

### test for function CR_svd (singular value decomposition)
x <- matrix(rnorm(100), ncol = 10)
x <- t(x) %*% x
svdx <- qsvd(x)
stopifnot(isequal(svd(x)$d, svdx$d))
stopifnot(isequal(svd(x)$u, svdx$u))
stopifnot(isequal(svd(x)$v, t(svdx$vt)))

### test for function R_MPinv (Moore-Penrose inverse)
mpinvx <- MPinv(x)
stopifnot(isequal(mpinvx, ginv(x)))

### test for function C_max
y <- rnorm(1000)
stopifnot(isequal(max(y), .Call(R_max, y)))

### test for function C_abs
y <- rnorm(1000)
stopifnot(isequal(abs(y), .Call(R_abs, y)))

### tests for function C_matprod{T}
x <- matrix(rnorm(100), ncol = 4)
y <- matrix(rnorm(40), nrow = 4)
stopifnot(isequal(x %*% y, 
                  .Call(R_matprod, x, y)))
x <- matrix(rnorm(100), ncol = 20)
y <- matrix(rnorm(200), ncol = 20)
stopifnot(isequal(x %*% t(y), 
                  .Call(R_matprodT, x, y)))

### test for function C_SampleNoReplace
### permutation case
m <- 10000
storage.mode(m) <- "integer"
perm <- .Call(R_permute, m) + 1 
stopifnot(all(sort(perm) == (1:m)))

### the random subset case
k <- 100
storage.mode(k) <- "integer"
perm <- .Call(R_rsubset, m, k) + 1 
stopifnot(all(perm %in% (1:m)))
