library(tidyverse)
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
N = nrow(loadhou)
N_train = floor(0.8*N)
N_test = N - N_train




#####
# Train/test split
#####

# randomly sample a set of data points to include in the training set
train_ind = sample.int(N, N_train, replace=FALSE)

# Define the training and testing set
D_train = loadhou[train_ind,]
D_test = loadhou[-train_ind,]

# optional book-keeping step:
# reorder the rows of the testing set by the KHOU (temperature) variable
# this isn't necessary, but it will allow us to make a pretty plot later
D_test = arrange(D_test, KHOU)
head(D_test)

# Now separate the training and testing sets into features (X) and outcome (y)
X_train = select(D_train, KHOU)
y_train = select(D_train, COAST)
X_test = select(D_test, KHOU)
y_test = select(D_test, COAST)


#####
# Fit a few models
#####

# linear and quadratic models
lm1 = lm(COAST ~ KHOU, data=D_train)
lm2 = lm(COAST ~ poly(KHOU, 2), data=D_train)

# KNN 250
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
D_test$ypred_lm2 = ypred_lm2
D_test$ypred_knn250 = ypred_knn250

p_test = ggplot(data = D_test) + 
  geom_point(mapping = aes(x = KHOU, y = COAST), color='lightgrey') + 
  theme_bw(base_size=18) + 
  ylim(7000, 20000)
p_test

p_test + geom_point(aes(x = KHOU, y = ypred_knn250), color='red')
p_test + geom_path(aes(x = KHOU, y = ypred_knn250), color='red')
p_test + geom_path(aes(x = KHOU, y = ypred_knn250), color='red') + 
  geom_path(aes(x = KHOU, y = ypred_lm2), color='blue')




#### exercise


N_train = 150
train_ind = sort(sample.int(N, N_train, replace=FALSE))
D_train = loadhou[train_ind,]
D_train = arrange(D_train, KHOU)
y_train = D_train$COAST
X_train = data.frame(KHOU=jitter(D_train$KHOU))

knn_model = knn.reg(X_train, X_train, y_train, k = 3)

D_train$ypred = knn_model$pred
p_train = ggplot(data = D_train) + 
  geom_point(mapping = aes(x = KHOU, y = COAST), color='lightgrey') + 
  theme_bw(base_size=18) + 
  ylim(7000, 20000) + xlim(0,36)
p_train + geom_path(mapping = aes(x=KHOU, y=ypred), color='red', size=1.5)

