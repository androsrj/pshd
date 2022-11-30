# 3 Dimensions
graph1 <- matrix(c(0, 1, 0,
                   1, 0, 0,
                   0, 1, 0), nrow = 3, byrow = TRUE)
graph2 <- matrix(c(0, 0, 1,
                   1, 0, 1,
                   0, 1, 0), nrow = 3, byrow = TRUE)

test_that("PSHD Loss is Computed Correctly, 3 Dimensions", {
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

test_that("PSHD Loss is Computed Correctly, 5 Dimensions", {
  expect_equal(pshd(graph3, graph4, a = 1), 7)
  expect_equal(pshd(graph3, graph4, a = 0.25), 7.75)
  expect_equal(pshd(graph3, graph4, a = 1.6), 6.4)
})

# Mismatching dimensions (3 and 5)
# Warnings are to be expected here
test_that("PSHD Loss is Computed Correctly, Mismatching Dimensions", {
  expect_equal(pshd(graph1, graph4, a = 1), 11)
  expect_equal(pshd(graph1, graph4, a = 0.1), 19.1)
  expect_equal(pshd(graph1, graph4, a = 1.1), 10.1)
})


