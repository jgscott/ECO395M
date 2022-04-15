###
# Bagging and random forests
###
library(tidyverse)
library(rpart)
library(rpart.plot)
library(rsample) 
library(randomForest)
library(lubridate)
library(modelr)

# Read in the data
load_tree = read.csv('../data/load_tree.csv')
load_tree = mutate(load_tree,
                   timestamp = ymd_hms(timestamp))

# Let's use the functions in lubridate to engineer some relevant
# features from the Time variable.
# remember: factor tells R to treat a number as a category and make dummies.
# This is important: we don't wanth month/day as a number, but as a label
# the last line will get us a feature that models an overall upward trend
load_tree = mutate(load_tree, 
                   hour = hour(timestamp),     # hour of day
                   wday = wday(timestamp),     # day of week (1 = Monday)
                   month = month(timestamp),   # month of year (1 = Jan)
                   weeks_elapsed = time_length(timestamp - ymd_hms('2010-01-01 01:00:00'), unit='weeks'))





head(load_tree)


# let's split our data into training and testing
load_split =  initial_split(load_tree, prop=0.8)
load_train = training(load_split)
load_test  = testing(load_split)

# let's fit a single tree
load.tree = rpart(COAST ~ temp + dewpoint + hour + wday + month + weeks_elapsed,
                  data=load_train, control = rpart.control(cp = 0.00001))

# now a random forest
# notice: no tuning parameters!  just using the default
# downside: takes longer because we're fitting hundreds of trees (500 by default)
# the importance=TRUE flag tells randomForest to calculate variable importance metrics
load.forest = randomForest(COAST ~ temp + dewpoint + hour + wday + month + weeks_elapsed,
                           data=load_train, importance = TRUE)

# shows out-of-bag MSE as a function of the number of trees used
plot(load.forest)


# let's compare RMSE on the test set
modelr::rmse(load.tree, load_test)
modelr::rmse(load.forest, load_test)  # a lot lower!

# variable importance measures
# how much does mean-squared error increase when we ignore a variable?
vi = varImpPlot(load.forest, type=1)


# partial dependence plots
# these are trying to isolate the partial effect of specific features
# on the outcome
partialPlot(load.forest, load_test, 'temp', las=1)
partialPlot(load.forest, load_test, 'hour', las=1)
partialPlot(load.forest, load_test, 'wday', las=1)
partialPlot(load.forest, load_test, 'month', las=1)
