library(tidyverse)
library(lubridate)
library(randomForest)
library(gbm)
library(pdp)
library(modelr)
library(rsample)

# read in data and take a peak
capmetro = read.csv('../data/capmetro.csv')
summary(capmetro)

# weather data from Dark Sky API, https://darksky.net/dev

###
# Some data pre-processing
###

# Cast zone as a factor
# 361 and 362: UT area
# 454: part of downtown
# 1626 and 1713: outside of city center
capmetro$zone = factor(capmetro$zone)

# Re-order the day variable
capmetro$day = factor(capmetro$day, levels=c('Monday','Tuesday', "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))

# create a numerical hour and "minute of day" variables for plotting/inclusion in models
# the hour and minute functions are in lubridate, which expects timestamps in standard Y-M-D hour:min:sec format  
capmetro = mutate(capmetro, hour = hour(timestamp),
                            min_of_day = 60*hour(timestamp) + minute(timestamp))


# add dummy variables for precipitation and inSemester
capmetro = mutate(capmetro, precipYes = ifelse(precipIntensity>0, 1, 0),
                  inSemester = ifelse(date(timestamp) %within%
                                  interval(ymd("2018-08-29"), ymd("2018-12-07")), 1, 0))


####
# Exploratory plots
####

# long upper tails!
# but this is driven by large zone differences
ggplot(data=capmetro) +
  geom_boxplot(mapping=aes(x=factor(hour), y=boarding))

# split out by various factors and calculate summaries
hour_summ = capmetro %>%
  group_by(hour, zone, day, inSemester) %>%
  summarize(boarding_mean = mean(boarding))

ggplot(hour_summ) +
  geom_col(aes(x=hour, y=boarding_mean)) + 
  facet_grid(day~zone)


# focus on a UT-area zone
ggplot(filter(hour_summ, zone==362)) +
  geom_col(aes(x=hour, y=boarding_mean)) + 
  facet_grid(day~inSemester)


# temperature -- though confounded by time of day effects
ggplot(data=filter(capmetro, zone==362)) + 
  geom_point(mapping=aes(x=apparentTemperature, y=boarding)) + 
  geom_smooth(aes(x=apparentTemperature, y=boarding))

# try holding time constant by focusing on a few specific hours
ggplot(data=filter(capmetro, zone==362, hour==10)) + 
  geom_point(mapping=aes(x=apparentTemperature, y=boarding)) + 
  geom_smooth(aes(x=apparentTemperature, y=boarding))

ggplot(data=filter(capmetro, zone==362, hour==17)) + 
  geom_boxplot(mapping=aes(x=factor(precipYes), y=boarding))


###
# Model-building: focus here on zone=362
# Note: this implicitly assumes an interaction between zone and all other features
###

capmetro362 = filter(capmetro, zone==362)
capmetro362_split = initial_split(capmetro362)
# training and testing sets
n = nrow(capmetro362)

capmetro362_train = training(capmetro362_split)
capmetro362_test = testing(capmetro362_split)

forest1 = randomForest(boarding ~ day + temperature + min_of_day + precipYes + inSemester,
                       data=capmetro362_train)


yhat_test = predict(forest1, capmetro362_test)
plot(yhat_test, capmetro362_test$boarding)

# RMSE
rmse(forest1, capmetro362_test)

# performance as a function of iteration number
plot(forest1)

# a variable importance plot: how much SSE decreases from including each var
varImpPlot(forest1)


###
# compare with boosted regression trees
###

boost1 = gbm(boarding ~ day + temperature + min_of_day + precipYes + inSemester, 
               data = capmetro362_train,
               interaction.depth=4, n.trees=500, shrinkage=.05)

# Look at error curve -- stops decreasing much after ~300
gbm.perf(boost1)


yhat_test_gbm = predict(boost1, capmetro362_test, n.trees=350)

# RMSE
rmse(boost1, capmetro362_test)


# What if we assume a Poisson error model?
boost2 = gbm(boarding ~ day + temperature + min_of_day + precipYes + inSemester, 
             data = capmetro362_train, distribution='poisson',
             interaction.depth=4, n.trees=350, shrinkage=.05)

# Note: the predictions for a Poisson model are on the log scale by default
# use type='response' to get predictions on the original scale
# all this is in the documentation, ?gbm
yhat_test_gbm2 = predict(boost2, capmetro362_test, n.trees=350, type='response')

# but this subtly messes up the rmse function, which uses predict with default args
# so we need to roll our own calculate for RMSE
(yhat_test_gbm2 - capmetro362_test$boarding)^2 %>% mean %>% sqrt

# relative importance measures: how much each variable reduces the MSE
summary(boost1)

####
# Exploring the fit with partial dependence functions
####

plot(boost1, 'min_of_day')
plot(boost1, 'day')
plot(boost1, 'precipYes')
plot(boost1, 'inSemester')
plot(boost1, 'temperature')

# Note: can get these partial dependence functions directly from the pdp library
p1 = pdp::partial(boost1, pred.var = 'min_of_day', n.trees=350)
p1

p2 = pdp::partial(boost1, pred.var = 'day', n.trees=350)
p2


p3 = pdp::partial(boost1, pred.var = 'precipYes', n.trees=350)
p3

p4 = pdp::partial(boost1, pred.var = 'temperature', n.trees=350)
p4

p5 = pdp::partial(boost1, pred.var = c('min_of_day', 'day', 'inSemester'), n.trees=350)
p5

# This is nice when you want to look at interactions
ggplot(p5) + geom_point(mapping=aes(x=min_of_day, y=yhat)) + 
  facet_grid(inSemester~day)


# can plot the actual predictions, too
capmetro362_test$yhat_gbm = yhat_test_gbm

test_summ = capmetro362_test %>%
  group_by(hour, day, inSemester) %>%
  summarize(yhat_mean = mean(yhat_gbm))

ggplot(data=test_summ) + 
  geom_col(mapping=aes(x=hour, y=yhat_mean)) + 
  facet_grid(inSemester~day) + 
  xlim(c(8, 19))
