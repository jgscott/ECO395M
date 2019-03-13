library(mosaic)

predimed = read.csv('../data/predimed.csv')

# Cross tabulate participants by group and event status
# "Event = Yes" means some cardiac event 
xtabs(~group + event, data=predimed)

# A normal-based confidence interval for
# P(event) in the MedDiet + VOO group
n = 2097+85
x = 85
p_hat = x/n
se_hat = sqrt(p_hat*(1-p_hat)/n)

p_hat + c(-1.96, 1.96)*se_hat

# Parametric bootstrap:
# 1) Repeatedly simulate data under the assumed
#	 parametric model, using fitted parameter.
# 2) For each simulated data set, refit the model.
# 3) Approximate the sampling distribution using the
#	histogram of fitted parameters.

boot1 = do(1000)*{
	
	# 1) simulate data under the fitted parameter
	# (versus ordinary bootstrap:
	#	resample data with replacement)
	x_sim = rbinom(1, n, p_hat)
	
	# 2) Re-estimate the parameter using the simulated data
	p_hat_sim = x_sim/n
	
	# Return p_hat_sim
	p_hat_sim
}

# 3) Inspect the sampling distribution
hist(boot1$result)

# Bootstrapped estimate of standard error
sd(boot1$result)

# Compare with plug-in estimate
se_hat

# Compare bootstrap and normal-based confidence intervals
confint(boot1)
p_hat + c(-1.96, 1.96)*se_hat
