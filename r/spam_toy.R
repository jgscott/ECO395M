library(tidyverse)

## read in the data
spamfit = read.csv('../data/spamfit.csv')
spamtest = read.csv('../data/spamtest.csv')

# a simple linear probability model
lm1 = lm(y ~ log(capital.run.length.average), data=spamfit)
spamfit$lm1_pred = predict(lm1)
ggplot(data = spamfit) + 
  geom_jitter(aes(x=log(capital.run.length.average), y = y), 
              height=0.1, color='grey', alpha=0.3)
              
# in-sample accuracy?
yhat_train = ifelse(predict(lm1) >= 0.5, 1, 0)
table(y=spamfit$y, yhat=yhat_train)

# how well does the model predict on the data in spamtest.csv?  
probhat_test = predict(lm1, newdata=spamtest)
yhat_test = ifelse(probhat_test >= 0.5, 1, 0)
table(y=spamtest$y, yhat=yhat_test)


logit_spam = glm(y ~ ., data=spamfit, family='binomial')
