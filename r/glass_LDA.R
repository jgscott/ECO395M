#### ******* Forensic Glass ****** ####
library(MASS) 	## a library of example datasets
library(tidyverse)
library(mvtnorm)
data(fgl) 		## loads the data into R; see help(fgl)

# Recall:
# the target variable is type:
# WinF: float glass window
# WinNF: non-float window
# Veh: vehicle window
# Con: container (bottles)
# Tabl: tableware
# Head: vehicle headlamp

# set up a plot
p0 = ggplot(data = fgl)

# Look at the (RI, Mg) joint distribution for each type
p0 + geom_point(aes(x=RI, y=Mg)) + facet_wrap(~type)

# let's look at (mu, Sigma) for two classes:
X_WinNF = fgl %>% filter(type=='WinNF') %>% select(RI, Mg)
mu_WinNF = colMeans(X_WinNF)
Sigma_WinNF = cov(X_WinNF)

X_veh = fgl %>% filter(type=='Veh') %>% select(RI, Mg)
mu_veh = colMeans(X_veh)
Sigma_veh = cov(X_veh)

# compare likelihoods of a sample point
X_all = fgl %>% select(RI, Mg)
y_all = fgl$type
X_all[147,]

dmvnorm(X_all[147,], mu_WinNF, Sigma_WinNF, log=TRUE)
dmvnorm(X_all[147,], mu_veh, Sigma_veh, log=TRUE)
y_all[147]


# using these two variables on a training set
train_set = sample.int(214, 180, replace=FALSE)

lda1 = lda(type ~ RI + Mg, data=fgl[train_set,])
summary(lda1)
lda1$means

predict(lda1, fgl[-train_set,])$posterior
predict(lda1, fgl[-train_set,])$class

confusion = table(y_all[-train_set], predict(lda1, fgl[-train_set,])$class)
sum(diag(confusion))/sum(confusion)

## all vars?
lda2 = lda(type ~ ., data=fgl[train_set,])
lda2$means

predict(lda2, fgl[-train_set,])$posterior
predict(lda2, fgl[-train_set,])$class

confusion2 = table(y_all[-train_set], predict(lda2, fgl[-train_set,])$class)
sum(diag(confusion2))/sum(confusion2)

