#' Find a netwwork structure that minimizes the expected PSHD loss among a set of samples
#'
#' @param samples
#' @param a
#'
#' @return xxxxx
#' @export
#'
#' @examples
estimate_pshd <- function(samples, a = 1) {

  # Computation is different depending on whether samples are supplied as a list or 3D array
  if (is.list(samples)) {
    nSamples <- length(samples)
    distance_mat <- matrix(0, nrow = nSamples, ncol = nSamples)
    # If a is 1, the distance matrix is symmetric so we only need to compute the lower triangular part
    # If a is not 1, then the distance must be computed p^2 times (i.e. call the expected_pshd function p times)
    if (a == 1) {
      for (i in 1:nSamples) {
        for (j in 1:i) {
          distance_mat[i, j] <- pshd(nSamples[[i]], nSamples[[j]], a = a)
        }
      }
      # Reflect lower triangular elements to create symmetric distance matrix
      distance_mat[upper.tri(distance_mat)] <- t(distance_mat)[upper.tri(distance_mat)]
      # Compute expected PSHD for each network
      distance_vec <- apply(distance_mat, 1, mean)
    } else {
      distance_vec <- sapply(samples, function(x) {
        expected_pshd(x, samples, a = a)
      })
    }
    # Select the minimizing estimate from the list of samples
    est <- samples[[which.min(distance_vec)]]

  } else if (is.array(samples)) {

    # Break early if array is not of 3 dimensions
    if (length(dim(samples)) != 3) {
      stop("Samples must be provided in the form of a list or 3D array.")
    }

    nSamples <- dim(samples)[3]
    distance_mat <- matrix(0, nrow = nSamples, ncol = nSamples)

    # If a is 1, the distance matrix is symmetric so we only need to compute the lower triangular part
    # If a is not 1, then the distance must be computed p^2 times (i.e. call the expected_pshd function p times)
    if (a == 1) {
      for (i in 1:nSamples) {
        for (j in 1:i) {
          distance_mat[i, j] <- pshd(samples[ , , i], samples[ , , j], a = a)
        }
      }
      # Reflect lower triangular elements to create symmetric distance matrix
      distance_mat[upper.tri(distance_mat)] <- t(distance_mat)[upper.tri(distance_mat)]
      # Compute expected PSHD for each network
      distance_vec <- apply(distance_mat, 1, mean)
    } else {
      distance_vec <- apply(samples, 3, function(x) {
        expected_pshd(x, samples, a = a)
      })
    }
    # Select the minimizing estimate from the 3D array of samples
    est <- samples[ , , which.min(distance_vec)]

  } else {
    stop("Samples must be provided in the form of a list or 3D array.")
  }

  # Return final estimate and its corresponding expected PSHD loss
  return(list(estimate = est, expLoss = min(distance_vec)))
}
