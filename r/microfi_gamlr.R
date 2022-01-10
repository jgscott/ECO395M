## microfinance network 
## data from BANERJEE, CHANDRASEKHAR, DUFLO, JACKSON 2012
## https://web.stanford.edu/~jacksonm/Banerjee-Chandrasekhar-Duflo-Jackson-DiffusionOfMicrofinance-Science-2013.pdf
library(igraph)
library(gamlr)

## data on 8622 households
hh = read.csv("../data/microfi_households.csv", row.names="hh")
hh$village = factor(hh$village)

# each row is a household
head(hh, 10)

## household networks: based on survey data about household interactions
## commerce/friend/family/etc
edges = read.table("../data/microfi_edges.txt", colClasses="character")

# each row is a connection between households
head(edges, 10)

# pass into igraph for plotting, etc
hhnet = graph.edgelist(as.matrix(edges), directed=FALSE)

# Key scientific question: does centrality in the network
# predict receiving a microfinance loan?

## crosswalk for matching IDs
zebra = match(rownames(hh), V(hhnet)$name)
head(zebra, 10)


## calculate the degree of each household: 
##  (number of commerce/friend/family connections)
## and order these degrees by the same order in hh dataframe
degree = degree(hhnet)[zebra]
names(degree) = rownames(hh)
degree[is.na(degree)] = 0 # unconnected houses, not in our graph
degree_z = scale(degree)

# now use regression to isolate the effect of "degree"
# main effects only
full = glm(loan ~ degree_z + ., data=hh, family="binomial")
summary(full)
# is this satisfying?

## note: if you run a full glm with interactions, it takes forever and is an overfit mess

# full_with_int = glm(loan ~ degree + .^2, data=hh, family="binomial")

# Warning messages:
# 1: glm.fit: algorithm did not converge 
# 2: glm.fit: fitted probabilities numerically 0 or 1 occurred 

# Maybe a lasso fit to penalize interactions?
# how can we isolate a _causal_ effect of network connectedness on microfi adoption?  

sparse_x = sparse.model.matrix(~(.-loan)^2, data=hh)

# run a lasso regression
model_x = cv.gamlr(sparse_x, degree_z, nfold=10)
plot(model_x)
coef(model_x)

degree_hat = predict(model_x, newdata=sparse_x) %>% drop
degree_hat

# hey look!  lots of indepdendent signal here
plot(degree_hat, degree_z)


model_degree = glm(loan ~ degree_z + degree_hat, data=hh, family='binomial')
summary(model_degree)
confint(model_degree)['degree_z',]  %>% exp      
