library(tidyverse)

## read in the data
spamfit = read.csv('../data/spamfit.csv')


# a simple linear probability model
lm1 = lm(y ~ log(capital.run.length.average), data=spamfit)
spamfit$lm1_pred = predict(lm1)
ggplot(data = spamfit) + 
  theme_bw(base_size=18) + 
  geom_point(aes(x=log(capital.run.length.average), y = jitter(y, 0.25)), color='grey', alpha=0.2) + 
  labs(y="Spam?", x="Log(capital run length)") + 
  geom_point(aes(x=log(capital.run.length.average), y = lm1_pred), color='blue', alpha=0.2)

# in-sample accuracy?
yhat_train = ifelse(predict(lm1) >= 0.5, 1, 0)
table(y=spamfit$y, yhat=yhat_train)

# exercise: how well does the model predict on the data in spamtest.csv?  

# this is wrong!!!!!!!!!!!!!
# lm1 = lm(y ~ log(capital.run.length.average), data=spamtest)

probhat_test = predict(lm1, newdata=spamtest)
yhat_test = ifelse(probhat_test >= 0.5, 1, 0)
table(y=spamtest$y, yhat=yhat_test)
