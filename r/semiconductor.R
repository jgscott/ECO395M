semiconductor = read.csv("semiconductor.csv")
n = nrow(semiconductor)

## full model
full = glm(FAIL ~ ., data=semiconductor, family=binomial)

## A forward stepwise procedure
# null model
null = glm(FAIL~1, data=semiconductor)
# forward stepwise: it takes a long time!
system.time(fwd <- step(null, scope=formula(full), dir="forward"))
length(coef(fwd)) # chooses around 70 coef


#### lasso (glmnet does L1-L2, gamlr does L0-L1)
library(gamlr) 

# for gamlr, and most other functions, you need to create your own numeric
# design matrix.  We'll do this as a sparse `simple triplet matrix' using 
# the sparse.model.matrix function.
scx = sparse.model.matrix(FAIL ~ ., data=semiconductor)[,-1] # do -1 to drop intercept!
# here, we could have also just done x = as.matrix(semiconductor[,-1]).
# but sparse.model.matrix is a good way of doing things if you have factors.

scy = semiconductor$FAIL # pull out `y' too just for convenience

# fit a single lasso
sclasso = gamlr(scx, scy, family="binomial")
plot(sclasso) # the path plot!

# AIC selected coef
# note: AICc = AIC with small-sample correction.  See ?AICc
AICc(sclasso)
plot(sclasso$lambda, AICc(sclasso))
plot(log(sclasso$lambda), AICc(sclasso))

# the coefficients at the AIC-optimizing value
# note the sparsity
scbeta = coef(sclasso) 

# optimal lambda
log(sclasso$lambda[which.min(AICc(sclasso))])
sum(scbeta!=0) # chooses 30 (+intercept) @ log(lambda) = -4.5

# Now without the AIC approximation:
# cross validated lasso (verb just prints progress)
sccvl = cv.gamlr(scx, scy, nfold=10, family="binomial", verb=TRUE)

# plot the out-of-sample deviance as a function of log lambda
# Q: what are the bars associated with each dot? 
plot(sccvl, bty="n")

## CV min deviance selection
scb.min = coef(sccvl, select="min")
log(sccvl$lambda.min)
sum(scb.min!=0) # note: this is random!  because of the CV randomness

## CV 1se selection (the default)
scb.1se = coef(sccvl)
log(sccvl$lambda.1se)
sum(scb.1se!=0) ## usually selects all zeros (just the intercept)

## comparing AICc and the CV error
# note that AIC is a pretty good estimate of out-of-sample deviance
# for values of lambda near the optimum
# outside that range: much worse  
plot(sccvl, bty="n")
lines(log(sclasso$lambda),AICc(sclasso)/n, col="green", lwd=2)
legend("top", fill=c("blue","green"),
	legend=c("CV","AICc"), bty="n")

