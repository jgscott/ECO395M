library(gamlr)
library(tidyverse)

mushrooms = read.csv("../data/mushrooms.csv")

# set up x and y inputs
# remove veil type because every example is the same
x0 = mushrooms %>% select(-c(class, veil.type)) %>%
  as.data.frame()
x0 = model.matrix(~.-1, data=x0)
y0 = 0+(mushrooms$class == 'p')

# train/test split
n = nrow(x0)
n_train = floor(0.8*n)
train_ind = sample.int(n, size=n_train) %>% sort()

x_train = x0[train_ind,]
y_train = y0[train_ind]
x_test = x0[-train_ind,]
y_test = y0[-train_ind]

# choose small min lambda to make sure we explore more saturated fits
fit0 = cv.gamlr(x_train, y_train, nfold=10, verb=TRUE,
                  standardize=FALSE, family="binomial", lambda.min = 1e-9)

# the CV error plot vs lambda
plot(fit0)

yhat_test = predict(fit0, x_test, type='response')
table(y_test, yhat_test>0.5)


# the player effects
beta_hat = coef(fit)

# the game-configuration effects
beta_hat[1:8]

head(exp(beta_hat), 50)

# now the player-only effects
player_pm_logit = coef(fit, select='1se')[colnames(player),] %>%
  sort(., decreasing=TRUE)
head(player_pm_logit, 25) %>% exp()
sum(player_pm_logit != 0)  # a lot more are detectably non-zero (more goals!)
