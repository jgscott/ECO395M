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

