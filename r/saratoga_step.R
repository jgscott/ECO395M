library(tidyverse)
library(mosaic)
library(foreach)
library(doMC)  # for parallel computing
data(SaratogaHouses)

summary(SaratogaHouses)

# baseline medium model with 11 main effects
lm_medium = lm(price ~ lotSize + age + livingArea + pctCollege + bedrooms + 
		fireplaces + bathrooms + rooms + heating + fuel + centralAir, data=SaratogaHouses)


### forward selection
lm0 = lm(price ~ 1, data=SaratogaHouses)
lm_forward = step(lm0, direction='forward',
	scope=~(lotSize + age + livingArea + pctCollege + bedrooms + 
		fireplaces + bathrooms + rooms + heating + fuel + centralAir +
		landValue + sewer + newConstruction + waterfront)^2)


 # backward selection?
lm_big = lm(price ~ (lotSize + age + livingArea + pctCollege + bedrooms + 
		fireplaces + bathrooms + rooms + heating + fuel + centralAir +
		landValue + sewer + newConstruction + waterfront)^2, data= SaratogaHouses)
drop1(lm_big)


# stepwise selection
# note that we start with a reasonable guess
lm_step = step(lm_medium, 
			scope=~(. + landValue + sewer + newConstruction + waterfront)^3)
# the scope statement says:
# "consider all pairwise interactions for everything in lm_medium (.),
# along with the other variables explicitly named that weren't in medium"

# what variables are included?
getCall(lm_step)
coef(lm_step)


# Compare out of sample performance
rmse = function(y, yhat) {
  sqrt( mean( (y - yhat)^2 ) )
}

n = nrow(SaratogaHouses)
n_train = round(0.8*n)  # round to nearest integer
n_test = n - n_train
rmse_vals = do(100)*{
  
  # re-split into train and test cases with the same sample sizes
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  saratoga_train = SaratogaHouses[train_cases,]
  saratoga_test = SaratogaHouses[test_cases,]
  
  # Fit to the training data
  # use `update` to refit the same model with a different set of data
  lm1 = update(lm_medium, data=saratoga_train)
  lm2 = update(lm_step, data=saratoga_train)
  
  # Predictions out of sample
  yhat_test1 = predict(lm1, saratoga_test)
  yhat_test2 = predict(lm2, saratoga_test)
  
  c(rmse(saratoga_test$price, yhat_test1),
    rmse(saratoga_test$price, yhat_test2))
}

# noticeable improvement over the starting point!
colMeans(rmse_vals)
