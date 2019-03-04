library(tidyverse)

# read in data
countdata = read.csv("../data/congress109.csv", header=TRUE, row.names=1)
memberdata = read.csv("../data/congress109members.csv", header=TRUE, row.names=1)

# corpus statistics
N = nrow(countdata)
D = ncol(countdata)


# First split into a training and set set
X_NB = countdata
y_NB = 0+{memberdata$party == 'R'}

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

# now try a query doc in the test set
i = 1
test_doc = X_test[i,]
sum(test_doc * log(pvec_0))
sum(test_doc * log(pvec_1))
y_test[i]


# classify all the docs in the test set
yhat_test = foreach(i = seq_along(test_set), .combine='c') %do% {
  test_doc = X_test[i,]
  logp0 = sum(test_doc * log(pvec_0))
  logp1 = sum(test_doc * log(pvec_1))
  0 + {logp1 > logp0}
}

confusion_matrix = xtabs(~y_test + yhat_test)
confusion_matrix

# overall error rate
1-sum(diag(confusion_matrix))/length(test_set)
