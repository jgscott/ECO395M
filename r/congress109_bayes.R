library(tidyverse)
library(foreach)

# read in data
congress109 = read.csv("../data/congress109.csv", header=TRUE, row.names=1)
congress109members = read.csv("../data/congress109members.csv", header=TRUE, row.names=1)

# corpus statistics
N = nrow(congress109)
D = ncol(congress109)


# First split into a training and set set
X_NB = congress109  # feature matrix
y_NB = 0+{congress109members$party == 'R'}  # target variable

train_frac = 0.8
train_set = sort(sample.int(N, floor(train_frac*N)))
test_set = setdiff(1:N, train_set)

# training and testing matrices
# Notice the smoothing (pseudo-count) to the training matrix
# this ensures we don't have zero-probability events
X_train = X_NB[train_set,] + 1/D
y_train = y_NB[train_set]
X_test = X_NB[test_set,]
y_test = y_NB[test_set]

# First construct our vectors of probabilities under D (0) and R (1) classes
# smoothing the training matrix of counts was important so that we get no zeros here
pvec_0 = colSums(X_train[y_train==0,])
pvec_0 = pvec_0/sum(pvec_0)
pvec_1 = colSums(X_train[y_train==1,])
pvec_1 = pvec_1/sum(pvec_1)


# bar plots of most R and D phrases
sort(pvec_0) %>% sort(decreasing=TRUE) %>% head(25) %>% barplot(las=2, cex.names=0.6)
sort(pvec_1) %>% sort(decreasing=TRUE) %>% head(25) %>% barplot(las=2, cex.names=0.6)

# priors
priors = table(y_train) %>% prop.table


# now try a query doc in the test set
i = 5
test_doc = X_test[i,]
test_doc %>% sort
sum(test_doc * log(pvec_0)) + log(priors[1])
sum(test_doc * log(pvec_1)) + log(priors[2])
y_test[i]


# classify all the docs in the test set
yhat_test = foreach(i = seq_along(test_set), .combine='c') %do% {
  test_doc = X_test[i,]
  logp0 = sum(test_doc * log(pvec_0)) + log(priors[1])
  logp1 = sum(test_doc * log(pvec_1)) + log(priors[2])
  0 + {logp1 > logp0}
}

confusion_matrix = table(y_test, yhat_test)
confusion_matrix

# overall error rate
1-sum(diag(confusion_matrix))/length(test_set)

# pretty good!
