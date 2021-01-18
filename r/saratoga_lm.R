library(tidyverse)
library(ggplot2)
library(modelr)
library(rsample)
library(mosaic)
data(SaratogaHouses)

summary(SaratogaHouses)

# Baseline model
lm_small = lm(price ~ bedrooms + bathrooms + lotSize, data=SaratogaHouses)

# 11 main effects
lm_medium = lm(price ~ lotSize + age + livingArea + bedrooms + 
		fireplaces + bathrooms + rooms + heating + fuel + centralAir, data=SaratogaHouses)

# Sometimes it's easier to name the variables we want to leave out
# The command below yields exactly the same model.
# the dot (.) means "all variables not named"
# the minus (-) means "exclude this variable"
lm_medium2 = lm(price ~ . - pctCollege - sewer - waterfront - landValue - newConstruction, data=SaratogaHouses)

coef(lm_medium)
coef(lm_medium2)

# All interactions
# the ()^2 says "include all pairwise interactions"
lm_big = lm(price ~ (. - pctCollege - sewer - waterfront - landValue - newConstruction)^2, data=SaratogaHouses)


####
# Compare out-of-sample predictive performance
####

# Split into training and testing sets
saratoga_split = initial_split(SaratogaHouses, prop = 0.8)
saratoga_train = training(saratoga_split)
saratoga_test = testing(saratoga_split)
	
# Fit to the training data
lm1 = lm(price ~ lotSize + bedrooms + bathrooms, data=saratoga_train)
lm2 = lm(price ~ . - pctCollege - sewer - waterfront - landValue - newConstruction, data=saratoga_train)
lm3 = lm(price ~ (. - pctCollege - sewer - waterfront - landValue - newConstruction)^2, data=saratoga_train)

# Predictions out of sample
# Root mean squared error
rmse(lm1, saratoga_test)
rmse(lm2, saratoga_test)
rmse(lm3, saratoga_test)

# Can you hand-build a model that improves on all three?
# Remember feature engineering, and remember not just to rely on a single train/test split
