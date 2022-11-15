# Estimate the expected generalized structural Hamming distance between a given network and a set of network samples
# Samples must be the form of either a list or a 3D array
expected_pshd <- function(g, samples, a = 1, indivLoss = FALSE) {

  # Loss calculations will depend on whether the samples are in list or 3D array form
  if (is.list(samples)) {
    #nSamples <- length(samples)
    losses <- sapply(samples, function(x) {
      pshd(g, x, a = a)
    })
  } else if (is.array(samples)) {
    # Break early if the array is not 3 dimensions
    if (length(dim(samples)) != 3) {
      stop("Samples must be provided in the form of a list or 3D array.")
    }
    #nSamples <- dim(samples)[3]
    losses <- apply(samples, 3, function(x) {
      pshd(g, x, a = a)
    })
  } else {
    stop("Samples must be provided in the form of a list or 3D array.")
  }

  # Average the individual losses to get expected loss estimate
  expLoss <- mean(losses)

  # If indivLoss==FALSE, returns the expected loss as a scalar
  # Otherwise, return both the expected loss (scalar) and individual losses
  if (indivLoss == FALSE) {
    return(expLoss)
  } else {
    return(list(expLoss = expLoss, indivLosses = losses))
  }
}
