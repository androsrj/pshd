# Set up main graph structure
mainGraph <- matrix(c(0, 1, 0,
                      1, 0, 0,
                      0, 1, 0), nrow = 3, byrow = TRUE)

# Set up sample graphs used for computing exp loss (list form)
samples <- list(mainGraph, mainGraph, mainGraph)
samples[[1]][1, 3] <- 1
samples[[2]][2, 1] <- 0
samples[[3]][3, 1] <- 1

# Run tests
test_that("Expected PSHD loss is computed correctly, 3 nodes with 3 samples in list form", {
  expect_equal(expected_pshd(mainGraph, samples, a = 1), 1)
  expect_equal(expected_pshd(mainGraph, samples, a = 0.3), (3.7/3))
  expect_equal(expected_pshd(mainGraph, samples, a = 1.75), 0.75)
})

# Set up main graph structure with 4 nodes
mainGraph <- matrix(c(0, 1, 0, 1,
                      1, 0, 0, 0,
                      0, 1, 0, 0,
                      1, 0, 1, 0), nrow = 4, byrow = TRUE)

# Set up sample graphs used for computing exp loss (3D array form)
samplesArr <- array(dim = c(4, 4, 3))
samples <- list(mainGraph, mainGraph, mainGraph, mainGraph)
for (i in 1:3) {
  samplesArr[ , , i] <- samples[[i]]
}
samplesArr[ , , 1][1, 3] <- 1
samplesArr[ , , 2][2, 1] <- 0
samplesArr[ , , 3][3, 1] <- 1

# Run tests
test_that("Expected PSHD loss is computed correctly, 4 nodes with 3 samples in 3D-array form", {
  expect_equal(expected_pshd(mainGraph, samplesArr, a = 1), 1)
  expect_equal(expected_pshd(mainGraph, samplesArr, a = 0.3), (3.7/3))
  expect_equal(expected_pshd(mainGraph, samplesArr, a = 1.75), 0.75)
})
