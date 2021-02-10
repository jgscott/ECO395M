library(tidyverse)
library(ggplot2)
library(lubridate)
library(modelr)
library(rsample)
library(mosaic)

# Power grid load every hour for 6 1/2 years
# throughout the 8 ERCOT regions of Texas
# units of grid load are megawatts.
# This represents peak instantaneous demand for power in that hour.
# source: scraped from the ERCOT website
load_ercot = read.csv("../data/load_ercot.csv")

# Now weather data at the KHOU weather station
# temps in F
load_temperature = read.csv("../data/load_temperature.csv")


# Feature engineering step 1:
# Merge the two data sets on their common field: Time
# Now we'll have access to the temperature data to predict power consumption
load_combined = merge(load_ercot, load_temperature, by = 'Time')


# Plot power consumption in the COAST region versus
# temperature at Houston Hobby Airport (weather station KHOU)
# We know this is going to be a useful feature, but it doesn't look linear!
# It looks more like a parabola
ggplot(load_combined) + 
  geom_point(aes(x=KHOU, y=COAST), alpha=0.1)

# Feature engineering step 2:
# Let's create a really useful feature: the square of temperature!
# This will help us estimate that quadratic-looking relationship
load_combined = mutate(load_combined,
                       KHOU_squared = KHOU^2)


# What about the Time variable?
head(load_combined$Time)

# first things first: let's get the Time variable into a format R understands.
# Right now R thinks it's just a string of characters.
# We need to tell R it's actually a time stamp in a specific format: Y-M-D H:M:S
# We'll do this with the ymd_hms function in the lubridate package
load_combined = mutate(load_combined,
                       Time = ymd_hms(Time))


# Now let's plot power consumption in the COAST region over time
ggplot(load_combined) + 
  geom_line(aes(x=ymd_hms(Time), y=COAST))

# We notice strong seasonal trends (winter vs. summer),
# as well as a general upward trend as time marches on (pop growth).  
# We also expect power consumption to vary on a finer time scale:
#   - across the day (wake vs. sleep)
#   - across the week (weekend vs. weekday)

# Let's use the functions in lubridate to engineer some relevant
# features from the Time variable.
# remember: factor tells R to treat a number as a category and make dummies.
# This is important: we don't wanth month/day as a number, but as a label
# the last line will get us a feature that models an overall upward trend
load_combined = mutate(load_combined, 
                       hour = hour(Time) %>% factor(),     # hour of day
                       wday = wday(Time) %>% factor(),     # day of week (1 = Monday)
                       month = month(Time) %>% factor(),   # month of year (1 = Jan)
                       weeks_elapsed = time_length(Time - ymd_hms('2010-01-01 01:00:00'), unit='weeks'))
                       
head(load_combined)


# let's create a train/test split and compare the performance of a few models
# that use our engineered features
load_split =  initial_split(load_combined, prop=0.8)
load_train = training(load_split)
load_test  = testing(load_split)

# just KHOU temperature and temp^2
lm1 = lm(COAST ~ KHOU + KHOU_squared, data=load_train)

# check performance on the testing set
rmse(lm1, load_test)

# a medium model that incorporates a time trend and monthly effects, via monthly dummy variables
lm2 = lm(COAST ~ KHOU + KHOU_squared + month + weeks_elapsed, data=load_train)

# noticeable improvement on testing set
rmse(lm2, load_train)
rmse(lm2, load_test)

# a bigger model that incorporates hourly and day-of-week effects,
# Note: it's really important that we had month/hour/day as factors.
# we want them to be dummy variables, not linear terms!
lm3 = lm(COAST ~ KHOU + KHOU_squared + month + weeks_elapsed + hour + wday,
            data=load_train)

# huge improvement on testing set
rmse(lm3, load_train)
rmse(lm3, load_test)


# what about a model with day of week and time-of-day interactions?
lm4 = lm(COAST ~ KHOU + KHOU_squared + month + weeks_elapsed +
           hour + wday + hour:wday, data=load_train)

# a bit of an improvement
rmse(lm4, load_train)
rmse(lm4, load_test)

# how big is our model?
# 182 parameters
length(coef(lm4))

# lets go bigger!
# how about a model where the temp effects depend upon the day and the month?
# Note: poly(KHOU,2) is shorthand for "include a quadratic term in KHOU"
# using poly(KHOU,2) just makes it easier to type out all the interactions.
lm5 = lm(COAST ~ poly(KHOU,2) + month + weeks_elapsed +
                 hour + wday + hour:wday + 
                 poly(KHOU,2):month + poly(KHOU,2):wday, data=load_train)

# now 216 parameters
length(coef(lm5))

# still doing better!
rmse(lm5, load_train)
rmse(lm5, load_test)

# so what about temp:hour interactions?
lm6 = lm(COAST ~ poly(KHOU,2) + month + weeks_elapsed +
           hour + wday + hour:wday + 
           poly(KHOU,2):month + poly(KHOU,2):wday + poly(KHOU,2):hour, data=load_train)

# now 262 parameters
length(coef(lm6))

# and better still!!
# in fact a really big improvement
rmse(lm6, load_train)
rmse(lm6, load_test)

# what about an interaction between time of day and month?
# this accounts for differeing patterns of darkness at, say, 6 PM from one month to the next
lm7 = lm(COAST ~ poly(KHOU,2) + month + weeks_elapsed +
           hour + wday + hour:wday + 
           poly(KHOU,2):month + poly(KHOU,2):wday + poly(KHOU,2):hour + 
           hour:month, data=load_train)

# now 515 parameters!
length(coef(lm7))

# But... it's not clear whether this is actually better than the previous model.
# huge growth in number of parms for unclear difference in performance
rmse(lm7, load_train)
rmse(lm7, load_test)


# Let's try averaging the performance of our three best models over 10 train/test splits
# this will help us know if the performance improvement of lm7 was a fluke.
# This will take a few minutes...
rmse_sim = do(10)*{
  # fresh train/test split
  load_split =  initial_split(load_combined, prop=0.8)
  load_train = training(load_split)
  load_test  = testing(load_split)
  
  # refit our models to this particular split
  # we're using "update" here to avoid having to type out the giant model formulas
  lm5 = update(lm5, data=load_train)
  lm6 = update(lm6, data=load_train)
  lm7 = update(lm7, data=load_train)
  
  # collect the model errors in a single vector
  model_errors = c(rmse(lm5, load_test), rmse(lm6, load_test), rmse(lm7, load_test))
  
  # return the model errors
  model_errors
}

# average performance across the splits:
# looks like the giant model is a little bit better...
colMeans(rmse_sim)

# but it took 253 additional parameters to gain about 3% in performance over lm6
# sometimes ML is like that: massively more complexity might gain you only a little bit
length(coef(lm6))
length(coef(lm7))

# And remember, this is ML, not stats!
# Don't bother trying to interpret the model:
summary(lm7)

# with all the different dummy variables, quadratic terms,
# and interactions, it's nearly impossible to interpret the individual coefficients.
# But it's a pretty good "black box" predictive model! features in, predictions out
