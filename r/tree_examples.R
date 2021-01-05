###################################################
## Fit a regression tree to load data
## The tree is plotted as well as a plot of the corresponding step function
## fit to the data.
## The cutpoints from tree are added to the plot so you can see how
## the tree corresponds to the function.
###################################################
library(mosaic)
library(tree)
library(rpart)

#--------------------------------------------------
#fit a tree to load_coast data
load_tree = read.csv('../data/load_tree.csv')

# first get a big tree using a small value of mindev
# small mindev leads to large tree

temp = tree(COAST~temp, data=load_tree, mindev=.00001)
length(unique(temp$where))

#then prune it down to one with 12 leaves
load.tree=prune.tree(temp,best=12)
length(unique(load.tree$where))

#--------------------------------------------------
#plot the tree and the fits.

#plot the tree
plot(load.tree,type="uniform")
text(load.tree,col="blue",label=c("yval"),cex=.8)

#plot data with fit
load.fit = predict(load.tree) #get training fitted values

plot(COAST ~ temp, data=load_tree,cex=.5,pch=16, col=rgb(0,0,0,0.1)) #plot data
oo=order(load_coast$KHOU_temp)
lines(load.fit[oo] ~ temp[oo], data=load_tree,col='red',lwd=3, type='s') #step function fit




################################################################################
## Fit a regression tree to COAST~temp+humidity from the electricity load data.
## The tree is plotted as well as the corresponding partition of the two-dimensional
## x space.
################################################################################

#--------------------------------------------------
#big tree
temp = tree(COAST ~ KHOU_temp + KHOU_dewpoint, data=load_coast, mindev=.00001)
length(unique(temp$where))

#--------------------------------------------------
#then prune it down to one with 20 leaves
load.tree = prune.tree(temp,best=20)

#--------------------------------------------------
# plot tree and partition in x.
plot(load.tree,type="u")
text(load.tree,col="blue",label=c("yval"),cex=.8)
partition.tree(load.tree)


################################################################################
## Read in the California Housing data.
## Transform some of the variables.
## Divide data into train,val,test.
## see cal_setup.R for details
################################################################################
source('cal_setup.R')

################################################################################
# Fit a regression tree to California Housing data:
#    logMedVal ~ longitude+latitude.
# Plot: The tree and the 2-dim partitoon.
# Plot: The California map with the fits from the tree coded with colors.
################################################################################

library(tree)

#--------------------------------------------------
#first get big tree
temp = tree(logMedVal~longitude+latitude,catrain,mindev=.0001)
length(unique(temp$where))

#then prune it
caltrain.tree = prune.tree(temp,best=50)
length(unique(caltrain.tree$where))

#--------------------------------------------------
#plot the tree
plot(caltrain.tree,type="u")
text(caltrain.tree,col="blue",label=c("yval"),cex=.8)


partition.tree(caltrain.tree)



################################################################################
## Fit a classification tree to the penalty data.
## Plot the tree.
################################################################################

library(tree)
source('pen_setup.R')

#--------------------------------------------------
#simple tree on hockey data
#first get big tree
temp = tree(oppcall~.,data=pen,mindev=.0001)
length(unique(temp$where))

#then prune it down 
pen.tree=prune.tree(temp,best=15)

#plot the tree 
par(mfrow=c(1,1))
plot(pen.tree,type="uniform")
options(digits=5)
text(pen.tree,pretty=0,col="blue",label=c("yprob"),cex=.8)
options(digits=7)

