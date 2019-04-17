# Load data on gene expression in cancer cells
library(ISLR)
library(tidyverse)

data(NCI60)
nci.labs = NCI60$labs
nci.data = NCI60$data

table(nci.labs)
dim(nci.data)  # 64 cancer cells (N), 6830 gene expression scores (P)

pr_NCI = prcomp(nci.data, scale=TRUE)
summary(pr_NCI)
plot(pr_NCI)

# the first two principal component scores
biplot(pr_NCI)

# A biplot I like a bit better
# qplot is a shortcut for lots of ggplot2's functions
scores = pr_NCI$x
qplot(scores[,1], scores[,2], color=nci.labs, xlab='Component 1', ylab='Component 2')

qplot(scores[,1], scores[,2], facets=~nci.labs, xlab='Component 1', ylab='Component 2')

# three scatterplots for PCs 1-3
qplot(scores[,1], scores[,2], facets=~nci.labs, xlab='Component 1', ylab='Component 2')
qplot(scores[,1], scores[,3], facets=~nci.labs, xlab='Component 1', ylab='Component 2')
qplot(scores[,2], scores[,3], facets=~nci.labs, xlab='Component 1', ylab='Component 2')


# now calculate a distance matrix based on the first five principal components
# key idea: using the PC scores (K=5) rather than the full data matrix(P=6830)
# is a form of denoising.
D_NCI = dist(scores[,1:5])
hclust_NCI = hclust(D_NCI, method='complete')
plot(hclust_NCI, labels=nci.labs)

