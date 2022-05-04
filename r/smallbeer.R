library(tidyverse)
library(gamlr)

## small beer dataset
beer = read.csv("../data/smallbeer.csv", 
	colClasses=c(rep("factor",3),rep("numeric",2)))

nrow(beer)	
view(beer)

# very little variation to estimate an elasticity!
beer %>% filter(description == '10 BARREL APOCALYPSE IPA 6PK        ')

# more variation = more hope
beer %>% filter(description == 'STELLA ARTOIS 6PK BTL               ')

# complete pooling: one elasticity for all beers
allforone = lm(log(units) ~ log(price), data=beer)
coef(allforone)

# no pooling: independent elasticities for each beer
oneforall = lm(log(units) ~ log(price)*item, data=beer)

# tons of NAs, lots of noisy coefficients
coef(oneforall)
hist(coef(oneforall)) ## super noisy zeros

# getting the elasticities? a bit annoying but this code does it
price_main = coef(oneforall)[2]
which_int = grep("log(price):item", names(coef(oneforall)), fixed=TRUE)
price_int = coef(oneforall)[which_int]

# add the main effect to all the relevant interactions
# to get each beer's elasticity
hist(price_main + price_int)

## Clear this won't work

# build some regression designs

x1 = sparse.model.matrix(~log(price)*item + factor(week)-1, data=beer)
head(x1)

# don't penalize the log price coefficient
ml1 = cv.gamlr(x=x1, y=log(beer$units), free = 1, standardize=FALSE, verb=TRUE)
coef(ml1)

# how can I get the elasticities?
price_main = coef(ml1)[2]
which_int = grep("log(price):item", rownames(coef(ml1)), fixed=TRUE)
price_int = coef(ml1)[which_int]

# these look much more reasonable, though not all negative
# and the elephant in the room: of course price is not exogenous here!
# price is changing over time and in response to features that also predict demand
hist(price_main + price_int)

####
# Orthogonal ML instead
# strategy: isolate "idiosyncratic" variation price and quantity sold
# by first explicitly adjusting for item and week
####

# OML steps 1-2
xitem = sparse.model.matrix(~item-1, lmr=1e-5, data=beer)
xweek = sparse.model.matrix(~week-1, lmr=1e-5, data=beer)
xx = cbind(xweek, xitem)

# isolate/partial out variation in log(price) predicted by item and week
pfit = gamlr(x=xx, y=log(beer$price), lmr=1e-5, standardize=FALSE)

# isolate/partial out variation in quantity sold predicted by item and week
qfit = gamlr(x=xx, y=log(beer$units), lmr=1e-5, standardize=FALSE)

# Calculate residuals: variation in price and units sold that
# cannot be predicted by item and week
lpr = drop(log(beer$price) - predict(pfit, xx))
lqr = drop(log(beer$units) - predict(qfit, xx))


# Run 3rd ML step to get elasticities

# parse the item description text 
# each individual word in the title becomes a predictor
# why is this helping here?
library(tm)
descr = Corpus(VectorSource(as.character(beer$description)))
xtext = DocumentTermMatrix(descr)

# convert to Matrix format
xtext = sparseMatrix(i=xtext$i,j=xtext$j, x=as.numeric(xtext$v>0),
	dims=dim(xtext), dimnames=dimnames(xtext))
colnames(xtext)

# look at interactions between text and log price residuals
xtreat = cbind(1,xtext)
ofit = gamlr(x=lpr*xtreat, y=lqr, standardize=FALSE, free=1)

coef(ofit)

gams = coef(ofit)[-1,]


# create a testing matrix, matching each level to a row in X
test_ind = match(levels(beer$item),beer$item)
xtest = xtext[test_ind,]
rownames(xtest) = beer$description[test_ind]

# translate into elasticities and plot
el = drop(gams[1] + xtest%*%gams[(1:ncol(xtext))+1])
hist(el, xlab="OML elasticities", xlim=c(-6,1), col="lightblue", main="",breaks=7)

# high and low sensitivity brands
sort(el) %>% head(20)
sort(el) %>% tail(20)

