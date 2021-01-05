library(tidyverse)
library(rsample)  # for creating train/test splits
library(FNN)

# read in the data: make sure to use the path name to
# wherever you'd stored the file
loadhou = read.csv('../data/loadhou.csv')
summary(loadhou)

# plot the data
ggplot(data = loadhou) + 
  geom_point(mapping = aes(x = KHOU, y = COAST), color='darkgrey') + 
  ylim(7000, 20000)

# Make a train-test split
loadhou_split =  initial_split(loadhou, prop=0.8)
loadhou_train = training(loadhou_split)
loadhou_test  = testing(loadhou_split)


# optional book-keeping step:
# reorder the rows of the testing set by the KHOU (temperature) variable
# this isn't necessary, but it will allow us to make a pretty plot later
loadhou_test = arrange(loadhou_test, KHOU)
head(loadhou_test)


#####
# Fit a few models
#####

# linear and quadratic models
lm1 = lm(COAST ~ KHOU, data=loadhou_train)
lm2 = lm(COAST ~ poly(KHOU, 2), data=loadhou_train)

# KNN with K = 250 using knn.reg
# this function expects X and Y to be separated out
X_train = select(loadhou_train, KHOU)
y_train = select(loadhou_train, COAST)
X_test = select(loadhou_test, KHOU)
y_test = select(loadhou_test, COAST)

knn250 = knn.reg(train = X_train, test = X_test, y = y_train, k=250)
names(knn250)

#####
# Compare the models by RMSE_out
#####

# define a helper function for calculating RMSE
rmse = function(y, ypred) {
  sqrt(mean(data.matrix((y-ypred)^2)))
}

ypred_lm1 = predict(lm1, X_test)
ypred_lm2 = predict(lm2, X_test)
ypred_knn250 = knn250$pred

rmse(y_test, ypred_lm1)
rmse(y_test, ypred_lm2)
rmse(y_test, ypred_knn250)


####
# plot the fit
####

# attach the predictions to the test data frame
loadhou_test$ypred_lm2 = ypred_lm2
loadhou_test$ypred_knn250 = ypred_knn250

p_test = ggplot(data = loadhou_test) + 
  geom_point(mapping = aes(x = KHOU, y = COAST), color='lightgrey') + 
  theme_bw(base_size=18) + 
  ylim(7000, 20000)
p_test

p_test + geom_point(aes(x = KHOU, y = ypred_knn250), color='red')
p_test + geom_path(aes(x = KHOU, y = ypred_knn250), color='red')
p_test + geom_path(aes(x = KHOU, y = ypred_knn250), color='red') + 
  geom_path(aes(x = KHOU, y = ypred_lm2), color='blue')

