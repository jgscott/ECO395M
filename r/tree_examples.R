library(tidyverse)
library(ggplot2)
library(rpart)
library(rpart.plot)
library(rsample) 

###
# A classification tree
###

titanic = read.csv('../data/titanic.csv')

# the syntax is very glm-like
# just using the default control settings
titanic_tree = rpart(survived ~ sex + age + passengerClass, data=titanic)

# plot the tree
rpart.plot(titanic_tree, type=4, extra=4)

# the various summaries of the tree
print(titanic_tree) # the structure
summary(titanic_tree)  # more detail on the splits

# in-sample fit, i.e. predict on the original training data
# this returns predicted class probabilities
predict(titanic_tree, newdata=titanic)


###
# Regression trees
###

# fit a tree to load_tree data
load_tree = read.csv('../data/load_tree.csv')

# grow a smallish tree
# larger cp and insplit means stop at a smaller tree
load.tree = rpart(COAST~temp, data=load_tree,
                  control = rpart.control(cp = 0.002, minsplit=30))
# this says: split only if you have at least 30 obs in a node,
# and the split improves the fit by a factor of 0.002

# plot the tree
# see ?rpart.plot for the various plotting options here (type, extra)
rpart.plot(load.tree, digits=-5, type=4, extra=1)


# plot data with fit

# add the predictions to the data frame
load_tree = load_tree %>%
  mutate(COAST_pred = predict(load.tree)) %>%
  arrange(temp)

# now plot the fit over the original data
ggplot(load_tree) + 
  geom_point(aes(x=temp, y=COAST), alpha=0.1) + 
  geom_step(aes(x=temp, y=COAST_pred), color='red', size=2)


# Now let's grow a deeper tree and look at the cross-validation curve
# default is 10-fold cross-validation
load.tree = rpart(COAST~temp, data=load_tree,
                  control = rpart.control(cp = 0.00001, minsplit=5))

# This is pretty typical of CART models:
# the cross-validated error bottoms out and goes back SLOWLY
plotcp(load.tree)

# If you want the actual numbers:
printcp(load.tree)

# hard to visualize!
rpart.plot(load.tree)


###
# Fit a regression tree to COAST~temp+humidity
###

# small tree
load.tree2 = rpart(COAST~temp + dewpoint, data=load_tree,
                   control = rpart.control(cp = 0.0015))
rpart.plot(load.tree2, digits=-5, type=4, extra=1)


# plot tree and implied partition in 2D x space.
load_tree = load_tree %>%
  mutate(COAST_pred2 = predict(load.tree2)) %>%
  arrange(temp)

ggplot(load_tree) + 
  geom_point(aes(x=temp, y=dewpoint, color=COAST_pred2)) + 
  scale_color_continuous(type = "viridis")

# This is pretty blocky
# let's fit a bigger tree
load.tree2 = rpart(COAST~temp + dewpoint, data=load_tree,
                   control = rpart.control(cp = 0.00001))

# cross-validated error plot.
# the result is VERY typical of tree models:
# an initial sharp drop followed by a long flat plateau and then a slow rise. 
plotcp(load.tree2)

# the vertical bars show the standard error of CV error across the 10 splits
plotcp(load.tree2, ylim=c(0.26, 0.28))

# cross-validated error has clearly bottomed out somewhere around cp = 1e-5
# but cp around 5e-5 gives very similar results (within 1 se of minimum)

# you could squint at the table...
printcp(load.tree2)

# a handy function for picking the smallest tree 
# whose CV error is within 1 std err of the minimum
cp_1se = function(my_tree) {
  out = as.data.frame(my_tree$cptable)
  thresh = min(out$xerror + out$xstd)
  cp_opt = max(out$CP[out$xerror <= thresh])
  cp_opt
}

cp_1se(load.tree2)

# this function actually prunes the tree at that level
prune_1se = function(my_tree) {
  out = as.data.frame(my_tree$cptable)
  thresh = min(out$xerror + out$xstd)
  cp_opt = max(out$CP[out$xerror <= thresh])
  prune(my_tree, cp=cp_opt)
}

# let's prune our tree at the 1se complexity level
load.tree2_prune = prune_1se(load.tree2)

# plot the predictions with this deeper (but still pruned) tree
load_tree = load_tree %>%
  mutate(COAST_pred2 = predict(load.tree2_prune)) %>%
  arrange(temp)

# this deeper tree shows a bit finer scale in the step function
ggplot(load_tree) + 
  geom_point(aes(x=temp, y=dewpoint, color=COAST_pred2)) + 
  scale_color_continuous(type = "viridis")

# this is perhaps a cleaner way to see the implied step function:
# create the entire predicted response surface over a grid
X_test = expand.grid(temp=seq(-5,40,by=0.5), dewpoint = seq(-15, 25, by=0.5))
X_test = mutate(X_test, COAST_pred = predict(load.tree2_prune, X_test))

# the resulting grid can be visualized in a tile plot using geom_tile
# nonlinearities and interactions are clearly visible
ggplot(X_test) + 
  geom_tile(aes(x=temp, y=dewpoint, fill=COAST_pred)) + 
  scale_fill_continuous(type = "viridis")


###
# Fit a classification tree to the penalty data.
###

pen = read.table('../data/pen2ref.txt',header=TRUE)

head(pen)
mean(pen$oppcall)

#--------------------------------------------------
# simple tree on hockey data
# first get big tree
temp = rpart(oppcall ~ timespan + goaldiff + numpen + inrow2 + inrow3, data=pen,
             control = rpart.control(cp = 0.0001, minsplit=5))
length(unique(temp$where))

#then prune it down 
pen.tree = prune_1se(temp)

#plot the tree 
rpart.plot(pen.tree, type=4, digits=-5, extra=1, cex=0.5)

# if:
#  - you are not winning (goaldiff < 1)
#  - the last 2 penalties were called against you (inrow2=1)
#  - it's been less than 6.8 minutes since the last penalty called
# then there's a 69% chance the next call will be on the opponent

# but if:
#  - you are winning (goaldiff >= 1)
#  - it's been more than 3.4 minutes since the last penalty
#  - inrow3=0 (so not the case that the last three penalties were called on you)
# then there's a 48% chance the next call will be on the opponent


