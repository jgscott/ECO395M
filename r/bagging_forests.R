library(randomForest)


ethanol = read.csv('../data/ethanol.csv')
plot(NOx ~ E, data=ethanol)

# split into a training and testing set
N = nrow(ethanol)
train_frac = 0.8
N_train = floor(train_frac*N)
N_test = N - N_train
train_ind = sample.int(N, N_train, replace=FALSE) %>% sort
ethanol_train = ethanol[train_ind,]
ethanol_test = ethanol[-train_ind,]

# note: using random forests here but this is actually bagging
# (only 1 predictor!)
forest1 = randomForest(NOx ~ E, mtry=1, nTree=100, data=ethanol_train)

plot(NOx ~ E, data=ethanol_train)
points(predict(forest1) ~ E, data=ethanol_train, pch=19, col='red')

yhat_forest_test = predict(forest1, ethanol_test)
rmse_forest = mean((ethanol_test$NOx - yhat_forest_test)^2) %>% sqrt
rmse_forest


# also boosting
library(gbm)

boost1 = gbm(NOx ~ E, data=ethanol_train, 
               interaction.depth=2, n.trees=500, shrinkage=.05)

plot(NOx ~ E, data=ethanol_train)
points(predict(boost1, n.trees=500) ~ E, data=ethanol_train, pch=19, col='red')

yhat_boost_test = predict(boost1, ethanol_test, n.trees=100)
rmse_boost = mean((ethanol_test$NOx - yhat_boost_test)^2) %>% sqrt
rmse_boost


big.tree = rpart(NOx ~ E, method="anova",data=ethanol_train,
                 control=rpart.control(minsplit=2, cp=0.0005, xval=10))

cp_grid = big.tree$cptable[,'CP']
tree_rmse_grid = rep(0, length(cp_grid))
for(i in seq_along(cp_grid)) {
  this_tree = prune(big.tree, cp=cp_grid[i])
  yhat_tree_test = predict(this_tree, ethanol_test)
  tree_rmse_grid[i] = mean((ethanol_test$NOx - yhat_tree_test)^2) %>% sqrt
}


# both bagging and boosting do better
plot(cp_grid, tree_rmse_grid, log='x')
abline(h=rmse_forest, col='red')
abline(h=rmse_boost, col='blue')


