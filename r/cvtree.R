

#######
# cross validation for tree size
# using rpart here
#######
library(rpart)

ethanol = read.csv('../data/ethanol.csv')
plot(NOx ~ E, data=ethanol)

# cross validate on the training set
big.tree = rpart(NOx ~ E, method="anova",data=ethanol,
                 control=rpart.control(minsplit=2, cp=0.0005, xval=10))
# see ?rpart.control for fitting details

plot(NOx ~ E, data=ethanol)
points(predict(big.tree) ~ E, data=ethanol, pch=19, col='red')

length(unique(big.tree$where))

plotcp(big.tree)
printcp(big.tree)

NOx_tree = prune(big.tree, cp=0.01264952)
plot(NOx_tree)
text(NOx_tree,col="blue",label=c("yval"),cex=.8)

plot(NOx ~ E, data=ethanol)
points(predict(NOx_tree) ~ E, data=ethanol, pch=19, col='red')
