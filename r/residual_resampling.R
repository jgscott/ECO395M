library(mosaic)

########
# Residual-resampling bootstrap
########

chym = read.csv("../data/chymotrypsin.csv")
plot(Rate ~ jitter(Conc), data=chym)

# Michaelis-Menten kinetics
# see https://en.wikipedia.org/wiki/Michaelis–Menten_kinetics

# This function predictions the reaction rate as a function of:
# @x: concentration
# @vmax, km: M-M kinetic parameters
mmpredict = function(x, vmax, km) {
	vmax*x/{km+x}
}

# This defines a target function to be optimized
# to fit a Michaelis-Menten equation to data.
# @theta = (log vmax, log km), the system parameters to be optimized over
# @x: observed vector of concentrations
# @y: observed vector of reaction rates
target = function(theta, x, y) {
	vmax = exp(theta[1])
	km = exp(theta[2])
	ypred = mmpredict(x, vmax, km)
	sum({y-ypred}^2)
}

# Optimize the function
mymax = optim(c(0,0), target, x = chym$Conc, y = chym$Rate, method='Nelder-Mead')
mymax  # see ?optim
thetahat = mymax$par

# Data and fitted curve
plot(Rate ~ jitter(Conc), data=chym)
curve(mmpredict(x, exp(thetahat[1]), exp(thetahat[2])), add=TRUE)


# How can we quantify uncertainty about the fitted curve?


## Key points
# 1) The experiment was designed -- don't want to resample design points randomly!
# 2) May not want to assume a parametric model


### One solution: residual resampling bootstap

# first define the fitted values and residuals from the fitted model
yhat = mmpredict(chym$Conc, exp(thetahat[1]), exp(thetahat[2]))
eps = chym$Rate - yhat
N = nrow(chym)

# Now repeatedly create synthetic data sets by resampling the residuals with replacement
NMC = 1000
thetasave = matrix(NA, nrow=NMC, ncol=2)
for(i in 1:NMC) {
	
	# resample residuals -- this is sampling from the empirical CDF of e
	estar = sample(eps, N, replace=TRUE)
	
	# add to the fitted values to create a new "random sample" of data
	ystar = yhat + estar
	
	# refit the model using the synthetic y observations and real x values
	mymax = optim(c(0,0), target, x = chym$Conc, y = ystar)
	thetastar = mymax$par

	# save the fitted parameter
	thetasave[i,] = thetastar
}



# Inspect the sampling distributions
hist(exp(thetasave[,1]))  # vmax
hist(exp(thetasave[,2]))  # km


# Show the distribution of fitted curves
plot(Rate ~ Conc, data=chym)
curve(mmpredict(x, exp(thetahat[1]), exp(thetahat[2])), add=TRUE)

for(i in 1:NMC) {
	curve(mmpredict(x, exp(thetasave[i,1]), exp(thetasave[i,2])), add=TRUE, col=rgb(0,0,0,0.01))
}
curve(mmpredict(x, exp(theta[1]), exp(theta[2])), add=TRUE, col='red', lwd=3)

# standard errors from the sampling distribution
thetahat_se = apply(thetasave,2,sd)
thetahat_se

# asymptotic Gaussian confidence intervals:
thetahat - 1.96*thetahat_se
thetahat + 1.96*thetahat_se

# What is a key assumption of this method?  hint:
plot(eps ~ jitter(Conc), data=chym)
