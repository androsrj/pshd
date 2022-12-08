[![codecov](https://codecov.io/gh/androsrj/pshd/branch/master/graph/badge.svg?token=MJWWLB4PU4)](https://codecov.io/gh/androsrj/pshd) \
Penalized Structural Hamming Distance Package
==========================

Please read the following before attempting to install or use the *pshd* package:

## Intended use

Recall that the penalized structural Hamming distance is an extension which allows the user to incorporate different penalty parameters when summing the edge disagreements between two network structures (Tsamardinos, 2006). For instance, a penalty higher than 1 could be assigned when network A contains an edge which network B does not, and a penalty of less than 1 could be assigned when network B contains an edge not contained in network A. The *pshd* function is a simple function which calculates the penalized structural Hamming distance (or PSHD loss) between two supplied network structures in adjacency matrix form. The *expected_pshd* function takes this a step further, calculating the PSHD loss between a supplied network and each network in a set of samples, averaging each loss to get an estimate of the expected PSHD loss. Lastly, the *estimate_pshd* function iterates through a set of adjacency matrix samples to find the sample with minimal expected PSHD loss. In all three of these functions, the penalty parameter $a$ can be specified by the user as any value strictly between 0 and 2, but it defaults to 1 otherwise. Note that the functions do not take $b$ as an argument, because $b$ will be automatically taken as $b=2-a$ for the specified value of $a$. For more details on each function, see the vignette.

## Installation instructions

To install the *pshd* package, use the *install_github* function from the *devtools* library:

``` install
devtools::install_github("https://github.com/androsrj/pshd")
library(pshd)
```

## Examples

Suppose *g1* and *2* are both square adjacency matrices, each representing the strucure of a particular DAG. This means that they are binary and contain all zeroes on their diagonals. These could be generated as follows (although in practice, they should come from samples of a posterior DAG distribution):

```{r}
p <- 4
g1 <- matrix(sample(c(0, 1), p^2, replace = TRUE), nrow = p, ncol = p)
g2 <- matrix(sample(c(0, 1), p^2, replace = TRUE), nrow = p, ncol = p)
diag(g1) <- 0
diag(g2) <- 0
```

The first line of code below would compute the traditional structural Hamming distance (equal penalties) betwee the two graphs. The second line computes the PSHD for $a=1.5$ and $b=0.5$:
```{r}
pshd(g1, g2)
pshd(g1, g2, a = 1.5)
```

To demonstrate the use of the *expected_pshd()* and *estimate_pshd()* functions, we will need to generate a set of samples of these DAG adjacency matrices. For simplicity, this example simply generates one maximum-density graph *g* (which contains edges at every possible location besides the diagonal) and replicates it to generate 25 samples. In practice, these samples should be obtained from an MCMC method used to approximate the posterior distribution of the DAG of interest:
```{r}
nSamples <- 25
p <- 4
g <- 1 - diag(p)
samples <- replicate(nSamples, g, simplify = FALSE)
```

Then, we can use the following to estimate the expected loss of a singular graph *g* given all the other samples (which in this case would be zero, regardless of the value of $a$):
```{r}
expected_pshd(g, samples)
expected_pshd(g, samples, a = 1.5)
```

As for the *estimate_pshd()* function, we only supply the samples and the value of $a$. That is, there is no argument for a specific graph *g*. That is because this function obtains a PSHD-minimizing estimate from the samples by estimating the expected PSHD loss for each one:
```{r}
estimate_pshd(samples)
estimate_pshd(samples, a = 0.1)
estimate_pshd(samples, a = 1.9)
```

For more in-depth examples, see the vignette.

## Other

When I originally proposed this idea for my project, I called it GSHD for Generalized Structural Hamming Distance. I changed it to PSHD (penalized instead of generalized) because I found a paper that defines GSHD as something slightly different.

Some parts of this package, especially the *estimate_pshd()* function, could certainly benefit from parallelization. I had already finished the code by the time we learned about parallelization in class, and thus it is not yet implemented in parallel. However, this is definitely one of the next things I plan to work on in developing this package.
