library(MASS) 	## a library of example datasets
library(tidyverse)
library(nnet)  # for multinom
data(fgl) 

# split into training and testing set
n = nrow(fgl); n_train = 180
train_ind = sort(sample.int(214, n_train, replace=FALSE))
fgl_train = fgl[train_ind,]
fgl_test = fgl[-train_ind,]

# train three multinomial logit models
ml1 = multinom(type ~ RI + Mg, data=fgl_train)
ml2 = multinom(type ~ RI + Mg + Si + Al, data=fgl_train)
ml3 = multinom(type ~ (.)^2, data=fgl_train)

# notice we get the in-sample deviance at the bottom
summary(ml1)
summary(ml2)
summary(ml3)

# sanity check? can we reconstruct the in-sample deviance?
# let's try with model 2
probhat2_train = predict(ml2, newdata=fgl_train, type='probs')

# pick out the correct row-column pairs from the probhat matrix
rc_train = cbind(seq_along(fgl_train$type), fgl_train$type)
head(rc_train)
-2*sum(log(probhat2_train[rc_train]))
deviance(ml2)


# Let's use this to compare our three models on the testing set

# here's a generic function for calculating out-of-sample deviance
dev_out = function(y, probhat) {
  rc_pairs = cbind(seq_along(y), y)
  -2*sum(log(probhat[rc_pairs]))
}

# check
dev_out(fgl_train$type, probhat2_train)

# make predictions
probhat1_test = predict(ml1, newdata=fgl_test, type='probs')
probhat2_test = predict(ml2, newdata=fgl_test, type='probs')
probhat3_test = predict(ml3, newdata=fgl_test, type='probs')

# Calculate deviance
dev_out(fgl_test$type, probhat1_test)
dev_out(fgl_test$type, probhat2_test)
dev_out(fgl_test$type, probhat3_test)

# out-of-sample classification error rate
yhat2_test = predict(ml2, newdata=fgl_test, type='class')
conf2 = table(fgl_test$type, yhat2_test)
conf2
sum(diag(conf2))/n_test



# Let's try a model with all main effects (but no interactions)
ml4 = multinom(type ~ ., data=fgl_train)
deviance(ml4)
deviance(ml2)

probhat4_test = predict(ml4, newdata=fgl_test, type='probs')

# Yikes!
dev_out(fgl_test$type, probhat2_test)
dev_out(fgl_test$type, probhat4_test)

# yet classification error rate looks sensible
yhat4_test = predict(ml4, newdata=fgl_test, type='class')
conf4 = table(fgl_test$type, yhat4_test)
conf4
sum(diag(conf4))/n_test
sum(diag(conf2))/n_test

# what happened?  for a clue, see:
cbind(probhat4_test, fgl_test$type)

