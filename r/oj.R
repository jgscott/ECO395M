###################################################
############# Orange Juice Regression #############
###################################################
library(tidyverse)

## read in the data
oj = read.csv("../data/oj.csv") 

## create some colors for the brands
levels(oj$brand)

ggplot(data=oj) + 
  geom_boxplot(aes(x=brand, y = log(price)))


plot(log(price) ~ brand, data=oj, col=brandcol)
plot(logmove ~ log(price), data=oj, col=brandcol[oj$brand])

## simple regression
reg = lm(logmove ~ log(price) + brand, data=oj)

## use the fitted model
summary(reg) ## coef, tests, fit
coef(reg) ## just coefficients

## create some data for prediction, using the data.frame function
## note the care in specifying brand factor (levels must match original data)
## we don't need all variables in oj; just those used as covariates in reg.
newdata=data.frame(price=rep(4,3), 
	brand=factor(c("tropicana","minute.maid","dominicks"),levels=levels(oj$brand)))
## predict
predict(reg, newdata=newdata)  ## predicted log units moved
exp(predict(reg, newdata=newdata)) ## predicted # of units moved

## under the hood: `design matrices' and model.matrix
x = model.matrix( ~ log(price) + brand, data=oj)
x[1,] ## first obsv of design matrix
oj[1,]  ## original data for first obsv.


## Interactions
## note that `*' also adds the main effects automatically
reg_interact = lm(logmove ~ log(price)*brand, data=oj)
summary(reg_interact)
## compare brand-specific log(price) slopes to our earlier elasticity (-3.1)

##### investigating advertisement
# class exercise: write an equation that represents this model
# in the form of an equation for f(x)
reg_ads <- lm(logmove ~ log(price)*brand + feat, data=oj)
summary(reg_ads)


## look at the advertisement effect on elasticity
reg_ads2 <- lm(logmove ~ log(price)*(brand+feat), data=oj)
summary(reg_ads2)

## and finally, consider 3-way interactions
reg_ads3 <- lm(logmove ~ log(price)*brand*feat, data=oj)
summary(reg_ads3)


## fit plots for the 3-way interaction

# Add predictions to the data frame
oj$reg_ads3_fitted = fitted(reg_ads3)

p_base = ggplot(data=oj) + 
  geom_point(aes(x=log(price), y = logmove, color=factor(feat)), alpha=0.025) + 
  facet_grid(~brand)
p_base

# shape = 21 gives you points with black circles around them
# the fill aesthetic maps to whether or not feat=1
p_base + geom_point(aes(x=log(price), y = reg_ads3_fitted, fill=factor(feat)),
                    shape=21)

# note that Minute Maid was more heavily promoted!
xtabs(~feat+brand, data=oj) %>%
  prop.table(margin=2) %>%
  round(3)