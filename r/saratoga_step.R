library(tidyverse)
library(mosaic)
library(foreach)
library(modelr)
library(rsample)
data(SaratogaHouses)

# Split into training and testing sets
saratoga_split = initial_split(SaratogaHouses, prop = 0.8)
saratoga_train = training(saratoga_split)
saratoga_test = testing(saratoga_split)

# baseline medium model with 11 main effects
lm_medium = lm(price ~ lotSize + age + livingArea + pctCollege + bedrooms + 
		fireplaces + bathrooms + rooms + heating + fuel + centralAir, data=saratoga_train)


### forward selection
lm0 = lm(price ~ 1, data=saratoga_train)
lm_forward = step(lm0, direction='forward',
	scope=~(lotSize + age + livingArea + pctCollege + bedrooms + 
	          fireplaces + bathrooms + rooms + heating + fuel + centralAir)^2)


 # backward selection?
lm_big = lm(price ~ (lotSize + age + livingArea + pctCollege + bedrooms + 
		fireplaces + bathrooms + rooms + heating + fuel + centralAir +
		landValue + sewer + newConstruction + waterfront)^2, data= saratoga_train)
drop1(lm_big)


# stepwise selection
# note that we start with a reasonable guess
lm_step = step(lm_medium, 
			scope=~(.)^2)
# the scope statement says:
# "consider all two-way interactions for everything in lm_medium (.)

# what variables are included?
getCall(lm_step)
coef(lm_step)

rmse(lm_medium, saratoga_test)
rmse(lm_big, saratoga_test)
rmse(lm_forward, saratoga_test)
rmse(lm_step, saratoga_test)
