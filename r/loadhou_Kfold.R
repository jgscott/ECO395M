library(FNN)
library(tidyverse)

loadhou = read.csv('../data/loadhou.csv')

# allocate to folds
N = nrow(loadhou)
K = 10
fold_id = rep_len(1:K, N)  # repeats 1:K over and over again
fold_id = sample(fold_id, replace=FALSE) # permute the order randomly

maxM = 10
err_save = matrix(0, nrow=K, ncol=maxM)

for(i in 1:K) {
  train_set = which(fold_id != i)
  y_test = loadhou$COAST[-train_set]
  for(m in 1:maxM) {
    this_model = lm(COAST ~ poly(KHOU, m), data=loadhou[train_set,])
    yhat_test = predict(this_model, newdata=loadhou[-train_set,])
    err_save[i, m] = mean((y_test - yhat_test)^2)
  }
}

err_save


plot(1:maxM, sqrt(colMeans(err_save)))
