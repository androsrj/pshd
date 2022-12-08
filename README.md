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

Suppose *graph1* and *graph2* are both square adjacency matrices, each representing the strucure of a particular DAG. This means that they are binary and contain all zeroes on their diagonals. Then the following could be used to compute the structural Hamming distance between them:



## Other

When I originally proposed this idea for my project, I called it GSHD for Generalized Structural Hamming Distance. I changed it to PSHD (penalized instead of generalized) because I found a paper that defines GSHD as something slightly different.

Some parts of this package, especially the *estimate_pshd()* function, could certainly benefit from parallelization. I had already finished the code by the time we learned about parallelization in class, and thus it is not yet implemented in parallel. However, this is definitely one of the next things I plan to work on in developing this package.
