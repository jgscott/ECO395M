library(mosaic)
brca = read.csv('../data/brca.csv')

# fit a model
model1 = glm(cancer ~ . - recall, data=brca, family=binomial)
coef(model1)

# histogram of fitted probabilities
hist(fitted(model1))

# simulate synthetic data?
N = nrow(brca)
y_sim = rbinom(N, 1, fitted(model1)) # using fitted model probs

# spot check: look at actual vs simulated outcomes
# not the same, but similar patterns vs covariates
xtabs(~cancer + y_sim, data=brca)

xtabs(~history + cancer, data=brca)
xtabs(~history + y_sim, data=brca)

xtabs(~age + cancer, data=brca)
xtabs(~age + y_sim, data=brca)

# parametric bootstrap for in-class exercise
paraboot1 = do(1000)*{
  y_sim = rbinom(N, 1, fitted(model1))
  brca_boot = brca
  brca_boot$cancer = y_sim # replace real outcomes with synthetic ones
  model_boot =  glm(cancer ~ . - recall, data=brca_boot, family=binomial)
  yhat_boot = fitted(model_boot)
  yhat_boot  # return the predicted model probabilities
}

# standard errors
yhat = fitted(model1)
yhat_se = apply(paraboot1, 2, sd)

plot(yhat, yhat_se)

# can examine individual bootstrapped sampling distributions
hist(paraboot1[,1])
hist(paraboot1[,960])

# prediction intervals  (use t to transpose matrix)
yhat_interval = t(apply(paraboot1, 2, quantile, probs=c(0.025, 0.975)))

tail(yhat_interval)

# look at uncertainty versus a few features
boxplot(yhat_se ~ history, data=brca)
boxplot(yhat_se ~ symptoms, data=brca)
boxplot(yhat_se ~ age, data=brca)  


## Now address part 2 on the homework

# Q1) are some radiologists more clinically conservative than others in recalling patients, holding patient risk factors equal?

# let's model recall versus risk factors + radiologist
model_recall = glm(recall ~ . - cancer, data=brca, family=binomial)
coef(model_recall)

# compared to the baseline radiologist:
# - radiologist34 has about exp(-0.52) ≈ 0.6 times the odds of recalling a patient,
# holding other risk factors constant.
# - radiologist89 has about exp(0.46) ≈ 1.58 times the odds of recalling a patient, # holding other risk factors constant.
# these two seem to be the least and most conservative, respectively

# can we get a confidence interval for these differences?
# let's use the parametric bootstrap
paraboot2 = do(1000)*{
  y_sim = rbinom(N, 1, fitted(model_recall))  # simulate recall outomes
  brca_boot = brca
  brca_boot$recall = y_sim # replace real recall outcomes with synthetic ones
  model_boot = glm(recall ~ . - cancer, data=brca_boot, family=binomial)
  coef(model_boot) # return the coefficients from the bootstrapped model
}


head(paraboot2)
# our interest is in the difference between radiologists 34 and 89

hist(paraboot2[,4] - paraboot2[,2])
mean(paraboot2[,4] - paraboot2[,2])
quantile(paraboot2[,4] - paraboot2[,2], probs = c(0.025, 0.975))

# conclusion:
# radiologistist 89 has exp(1.02) ≈ 2.77 the odds of recalling a patient 
# as radiologist 34, holding risk factors equal
# the confidence interval for the odds ratio is
# (e^0.44, e^1.73) = (1.55, 5.87)
# we should probability get these radiologists to compare notes
# about what they're seeing, in an effort to bring greater consistency to the screening process

# out of interest: who is more accurate, radiologist 34 or 89?
xtabs(~cancer + recall, data=subset(brca, radiologist == 'radiologist34'))
xtabs(~cancer + recall, data=subset(brca, radiologist == 'radiologist89'))

# hard to say from the confusion matrices!
# FDR is higher for 89 (33/38 versus 13/17)
# but FNR is lower for 89 (2/7 versus 3/7)
# bottom line: radiologist 89 had 20 more false positives (so 20 more "unnecessary" biopsies) and 1 fewer missed case of cancer


# Q2) when the radiologists at this hospital interpret a mammogram to make a decision on whether to recall the patient, does the data suggest that they should be weighing some clinical risk factors more heavily than they currently are?

# let's model cancer versus recall and risk factors
model_cancer = glm(cancer ~ ., data=brca, family=binomial)
coef(model_cancer)

# so, e.g., patients 70 or older have exp(1.44) ≈ 4.2 times the odds of having cancer as recalled patients younger than 50, even holding recall status constant.
# what should we tell the doctors?
xtabs(~recall + age, data=brca)

# Similarly, patients with tissue density classification 4 have exp(2) ≈ 7.4 times the odds of having cancer as patients with density 1, even holding recall status constant.
# what should we tell the doctors?
xtabs(~recall + density, data=brca)

# key insight: if the doctors are optimally making use of information
# about all risk factors in their recall decision, then we should see
# coefficients of zero on all risk factors in the "cancer vs recall + risk
# factors" model.  Here we don't!  Thus there's extra information in the risk
# factors that the doctors _should_ be using to recall patients.

# this also shows up in the raw error rates
xtabs(~cancer + recall + age, brca) %>% prop.table(margin=c(2, 3))
xtabs(~cancer + recall + density, brca) %>% prop.table(margin=c(2, 3))
