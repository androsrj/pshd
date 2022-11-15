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


# Compute a network estimate given a set of samples 
# Finds the network in the samples with minimal PSHD loss
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




