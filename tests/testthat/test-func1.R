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
  expect_warning(pshd(graph1, graph4, a = 0.1), "Second network has more nodes than first network.
            Augmenting the first network with rows and columns of 0's.")
  expect_warning(pshd(graph1, graph4, a = 1.1), "Second network has more nodes than first network.
            Augmenting the first network with rows and columns of 0's.")
})


