library(tidyverse)
library(mosaic)
data(SaratogaHouses)

summary(SaratogaHouses)

n = nrow(SaratogaHouses)

rmse_vals = do(100)*{
  
  # re-split into train and test cases
  n_train = round(0.8*n)  # round to nearest integer
  n_test = n - n_train
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  saratoga_train = SaratogaHouses[train_cases,]
  saratoga_test = SaratogaHouses[test_cases,]
  
  # fit to this training set
  lm2 = lm(price ~ . - sewer - waterfront - landValue - newConstruction, data=saratoga_train)
  
  lm_boom = lm(price ~ lotSize + age + pctCollege + 
                 fireplaces + rooms + heating + fuel + centralAir +
                 bedrooms*rooms + bathrooms*rooms + 
                 bathrooms*livingArea, data=saratoga_train)
  
  lm_biggerboom = lm(price ~ lotSize + waterfront + newConstruction + bedrooms*bathrooms + heating + fuel + pctCollege + rooms*bedrooms + rooms*bathrooms + rooms*heating + livingArea, data=saratoga_train)
  
  
  # predict on this testing set
  yhat_test2 = predict(lm2, saratoga_test)
  yhat_testboom = predict(lm_boom, saratoga_test)
  yhat_testbiggerboom = predict(lm_biggerboom, saratoga_test)
  c(rmse(saratoga_test$price, yhat_test2),
    rmse(saratoga_test$price, yhat_testboom),
    rmse(saratoga_test$price, yhat_testbiggerboom))
}

rmse_vals
colMeans(rmse_vals)