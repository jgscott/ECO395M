###
# Orange juice regression
###
library(tidyverse)
library(ggplot2)
library(rsample)
library(modelr)

## read in the data
oj = read.csv("../data/oj.csv") 

head(oj)

# 
ggplot(data=oj) + 
  geom_boxplot(aes(x=brand, y = price))

ggplot(data=oj) + 
  geom_boxplot(aes(x=brand, y = logmove))

ggplot(oj) + geom_point(aes(x=price, y=logmove))


###
# Dummy variables
###

reg = lm(logmove ~ log(price) + brand, data=oj)

## inspect the fitted model
summary(reg) ## coef, tests, fit

## create some data for prediction, using the data.frame function
## note the care in specifying brand factor (levels must match original data)
## we don't need all variables in oj; just those used as covariates in reg.
newdata=expand.grid(price=c(1.5,2,2.5, 3), 
	brand=factor(c("tropicana","minute.maid","dominicks")))
newdata

## predict
predict(reg, newdata=newdata)  ## predicted log units moved
exp(predict(reg, newdata=newdata)) ## predicted # of units moved

## under the hood: `design matrices' and model.matrix
# here's the underlying model matrix
x = model.matrix( ~ log(price) + brand, data=oj)
mosaic::sample(x, 10)  # show us 10 random rows

# we get the same model if we explicitly pass x to lm
# the "-1" says not to include an explicit intercept
# that's because we already have one in the model matrix
reg2 = lm(logmove ~ x-1, data=oj)
summary(reg2)

# you don't have to do this for vanilla lm.
# but it's good to know how to construct the model matrix explicitly,
# since you often have to for more complex models.  

###
# Interactions
###

## note that `*' also adds the main effects automatically
reg_interact = lm(logmove ~ log(price)*brand, data=oj)
summary(reg_interact)

# let's see the explicit model matrix
x_interact = model.matrix( ~ log(price)*brand, data=oj)

# 10 random rows: each row is a vector of numbers, whose inner-product
# with the coefficient vector gives E(y | x)  
mosaic::sample(x_interact, 10) %>% round(2) # show us 10 random rows

###
# Now let's add feat to the model
###

# Option 1: main effect only
reg_ads = lm(logmove ~ log(price)*brand + feat, data=oj)
summary(reg_ads)

# Option 2: two-way interaction
reg_ads2 = lm(logmove ~ log(price)*(brand+feat), data=oj)
summary(reg_ads2)

# Option 3: three-way interaction
reg_ads3 = lm(logmove ~ log(price)*brand*feat, data=oj)
summary(reg_ads3)


## fit plots for the 3-way interaction

# Add predictions to the data frame
oj$reg_ads3_fitted = fitted(reg_ads3)

p_base = ggplot(data=oj) + 
  geom_point(aes(x=log(price), y = logmove, color=factor(feat)), alpha=0.1) + 
  facet_grid(~brand)
p_base

# shape = 21 gives you points with black circles around them
# the fill aesthetic maps to whether or not feat=1
p_base + geom_point(aes(x=log(price), y = reg_ads3_fitted, fill=factor(feat)),
                    shape=21)


# Let's compare out-of-sample fit for our three models with feat

# Make a train-test split
oj_split =  initial_split(oj, prop=0.8)
oj_train = training(oj_split)
oj_test  = testing(oj_split)

# Update our models to use training data only
reg_ads = update(reg_ads, data=oj_train)
reg_ads2 = update(reg_ads2, data=oj_train)
reg_ads3 = update(reg_ads3, data=oj_train)

# RMSEs
rmse(reg_ads, oj_test)
rmse(reg_ads2, oj_test)
rmse(reg_ads3, oj_test)

# Let's be a little more systematic and use K-fold cross validation
oj_folds = crossv_kfold(oj, k=10)

# map the model-fitting function over the training sets
models1 = map(oj_folds$train, ~ lm(logmove ~ log(price)*brand + feat, data=.))
models2 = map(oj_folds$train, ~ lm(logmove ~ log(price)*(brand + feat), data=.))
models3 = map(oj_folds$train, ~ lm(logmove ~ log(price)*brand*feat, data=.))

# map the RMSE calculation over the trained models and test sets simultaneously
map2_dbl(models1, oj_folds$test, modelr::rmse) %>% mean
map2_dbl(models2, oj_folds$test, modelr::rmse) %>% mean
map2_dbl(models3, oj_folds$test, modelr::rmse) %>% mean
