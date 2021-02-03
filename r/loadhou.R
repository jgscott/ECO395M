library(tidyverse)
library(ggplot2)
library(rsample)  # for creating train/test splits
library(caret)
library(modelr)
library(parallel)
library(foreach)

# read in the data: make sure to use the path name to
# wherever you'd stored the file
loadhou = read.csv('../data/loadhou.csv')
summary(loadhou)

# plot the data
ggplot(data = loadhou) + 
  geom_point(mapping = aes(x = KHOU, y = COAST), color='darkgrey') + 
  ylim(7000, 20000)

# Make a train-test split
loadhou_split =  initial_split(loadhou, prop=0.9)
loadhou_train = training(loadhou_split)
loadhou_test  = testing(loadhou_split)


#####
# Fit a few models
#####

# linear and quadratic models
lm1 = lm(COAST ~ KHOU, data=loadhou_train)
lm2 = lm(COAST ~ poly(KHOU, 2), data=loadhou_train)

# KNN with K = 100
knn100 = knnreg(COAST ~ KHOU, data=loadhou_train, k=100)
rmse(knn100, loadhou_test)

####
# plot the fit
####

# attach the predictions to the test data frame
loadhou_test = loadhou_test %>%
  mutate(COAST_pred = predict(knn100, loadhou_test))

p_test = ggplot(data = loadhou_test) + 
  geom_point(mapping = aes(x = KHOU, y = COAST), alpha=0.2) + 
  ylim(7000, 20000)
p_test

# now add the predictions
p_test + geom_line(aes(x = KHOU, y = COAST_pred), color='red', size=1.5)



###
# K-fold cross validation
###

# a lot of models and packages in R have their own built-in
# pipelines that make cross validation super easy.

# But we'll see two generic pipelines here.  
K_folds = 5

# Pipeline 1:
# create specific fold IDs for each row
# the default behavior of sample actually gives a permutation
loadhou = loadhou %>%
  mutate(fold_id = rep(1:K_folds, length=nrow(loadhou)) %>% sample)

head(loadhou)

# now loop over folds
rmse_cv = foreach(fold = 1:K_folds, .combine='c') %do% {
  knn100 = knnreg(COAST ~ KHOU,
                  data=filter(loadhou, fold_id != fold), k=100)
  modelr::rmse(knn100, data=filter(loadhou, fold_id == fold))
}

rmse_cv
mean(rmse_cv)  # mean CV error
sd(rmse_cv)/sqrt(K_folds)   # approximate standard error of CV error

###
# a second generic pipeline: using modelr + purrr (functional programming tools)
# purrr works with a functional programming style, e.g. map/reduce
# this is cleaner, more concise, and "higher-level", but less explicit
###

loadhou_folds = crossv_kfold(loadhou, k=K_folds)

# map the model-fitting function over the training sets
models = map(loadhou_folds$train, ~ knnreg(COAST ~ KHOU, k=100, data = ., use.all=FALSE))
# "map" transforms an input by applying a function to
# each element of a list or atomic vector and returning
# an object of the same length as the input.

# map the RMSE calculation over the trained models and test sets simultaneously
errs = map2_dbl(models, loadhou_folds$test, modelr::rmse)

# note:
#  - map2 means map over two inputs simultaneously
#  - _dbl means return the result as a vector of real numbers ("doubles")

mean(errs)
sd(errs)/sqrt(K_folds)   # approximate standard error of CV error


# so now we can do this across a range of k
k_grid = c(2, 4, 6, 8, 10, 15, 20, 25, 30, 35, 40, 45,
           50, 60, 70, 80, 90, 100, 125, 150, 175, 200, 250, 300)

# Notice we use the same folds for each value of k
# this is important, otherwise we're not comparing
# models across the same train/test splits
cv_grid = foreach(k = k_grid, .combine='rbind') %dopar% {
  models = map(loadhou_folds$train, ~ knnreg(COAST ~ KHOU, k=k, data = ., use.all=FALSE))
  errs = map2_dbl(models, loadhou_folds$test, modelr::rmse)
  c(k=k, err = mean(errs), std_err = sd(errs)/sqrt(K_folds))
} %>% as.data.frame

head(cv_grid)

# plot means and std errors versus k
ggplot(cv_grid) + 
  geom_point(aes(x=k, y=err)) + 
  geom_errorbar(aes(x=k, ymin = err-std_err, ymax = err+std_err)) + 
  scale_x_log10()
