library(tidyverse)
library(caret)
library(modelr)
library(rsample)


utilities = read.csv('../data/utilities.csv')
head(utilities)
utilities = utilities %>%
  mutate(gas_per_day = gasbill/billingDays)

model_knn = knnreg(gas_per_day ~ temp, data=utilities, k=20)

utilities = utilities %>%
  mutate(y_hat = predict(model_knn, utilities))

ggplot(utilities) + 
  geom_point(aes(x=temp, y=gas_per_day)) + 
  geom_line(aes(x=temp, y=y_hat))

# heteroskedasticity
ggplot(utilities) + 
  geom_point(aes(x=temp, y=gas_per_day-y_hat))


# KNN for variance estimation
utilities = utilities %>%
  mutate(log_err_sq = log((gas_per_day-y_hat)^2))

model_knn_var = knnreg(log_err_sq ~ temp, data=utilities, k=50)

utilities = utilities %>%
  mutate(gas_per_day_sd = sqrt(exp(predict(model_knn_var, utilities))))

ggplot(utilities) + 
  geom_point(aes(x=temp, y=gas_per_day)) + 
  geom_line(aes(x=temp, y=y_hat)) + 
  geom_ribbon(aes(x=temp,
                    ymin=y_hat - 2*gas_per_day_sd,
                    ymax = y_hat + 2*gas_per_day_sd), 
              alpha=0.2)
