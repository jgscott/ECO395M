library(mosaic)
library(tidyverse)
library(FNN)
library(foreach)

sclass = read.csv('../data/sclass.csv')

# The variables involved
summary(sclass)

# Focus on first trim level: 350
sclass350 = subset(sclass, trim == '350')
dim(sclass350)

# create a train/test split
N = nrow(sclass350)
N_train = floor(0.8*N)
train_ind = sample.int(N, N_train, replace=FALSE)

sclass350_train = sclass350[train_ind,]
sclass350_test = sclass350[-train_ind,]

y_train_350 = sclass350_train$price
X_train_350 = data.frame(mileage = sclass350_train$mileage)
y_test_350 = sclass350_test$price
X_test_350 = data.frame(mileage = sclass350_test$mileage)


rmse = function(y, ypred) {
  sqrt(mean((y-ypred)^2))
}

k_grid = unique(round(exp(seq(log(N_train), log(2), length=100))))
rmse_grid_out = foreach(k = k_grid, .combine='c') %do% {
  knn_model = knn.reg(X_train_350, X_test_350, y_train_350, k = k)
  rmse(y_test_350, knn_model$pred)
}

rmse_grid_out = data.frame(K = k_grid, RMSE = rmse_grid_out)


revlog_trans <- function(base = exp(1)) {
  require(scales)
    ## Define the desired transformation.
    trans <- function(x){
                 -log(x, base)
                }
    ## Define the reverse of the desired transformation
    inv <- function(x){
                 base^(-x)
                }
    ## Creates the transformation
    scales::trans_new(paste("revlog-", base, sep = ""),
              trans,
              inv,  ## The reverse of the transformation
              log_breaks(base = base), ## default way to define the scale breaks
              domain = c(1e-100, Inf) 
             )
    }

p_out = ggplot(data=rmse_grid_out) + 
  geom_path(aes(x=K, y=RMSE, color='testset'), size=1.5) + 
  scale_x_continuous(trans=log)
ind_best = which.min(rmse_grid_out$RMSE)
k_best = k_grid[ind_best]

p_out + geom_vline(xintercept=k_best, color='darkgreen', size=1.5)

# fit the model at the optimal k
knn_model = knn.reg(X_train, X_test, y_train, k = k_best)
rmse_best = rmse(y_test, knn_model$pred)

D_test$ypred = knn_model$pred
p_test + geom_path(data=D_test, mapping = aes(x=KHOU, y=ypred), color='red', size=1.5)



sclass65AMG = subset(sclass, trim == '65 AMG')
summary(sclass65AMG)

# Look at price vs mileage for each trim level
plot(price ~ mileage, data = sclass350)
plot(price ~ mileage, data = sclass65AMG)

