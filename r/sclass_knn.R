library(tidyverse)
library(ggplot2)
library(caret)
library(modelr)
library(rsample)
library(foreach)
library(parallel)

sclass = read.csv('../data/sclass.csv')

# The variables involved
summary(sclass)

# Focus on first trim level: 350
sclass350 = filter(sclass, trim == '350')

# K-fold cross validation
K_folds = 20
sclass350_folds = crossv_kfold(sclass350, k=K_folds)

# create a grid of K values -- the precise grid isn't important as long
# as you cover a wide range
k_grid = c(2:80)

# For each value of k, map the model-fitting function over the folds
# Using the same folds is important, otherwise we're not comparing
# models across the same train/test splits
cv_grid = foreach(k = k_grid, .combine='rbind') %dopar% {
  models = map(sclass350_folds$train, ~ knnreg(price ~ mileage, k=k, data = ., use.all=FALSE))
  errs = map2_dbl(models, sclass350_folds$test, modelr::rmse)
  c(k=k, err = mean(errs), std_err = sd(errs)/sqrt(K_folds))
} %>% as.data.frame

# plot means and std errors versus k
ggplot(cv_grid) + 
  geom_point(aes(x=k, y=err)) + 
  geom_errorbar(aes(x=k, ymin = err-std_err, ymax = err+std_err))


# Now repeat for the 65 AMGs
sclass65AMG = subset(sclass, trim == '65 AMG')
sclass65AMG_folds = crossv_kfold(sclass65AMG, k=K_folds)

cv_grid2 = foreach(k = k_grid, .combine='rbind') %dopar% {
  models = map(sclass65AMG_folds$train, ~ knnreg(price ~ mileage, k=k, data = ., use.all=FALSE))
  errs = map2_dbl(models, sclass65AMG_folds$test, modelr::rmse)
  c(k=k, err = mean(errs), std_err = sd(errs)/sqrt(K_folds))
} %>% as.data.frame


# plot means and std errors versus k
ggplot(cv_grid2) + 
  geom_point(aes(x=k, y=err)) + 
  geom_errorbar(aes(x=k, ymin = err-std_err, ymax = err+std_err))
