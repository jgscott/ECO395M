library(tidyverse)
library(randomForest)
library(gbm)
library(pdp)

load_coast = read.csv('../data/load_coast.csv', row.names=1)
N = nrow(load_coast)

# split into a training and testing set
train_frac = 0.8
N_train = floor(train_frac*N)
N_test = N - N_train
train_ind = sample.int(N, N_train, replace=FALSE) %>% sort
load_train = load_coast[train_ind,]
load_test = load_coast[-train_ind,]

# random forests
# average over ntree bootstrap samples
# 5 candidate variables (mtry=5) in each bootstrapped sample
forest2 = randomForest(COAST ~ ., data = load_train, mtry = 5, ntree=100)
yhat_forest2 = predict(forest2, load_test)
rmse_forest2 = mean((yhat_forest2 - load_test$COAST)^2) %>% sqrt

# partial dependence plot: temp
forest2 %>%
	partial(pred.var = "KHOU_temp") %>% autoplot


# partial dependence plot: dewpoint
forest2 %>%
	partial(pred.var = "KHOU_dewpoint") %>% autoplot

# partial dependence plot: hour
forest2 %>%
	partial(pred.var = "hour") %>% autoplot

# partial dependence plot: day
forest2 %>%
	partial(pred.var = "day") %>% autoplot

# partial dependence plot: PC1
forest2 %>%
	partial(pred.var = "PC1") %>% autoplot


# partial dependence plot: PC5
forest2 %>%
	partial(pred.var = "PC5") %>% autoplot

