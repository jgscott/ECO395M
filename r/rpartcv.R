library(mosaic)
library(tree)
library(rpart)


#fit a tree to load_coast data
load_coast = read.csv('../data/load_coast.csv')

#first get a big tree using a small value of mindev
# small mindev leads to large tree
temp = rpart(COAST ~ KHOU_temp + KHOU_dewpoint + hour + day + month, data=load_coast, control=rpart.control(minsplit=5, cp=0.00001, xval=10))
plot(temp)

# look at cross validation results
printcp(temp)
plotcp(temp)

yhat = predict(temp)

plot(yhat ~ KHOU_temp, data=load_coast)

