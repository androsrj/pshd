# 3 Dimensions
graph1 <- matrix(c(0, 1, 0,
                   1, 0, 0,
                   0, 1, 0), nrow = 3, byrow = TRUE)
graph2 <- matrix(c(0, 0, 1,
                   1, 0, 1,
                   0, 1, 0), nrow = 3, byrow = TRUE)

test_that("PSHD loss is computed correctly, 3 nodes", {
  expect_equal(pshd(graph1, graph2, a = 1), 3)
  expect_equal(pshd(graph1, graph2, a = 0.5), 3.5)
  expect_equal(pshd(graph1, graph2, a = 1.9), 2.1)
})

# 5 Dimensions
graph3 <- matrix(c(0, 1, 0, 0, 1,
                   1, 0, 0, 1, 0,
                   0, 1, 0, 1, 1,
                   1, 0, 0, 0, 1,
                   0, 0, 1, 1, 0), nrow = 5, byrow = TRUE)
graph4 <- matrix(c(0, 0, 1, 1, 1,
                   1, 0, 1, 0, 0,
                   0, 1, 0, 1, 0,
                   1, 1, 0, 0, 1,
                   0, 0, 1, 1, 0), nrow = 5, byrow = TRUE)

test_that("PSHD loss is computed correctly, 5 nodes", {
  expect_equal(pshd(graph3, graph4, a = 1), 7)
  expect_equal(pshd(graph3, graph4, a = 0.25), 7.75)
  expect_equal(pshd(graph3, graph4, a = 1.6), 6.4)
})

# Mismatching dimensions (3 and 5)
# Warnings are to be expected here
test_that("PSHD loss is computed correctly, mismatching node counts", {
  expect_warning(pshd(graph1, graph4, a = 1), "Second network has more nodes than first network.
            Augmenting the first network with rows and columns of 0's.")
  expect_warning(pshd(graph4, graph1, a = 0.1), "First network has more nodes than second network.
            Augmenting the second network with rows and columns of 0's.")
})

# Make sure correct errors are returned for incompatible inputs
graphNonBinary <- graph3
graphNonBinary[1, 2] <- 99
graphWithDiagonal <- graph4
graphWithDiagonal[1, 1] <- 1
test_that("Compatibility checks and error messages", {
  expect_error(pshd(graph1, graph2, a = 3), "Penalty parameter a must be numeric, strictly greater than zero, and strictly less than two.")
  expect_error(pshd(graph1, "hello"), "Networks must be numeric, binary square adjacency matrices.")
  expect_error(pshd(graph1, c(0,1,0,1)), "Networks must be in adjacency matrix form.")
  expect_error(pshd(graph1, rbind(graph1, graph2)), "Adjacency matrix of each network must be square.")
  expect_error(pshd(graphNonBinary, graph3), "Each supplied network must consist only of 0's and 1's.")
  expect_error(pshd(graphWithDiagonal, graph4), "Diagonal elements of each adjacency matrix should be zero; otherwise the graph is not acyclic.")
})

