Penalized Structural Hamming Distance Package
==========================

Please read the following before attempting to install or use the *pshd* package:

## Intended use

Recall that the penalized structural Hamming distance is an extension which allows the user to incorporate different penalty parameters when summing the edge disagreements between two network structures (Tsamardinos, 2006). For instance, a penalty higher than 1 could be assigned when network A contains an edge which network B does not, and a penalty of less than 1 could be assigned when network B contains an edge not contained in network A. The *pshd* function is a simple function which calculates the penalized structural Hamming distance (or PSHD loss) between two supplied network structures in adjacency matrix form. The *expected_pshd* function takes this a step further, calculating the PSHD loss between a supplied network and each network in a set of samples, averaging each loss to get an estimate of the expected PSHD loss. Lastly, the *estimate_pshd* function iterates through a set of adjacency matrix samples to find the sample with minimal expected PSHD loss. In all three of these functions, the penalty parameter $a$ can be specified by the user as any value strictly between 0 and 2, but it defaults to 1 otherwise. Note that the functions do not take $b$ as an argument, because $b$ will be automatically taken as $b=2-a$ for the specified value of $a$.

## Installation instructions

To install the *pshd* package, use the *install_github* function from the *devtools* library. Type *install_github("https://github.com/androsrj/pshd")* into the R console. It does not rely on any other R packages or external software. Then, use *library(pshd)* to have easy access to all 3 functions.

## Remainder of work for project

I believe that my 3 functions are mostly complete and running as intended. All that is left for me to do is to finish all necessary compatibility checks within each function, formally cite the Tsamardinos reference above, and set up a series of extensive formal tests to ensure correctness. I also need to write up a vignette, and create examples for each function that can be visible in the documentation.

## Other

When I originally proposed this idea for my project, I called it GSHD for Generalized Structural Hamming Distance. I changed it to PSHD (penalized instead of generalized) because I found a paper that defines GSHD as something slightly different.

[![codecov](https://codecov.io/gh/androsrj/pshd/branch/master/graph/badge.svg?token=MJWWLB4PU4)](https://codecov.io/gh/androsrj/pshd)
