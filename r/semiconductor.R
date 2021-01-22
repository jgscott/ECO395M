library(gamlr)

semiconductor = read.csv("../data/semiconductor.csv")
n = nrow(semiconductor)

## full model
full = glm(FAIL ~ ., data=semiconductor, family=binomial)

## A forward stepwise procedure
# null model
null = glm(FAIL~1, data=semiconductor, family=binomial)
# forward stepwise: it takes a long time!
system.time(fwd <- step(null, scope=formula(full), dir="forward"))
length(coef(fwd)) # chooses around 70 coef


#### lasso (glmnet does L1-L2, gamlr does L0-L1)

# for gamlr, and many other fitting functions,
# you need to create your own numeric feature matrix.
scx = model.matrix(FAIL ~ .-1, data=semiconductor) # do -1 to drop intercept!
scy = semiconductor$FAIL

# Note: there's also a "sparse.model.matrix"
# here our matrix isn't sparse.
# but sparse.model.matrix is a good way of doing things if you have factors.

# fit a single lasso
sclasso = gamlr(scx, scy, family="binomial")
plot(sclasso) # the path plot!

# AIC selected coef
# note: AICc = AIC with small-sample correction.  See ?AICc
AICc(sclasso)  # the AIC values for all values of lambda
plot(sclasso$lambda, AICc(sclasso))
plot(log(sclasso$lambda), AICc(sclasso))

# the coefficients at the AIC-optimizing value
# note the sparsity
scbeta = coef(sclasso) 

# optimal lambda
log(sclasso$lambda[which.min(AICc(sclasso))])
sum(scbeta!=0) # chooses 30 (+intercept) @ log(lambda) = -4.5

# Now without the AIC approximation:
# cross validated lasso (`verb` just prints progress)
# this takes a little longer, but still so fast compared to stepwise
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
plot(sccvl, bty="n", ylim=c(0, 1))
lines(log(sclasso$lambda),AICc(sclasso)/n, col="green", lwd=2)
legend("top", fill=c("blue","green"),
	legend=c("CV","AICc"), bty="n")

