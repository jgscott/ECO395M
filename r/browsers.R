#### web-browsing data
library(tidyverse)
library(gamlr)

## Browsing History. 
## The table has three colums: [machine] id, site [id], [# of] visits
web = read.csv("../data/browser/browser-domains.csv")

## Read in the actual website names and relabel site factor
sitenames = scan("../data/browser/browser-sites.txt", what="character")
web$site = factor(web$site, levels=1:length(sitenames), labels=sitenames)
## also factor machine id
web$id = factor(web$id, levels=1:length(unique(web$id)))

# user 91
web %>%
  filter(id == 91) %>%
  head(50)

## get total visits per-machine and % of visits on each site
## tapply(a,b,c) does c(a) for every level of factor b.
machinetotals = as.vector(tapply(web$visits,web$id,sum)) 
visitpercent = 100*web$visits/machinetotals[web$id]

## use this info in a sparse matrix
## this is something you'll be doing a lot; familiarize yourself.
xweb = sparseMatrix(
	i=as.numeric(web$id), j=as.numeric(web$site), x=visitpercent,
	dims=c(nlevels(web$id),nlevels(web$site)),
	dimnames=list(id=levels(web$id), site=levels(web$site)))

# what sites did household 1 visit?
head(xweb[1, xweb[1,]!=0])

## now read in the spending data 
yspend = read.csv("../data/browser/browser-totalspend.csv", row.names=1)  # us 1st column as row names
yspend = as.matrix(yspend) ## good practice to move from dataframe to matrix for gamlr

n = length(yspend)

## run a lasso path plot
spender = gamlr(xweb, log(yspend), verb=TRUE)
plot(spender) ## path plot


B = coef(spender) ## the coefficients selected under AICc
## a few examples
B = B[-1,] # drop intercept and remove STM formatting

# sparsity?
plot(B)
sum(B == 0)
sum(B != 0)
sum(abs(B) > 0.05)

## low spenders spend a lot of time here
sort(B, decreasing=FALSE) %>% head(20)

## big spenders spend a lot of time here
sort(B, decreasing=TRUE) %>% head(20) ## big spenders hang out here

# compare with cross validation
cv.spender = cv.gamlr(xweb, log(yspend), verb=TRUE)
beta1se = coef(cv.spender) ## 1se rule; see ?cv.gamlr
betamin = coef(cv.spender, select="min") ## min cv selection
cbind(beta1se,betamin)[c("tvguide.com","americanexpress.com"),]

plot(B, betamin[-1])

## plot them together
par(mfrow=c(1,2))
plot(cv.spender)
plot(cv.spender$gamlr) ## cv.gamlr includes a gamlr object

## log lambdas selected under various criteria
log(spender$lambda[which.min(AICc(spender))])
log(cv.spender$lambda.min)
log(cv.spender$lambda.1se)
