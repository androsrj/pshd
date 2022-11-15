# Compute generalized structural Hamming distance between two supplied networks
pshd <- function(g1, g2, a = 1) {

  # Compatibility checks and error messages
  if (!is.numeric(a) | a <= 0 | a >= 2) {
    stop("Penalty parameter a must be numeric and in the open interval (0, 2).")
  }
  if (!is.numeric(c(g1, g2))) {
    stop("Networks must be numeric.")
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

  # Warnings
  if (ncol(g1) > ncol(g2)) {
    warning("First network has more nodes than second network.
            Augmenting the second network with rows and columns of 0's. ")
    diff <- ncol(g1) - ncol(g2)
    add <- matrix(0, nrow = nrow(g2), ncol = diff)
    g2 <- cbind(g2, add)
  } else if (ncol(g1) < ncol(g2)) {
    warning("Second network has more nodes than first network.
            Augmenting the first network with rows and columns of 0's. ")
    diff <- ncol(g2) - ncol(g1)
    add <- matrix(0, nrow = nrow(g1), ncol = diff)
    g1 <- cbind(g1, add)
  }

  # Get the other penalty parameter using a
  b <- 2 - a

  # Calculate PSHD loss
  loss <- a * sum(g1 > g2) + b * sum(g2 > g1)

  # Return value of PSHD loss as a scalar
  return(loss)
}

