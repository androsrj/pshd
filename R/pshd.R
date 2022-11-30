#' Compute PSHD loss between two networks structures
#'
#' @description Given two supplied network structures in adjacency matrix form (*g1* and *g2*), this function
#' computes the penalized structural Hamming distance (PSHD) between them. These matrices must be
#' square and binary. If one matrix has more rows/columns than the other, then rows and columns of
#' zeroes will be added to the smaller matrix in order to coerce compatible dimensions. In addition,
#' users can specify a penalty parameter \eqn{a}, which defaults to 1 but can be any value strictly
#' between 0 and 2. The other penalty parameter \eqn{b} will be automatically computed as \eqn{b=2-a}.
#' Tuning the value of \eqn{a} triggers the differential penalty case of structural Hamming distance.
#'
#' @param g1 A \eqn{p \times p} binary adjacency matrix representing the structure of a network, where \eqn{p} is the total number of nodes present.
#' @param g2 A \eqn{p \times p} binary adjacency matrix representing the structure of a network, where \eqn{p} is the total number of nodes present.
#' @param a The value of the penalty parameter (scalar). Must be strictly greater than 0 and less than 2.
#'
#' @return The PSHD loss (nonnegative scalar) between the two supplied networks.
#' @export
#'
#' @examples
pshd <- function(g1, g2, a = 1) {

  # Compatibility checks and error messages
  if (!is.numeric(a) | a <= 0 | a >= 2) {
    stop("Penalty parameter a must be numeric and in the open interval (0, 2).")
  }
  if (!is.numeric(c(g1, g2))) {
    stop("Networks must be numeric, binary square adjacency matrices.")
  }
  if (!is.matrix(g1) | !is.matrix(g2)) {
    stop("Networks must be in adjacency matrix form.")
  }
  if (nrow(g1) != ncol(g1) | nrow(g2) != ncol(g2)) {
    stop("Adjacency matrix of each network must be square.")
  }
  if (!all(unique(c(g1, g2)) %in% c(0,1) )) {
    stop("Each supplied network must consist only of 0's and 1's.")
  }
  if (!all(diag(g1) == 0) | !all(diag(g2) == 0)) {
    stop("Diagonal elements of each adjacency matrix should be zero; otherwise the graph is not acyclic.")
  }

  # Warnings
  if (ncol(g1) > ncol(g2)) {
    warning("First network has more nodes than second network.
            Augmenting the second network with rows and columns of 0's. ")
    diff <- ncol(g1) - ncol(g2)
    add <- matrix(0, nrow = nrow(g2), ncol = diff)
    g2 <- cbind(g2, add)
    add <- matrix(0, nrow = diff, ncol = ncol(g2))
    g2 <- rbind(g2, add)
  } else if (ncol(g1) < ncol(g2)) {
    warning("Second network has more nodes than first network.
            Augmenting the first network with rows and columns of 0's. ")
    diff <- ncol(g2) - ncol(g1)
    add <- matrix(0, nrow = nrow(g1), ncol = diff)
    g1 <- cbind(g1, add)
    add <- matrix(0, nrow = diff, ncol = ncol(g1))
    g1 <- rbind(g1, add)
  }

  # Get the other penalty parameter using a
  b <- 2 - a

  # Calculate PSHD loss
  loss <- a * sum(g1 > g2) + b * sum(g2 > g1)

  # Return value of PSHD loss as a scalar
  return(loss)
}

