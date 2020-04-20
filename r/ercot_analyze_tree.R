library(tidyverse)
library(rpart)


load_coast = read.csv('../data/load_coast.csv', row.names=1)
N = nrow(load_coast)

# split into a training and testing set
train_frac = 0.8
N_train = floor(train_frac*N)
N_test = N - N_train
train_ind = sample.int(N, N_train, replace=FALSE) %>% sort
load_train = load_coast[train_ind,]
load_test = load_coast[-train_ind,]


# using rpart on the training data
# great vignette at
# https://cran.r-project.org/web/packages/rpart/vignettes/longintro.pdf

# method = "anova" means make splits based on sums of squared erros
big.tree = rpart(COAST ~ ., method="anova",data=load_train,
          control=rpart.control(minsplit=5, cp=1e-6, xval=10))
# see ?rpart.control for fitting details
#  e.g. minsplit = minimum number of observations in a node in order
#  					for a split to be attempted.
# xval = number of CV folds


# how big is the tree? huge!!
nbig = length(unique(big.tree$where))
nbig

# look at the cross-validated error
plotcp(big.tree)
head(big.tree$cptable)

# calculate the cv error + 1 standard error
# the minimum serves as our threshold
err_1se = big.tree$cptable[,'xerror'] + big.tree$cptable[,'xstd']
err_thresh = min(err_1se)

# now find the simplest tree that beats this threshold
big.tree$cptable[,'xerror'] - err_thresh
which(big.tree$cptable[,'xerror'] - err_thresh < 0) %>% head
bestcp = big.tree$cptable[798,'CP']

cvtree = prune(big.tree, cp=bestcp)
length(unique(cvtree$where))

# a very deep tree
plot(cvtree)
log2(length(unique(cvtree$where)))

plot(predict(cvtree))

# visualize the predictions on the training data
plot(load_train$KHOU_temp, predict(cvtree))
plot(load_train$KHOU_dewpoint, predict(cvtree))

boxplot(predict(cvtree) ~ factor(day), data=load_train)
boxplot(predict(cvtree) ~ factor(month), data=load_train)

plot(load_train$PC1, predict(cvtree))
plot(load_train$PC4, predict(cvtree))
plot(load_train$PC5, predict(cvtree))

# predictions vs actual values
plot(predict(cvtree), load_train$COAST)

# check error on hold-old data versus simple model
yhat_test_tree = predict(cvtree, load_test)

lm2 = lm(COAST ~ poly(KHOU_temp, 2) + poly(KHOU_dewpoint, 2) + 
           poly(PC1, 2) + factor(day) + factor(month), data=load_train)
yhat_test_lm2 = predict(lm2, load_test)

mean((yhat_test_lm2 - load_test$COAST)^2) %>% sqrt
mean((yhat_test_tree - load_test$COAST)^2) %>% sqrt
