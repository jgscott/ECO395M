## small beer dataset
beer = read.csv("../data/smallbeer.csv", 
	colClasses=c(rep("factor",3),rep("numeric",2)))
	
head(beer)
nrow(beer)

# pooled fit: one elasticity for all beers
allforone = lm(log(units) ~ log(price), data=beer)
coef(allforone)

# independent elasticities for each beer
oneforall = lm(log(units) ~ log(price)*item, data=beer)

# tons of NAs, lots of noisy coefficients
coef(oneforall)
hist(coef(oneforall)) ## super noisy zeros

# build some regression designs
library(gamlr)



x1 = sparse.model.matrix(~price*item + factor(week)-1, data=beer)
head(x1)
ml1 = cv.gamlr(x=x1, y=log(beer$units), free = 1, standardize=FALSE, verb=TRUE)
coef(ml1)

# how can I get the elasticities?
price_main = coef(ml1)[2]
which_int = grep("price:item", rownames(coef(ml1)), fixed=TRUE)
price_int = coef(ml1)[which_int]

# these look much more reasonable, though not all negative
# of course price is not exogenous here!
hist(price_main + price_int)

####
# Orthogonal ML instead
# strategy: isolate "idiosyncratic" variation price and quantity sold
# by first explicitly adjusting for item and week
####

# OML steps 1-2
xitem = sparse.model.matrix(~item-1, data=beer)
xweek = sparse.model.matrix(~week-1, data=beer)
xx = cbind(xweek, xitem)

# variation in price predicted by item and week
pfit = cv.gamlr(x=xx, y=log(beer$price), lmr=1e-5, standardize=FALSE)

# variation in quantity sold predicted by item and week
qfit = cv.gamlr(x=xx, y=log(beer$units), lmr=1e-5, standardize=FALSE)

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
xtext = sparseMatrix(i=xtext$i,j=xtext$j,x=as.numeric(xtext$v>0), # convert from stm to Matrix format
              dims=dim(xtext),dimnames=dimnames(xtext))
colnames(xtext)

xtreat = cBind(1,xtext,xweek)
ofit = gamlr(x=lpr*xtreat, y=lqr, standardize=FALSE, free=1)
gams = coef(ofit)[-1,]

# create a testing matrix, matching each level to a row in X
test_ind = match(levels(beer$item),beer$item)
xtest = xtext[test_ind,]
rownames(xtest) = beer$description[test_ind]

# translate into elasticities and plot
el = drop(gams[1] + xtest%*%gams[(1:ncol(xtext))+1])
hist(el, xlab="OML elasticities", xlim=c(-6,1), col="lightblue", main="",breaks=7)

# high and low sensitivity brands
names(sort(el)[1:20])
names(sort(-el)[1:20])
