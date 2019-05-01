library(randomForest)
library(gbm)


load_coast = read.csv('../data/load_coast.csv', row.names=1)
N = nrow(load_coast)

# split into a training and testing set
train_frac = 0.8
N_train = floor(train_frac*N)
N_test = N - N_train
train_ind = sample.int(N, N_train, replace=FALSE) %>% sort
load_train = load_coast[train_ind,]
load_test = load_coast[-train_ind,]

# let's do bagging first
# average over 25 bootstrap samples
# use all candidate variables (mtry=15) in each bootstrapped sample
forest1 = randomForest(COAST ~ ., data = load_train, mtry = 15, ntree=25)
yhat_forest = predict(forest1, load_test)
rmse_forest = mean((yhat_forest - load_test$COAST)^2) %>% sqrt


# now true random forests
# now average over 25 bootstrap samples
# this time only 5 candidate variables (mtry=5) in each bootstrapped sample
forest2 = randomForest(COAST ~ ., data = load_train, mtry = 5, ntree=100)
yhat_forest2 = predict(forest2, load_test)
rmse_forest2 = mean((yhat_forest2 - load_test$COAST)^2) %>% sqrt

