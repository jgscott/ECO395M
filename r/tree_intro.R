library(mosaic)
library(tidyverse)

# two motivating data sets
CAhousing = read.csv('../data/CAhousing.csv')
qplot(longitude, latitude, color=medianHouseValue, data=CAhousing)

# data on penalty calls in hockey
# oppcall indicates whether a penalty call is against your opponent (oppcall = 1)
# or your team (oppcall=0)
pen2ref = read.table('../data/pen2ref.txt', header=TRUE)
head(pen2ref)

# calls against you tend to be when you're ahead
# calls for you tend to be when you're behind
mean(goaldiff~oppcall, data=pen2ref)

# if the last two calls were against you (inrow2=1), there's a higher chance
# that the next call will be against your opponent
xtabs(~oppcall+inrow2, data=pen2ref) %>% prop.table(margin=2)


boxplot(timespan ~ oppcall, data=pen2ref)

