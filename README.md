Penalized Structural Hamming Distance Package
==========================

Please read the following before attempting to install or use the *pshd* package:

## Intended use

Bayesian approaches to learning network structure have been highly varied in their approaches for selecting a point estimate from a set of posterior samples \cite{scutari2019review}. One proposed loss function is the structural Hamming distance, which simply adds up the number of disagreements between directed edge presence at each pair of nodes between two network structures \cite{tsamardinos2006hamming}. In other words, it adds a 1 where two directed edges disagree and adds 0 otherwise. Penalized structural Hamming distance is an extension which allows the user to incorporate different penalty parameters when summing the edge disagreements. For instance, a penalty higher than 1 could be assigned when network A contains an edge which network B does not, and a penalty of less than 1 could be assigned when network B contains an edge not contained in network A.

The *pshd* function is a simple function which calculates the penalized structural Hamming distance (or PSHD loss) between two supplied network structures in adjacency matrix form. The *expected_pshd* function takes this a step further, calculating the PSHD loss between a supplied network and each network in a set of samples, averaging each loss to get an estimate of the expected PSHD loss. Lastly, the *estimate_pshd* function iterates through a set of adjacency matrix samples to find the sample with minimal expected PSHD loss. In all three of these functions, the penalty parameter $a$ can be specified by the user as any value strictly between 0 and 2, but it defaults to 1 otherwise. Note that the functions do not take $b$ as an argument, because $b$ will be automatically taken as $b=2-a$ for the specified value of $a$.

## Installation instructions


## Remainder of work for project


## Other

When I originally proposed this idea for my project, I called it GSHD for Generalized Structural Hamming Distance. I changed it to PSHD (penalized instead of generalized) because I found a paper that defines GSHD as something slightly different.

