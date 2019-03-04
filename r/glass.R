#### ******* Forensic Glass ****** ####
library(MASS) 	## a library of example datasets
library(tidyverse)
library(class)
data(fgl) 		## loads the data into R; see help(fgl)

# goal: automatic classification of glass shards into 6 types
# features: refactive index, plus concentrations of 8 elements
summary(fgl)

# the target variable is type:
# WinF: float glass window
# WinNF: non-float window
# Veh: vehicle window
# Con: container (bottles)
# Tabl: tableware
# Head: vehicle headlamp

# set up a plot
p0 = ggplot(data = fgl)

# some variables are clear discriminators of at least 1 class
p0 + geom_boxplot(aes(x=type, y=Ba))
p0 + geom_boxplot(aes(x=type, y=Mg))
p0 + geom_boxplot(aes(x=type, y=Na))

# some a decent for partially separating some of the class
p0 + geom_boxplot(aes(x=type, y=Al))

# some are more subtle
p0 + geom_boxplot(aes(x=type, y=RI))
p0 + geom_boxplot(aes(x=type, y=Si))



## for illustration, consider the RIxMg plane (i.e., just 2D)
X = dplyr::select(fgl, RI, Mg) 
y = fgl$type
n = length(y)

# select a training set
n_train = round(0.8*n)
n_test = n - n_train
train_ind = sample.int(n, n_train)
X_train = X[train_ind,]
X_test = X[-train_ind,]
y_train = y[train_ind]
y_test = y[-train_ind]

# scale the training set features
scale_factors = apply(X_train, 2, sd)
X_train_sc = scale(X_train, scale=scale_factors)

# scale the test set features using the same scale factors
X_test_sc = scale(X_test, scale=scale_factors)

# Fit two KNN models (notice the odd values of K)
knn3 = class::knn(train=X_train_sc, test= X_test_sc, cl=y_train, k=3)
knn25 = class::knn(train=X_train_sc, test= X_test_sc, cl=y_train, k=25)


## plot them to see how it worked

# put the data and predictions in a single data frame
knn_trainset = data.frame(X_train_sc, type = y_train)
knn3_testset = data.frame(X_test_sc, type = y_test, type_pred = knn3)
knn25_testset = data.frame(X_test_sc, type = y_test, type_pred = knn25)


p1 = ggplot(data=knn_trainset) +
	geom_point(aes(x=RI, y=Mg, shape=type), size=2)
p1
p1 + geom_point(data=knn3_testset, mapping=aes(x=RI, y=Mg, shape=type_pred), color='red')
p1 + geom_point(data=knn25_testset, mapping=aes(x=RI, y=Mg, shape=type_pred), color='red')

# test set errors?
knn3_testset
knn25_testset

# Make a table of classification errors
table(knn3, y_test)
sum(knn3 != y_test)/n_test
table(knn25, y_test)
sum(knn25 != y_test)/n_test


# In-class goals for today:
# Build a KNN classifier using all the available features (not just Mg and RI)
# Notes:
# 1) Remember to scale your X's!
# 	1b) remember to scale the test-set X's by the same factor as the training set!
# 2) choose K to optimize out-of-sample error rate
# 3) average over multiple train/test splits to minimize the effect of Monte Carlo variability



## for illustration, consider the RIxMg plane (i.e., just 2D)
X = dplyr::select(fgl, -type) 
#X = select(fgl, RI, Mg)
y = fgl$type
n = length(y)

# select a training set
n_train = round(0.8*n)
n_test = n - n_train


library(foreach)
library(mosaic)
k_grid = seq(1, 25, by=2)
err_grid = foreach(k = k_grid,  .combine='c') %do% {
  out = do(100)*{
    train_ind = sample.int(n, n_train)
    X_train = X[train_ind,]
    X_test = X[-train_ind,]
    y_train = y[train_ind]
    y_test = y[-train_ind]
    
    # scale the training set features
    scale_factors = apply(X_train, 2, sd)
    X_train_sc = scale(X_train, scale=scale_factors)
    
    # scale the test set features using the same scale factors
    X_test_sc = scale(X_test, scale=scale_factors)
    
    # Fit two KNN models (notice the odd values of K)
    knn_try = class::knn(train=X_train_sc, test= X_test_sc, cl=y_train, k=k)
    
    # Calculating classification errors
    sum(knn_try != y_test)/n_test
  } 
  mean(out$result)
}


plot(k_grid, err_grid)
