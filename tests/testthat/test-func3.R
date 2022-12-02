# Set up main graph structure
mainGraph <- matrix(c(0, 1, 0,
                      1, 0, 0,
                      0, 1, 0), nrow = 3, byrow = TRUE)

# Set up sample graphs used for computing exp loss (list form)
samples <- list(mainGraph, mainGraph, mainGraph, mainGraph)
samples[[2]][1, 3] <- 1
samples[[3]][2, 1] <- 0
samples[[4]][3, 1] <- 1

# Run tests
test_that("Find estimate with minimal PSHD loss, 3 nodes with 4 samples in list form", {
  expect_equal(estimate_pshd(samples, a = 1)$estimate, mainGraph)
  expect_equal(estimate_pshd(samples, a = 1.01)$estimate, mainGraph)
})

# Set up sample graphs used for computing exp loss (3D array form)
samples <- array(dim = c(3, 3, 4))
samples[ , , 1] <- samples[ , , 2] <- samples[ , , 3] <- samples[ , , 4] <- mainGraph
samples[1, 3, 1] <- 1
samples[2, 1, 3] <- 0
samples[3, 1, 4] <- 1

# Run tests
test_that("Find estimate with minimal PSHD loss, 3 nodes with 4 samples in 3D array form", {
  expect_equal(estimate_pshd(samples, a = 1)$estimate, mainGraph)
  expect_equal(estimate_pshd(samples, a = 1.01)$estimate, mainGraph)
})
