#### Forensic Glass
library(tidyverse)
library(ggplot2)
library(MASS) 	## a library of example datasets
library(caret)
library(modelr)
library(rsample)
data(fgl) 		## loads the data into R; see help(fgl)

# goal: automatic classification of glass shards into 6 types
# features: refactive index, plus concentrations of 8 elements
summary(fgl)

# the target variable is type:
# WinF: float glass window
# WinNF: non-float window
# Veh: vehicle window
# Con: container (bottles)
# Tabl: tableware
# Head: vehicle headlamp

# set up a plot
p0 = ggplot(data = fgl)

# some variables are clear discriminators of at least 1 class
p0 + geom_boxplot(aes(x=type, y=Ba))
p0 + geom_boxplot(aes(x=type, y=Mg))
p0 + geom_boxplot(aes(x=type, y=Na))

# some a decent for partially separating some of the classes
p0 + geom_boxplot(aes(x=type, y=Al))

# some are more subtle
p0 + geom_boxplot(aes(x=type, y=RI))
p0 + geom_boxplot(aes(x=type, y=Si))
p0 + geom_boxplot(aes(x=type, y=Fe))


# Let's scale our features
# this says: "scale everything except the "type" variable"
fgl_scale = fgl %>%
  mutate(across(!type, scale))

## for illustration, consider the RIxMg plane (i.e., just 2D)
ggplot(data = fgl_scale) +
  geom_point(aes(x=RI, y=Mg, shape=type))

# select a training set
fgl_split = initial_split(fgl_scale, 0.8)
fgl_train = training(fgl_split)
fgl_test = testing(fgl_split)


# Fit two KNN models (notice the odd values of K -- easier to break ties)
# for whatever reason caret's knn function is called "knn3"
knn_K5 = caret::knn3(type ~ RI + Mg, data=fgl_scale, k=5)
knn_K25 = caret::knn3(type ~ RI + Mg, data=fgl_scale, k=25)

## plot them to see how it worked

# put the data and predictions in a single data frame
fgl_test = fgl_test %>%
  mutate(type_pred_K5 = predict(knn_K5, fgl_test, type='class'),
         type_pred_K25 = predict(knn_K25, fgl_test, type='class'))

ggplot(data=fgl_test) +
	geom_point(aes(x=RI, y=Mg, shape=type), size=2)

ggplot(data=fgl_test) +
  geom_point(aes(x=RI, y=Mg, shape=type_pred_K5,
                 color=(type==type_pred_K5)))

ggplot(data=fgl_test) +
  geom_point(aes(x=RI, y=Mg, shape=type_pred_K25,
                 color=(type==type_pred_K25)))

# test set errors?
fgl_test

# Make a table of classification errors
xtabs(~type + type_pred_K5, data=fgl_test)
xtabs(~type + type_pred_K25, data=fgl_test)

# performance:
nrow(fgl_test)
xtabs(~type + type_pred_K5, data=fgl_test) %>% diag %>% sum
xtabs(~type + type_pred_K25, data=fgl_test) %>% diag %>% sum

