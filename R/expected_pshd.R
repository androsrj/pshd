#' Estimate the expected PSHD loss for a network given a set of samples
#'
#' @param g A \eqn{p \times p} binary adjacency matrix representing the structure of a network, where \eqn{p} is the total number of nodes present.
#' @param samples A list of length \eqn{B} or 3-dimensional array of dimensions \eqn{p \times p \times B} containing a set of \eqn{B} samples. Each sample should be a \eqn{p \times p} binary adjacency matrix representing the structure of a network.
#' @param a The value of the penalty parameter (scalar). Must be strictly greater than 0 and less than 2.
#'
#' @return An estimate of the expected PSHD loss for the network g1 (nonnegative scalar), obtained by averaging the PSHD between g1 and each sample.
#' @export
#'
#' @examples
expected_pshd <- function(g, samples, a = 1) {

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

  return(expLoss)
}
