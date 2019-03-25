library(tidyverse)
library(mosaic)
library(foreach)
library(doMC)  # for parallel computing
library(FNN)
data(SaratogaHouses)

summary(SaratogaHouses)

# baseline medium model with 11 main effects
lm_medium = lm(price ~ lotSize + age + livingArea + pctCollege + bedrooms + 
		fireplaces + bathrooms + rooms + heating + fuel + centralAir, data=SaratogaHouses)


# stepwise selection: note I'm cheating a bit here :-)
# we'll learn this soon!
lm_step = step(lm_medium,
               scope=~(. + landValue + sewer + newConstruction + waterfront)^2)
# the scope statement says:
# "consider all pairwise interactions for everything in lm_medium (.),
# along with the other variables explicitly named that weren't in medium"

length(coef(lm_step))
length(coef(lm_medium))

# what variables are included?
getCall(lm_step)
coef(lm_step)

####
# Compare out-of-sample predictive performance
####

# I'll use LOOCV with parallel processing
registerDoMC(cores=4)  # tell R how many cores you're playing with

N = nrow(SaratogaHouses)
loo_mse = foreach(i = 1:N, .combine='rbind') %dopar% {
  saratoga_train = SaratogaHouses[-i,]
  saratoga_test = SaratogaHouses[i,]
  
  # fit the models
  lm_medium_train = update(lm_medium, data=saratoga_train)
  lm_step_train = update(lm_step, data=saratoga_train)
  
  # make predictions
  yhat_medium_test = predict(lm_medium_train, saratoga_test)
  yhat_step_test = predict(lm_step_train, saratoga_test)
  
  # check performance
  mse_medium = (yhat_medium_test - saratoga_test$price)^2
  mse_step = (yhat_step_test - saratoga_test$price)^2
  
  # return results from the loop
  c(mse_medium, mse_step)
}

# noticeable improvement
sqrt(colMeans(loo_mse))

# Note: you plausibly could do better hand-building a model!
# but as you've seen, it can be painful

# next: can we improve things by using KNN instead of a linear model?
# we use the same main effects as in lm_step
# but none of the interactions (KNN should find these)
getCall(lm_step)
# use model.matrix
# (note the -1, which says to leave off a column of 1's for an intercept)
X_all = model.matrix(~lotSize + age + livingArea + pctCollege + 
                       bedrooms + fireplaces + bathrooms + rooms + heating + fuel +
                       centralAir + landValue + waterfront + newConstruction - 1,
                     data=SaratogaHouses)
head(X_all)

# standardize the columns of X_all
feature_sd = apply(X_all, 2, sd)
X_std = scale(X_all, scale=feature_sd)

# now use LOOCV across a grid of values for K
k_grid = seq(3, 51, by=2)

# loop over the individual data points for leave-one-out
loo_mse2 = foreach(i = 1:N, .combine='rbind') %dopar% {
  X_train = X_std[-i,]
  X_test = X_std[i,]
  y_train = SaratogaHouses$price[-i]
  y_test = SaratogaHouses$price[i]
  
  # fit the models: loop over k
  knn_mse_out = foreach(k = k_grid, .combine='c') %do% {
    knn_fit = knn.reg(X_train, X_test, y_train, k)
    (y_test - knn_fit$pred)^2  # return prediction
  }

  # return results from the loop over k
  knn_mse_out
}

knn_rmse = sqrt(colMeans(loo_mse2))

# note that this bottoms off at a much higher level
# than the RMSE from the linear model with "hand-built" interactions.
# What does this tell us?
plot(k_grid, knn_rmse)
