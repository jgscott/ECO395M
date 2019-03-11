library(mosaic)
data(Galton)
lm1 = lm(height~mother, data=Galton)

# Use the do() command to do the bootstrap
# This is from the mosaic package
boot1 = do(1000)*lm(height~mother, data=resample(Galton))


# Now do the same thing without mosaic's syntactic sugar

# First create a placeholder matrix
# Like an empty closet which will subsequently be filled
boot2 = matrix(0, ncol=2, nrow=1000)

# Go sample by sample in an explicit loop
# Save each set of coefficients (intercept, slope) in a single row of boot2
for(i in 1:1000) {
	myindices = sample(1:nrow(Galton), nrow(Galton), replace=TRUE)
	lmtemp = lm(height~mother, data=Galton, subset=myindices)
	boot2[i,] = coef(lmtemp)
}

# Compare -- there will be differences due to Monte Carlo variability
hist(boot1[,1])
hist(boot2[,1])

hist(boot1[,2])
hist(boot2[,2])

apply(boot1,2,sd)
apply(boot2,2,sd)