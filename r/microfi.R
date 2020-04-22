## microfinance network 
## data from BANERJEE, CHANDRASEKHAR, DUFLO, JACKSON 2012
## https://web.stanford.edu/~jacksonm/Banerjee-Chandrasekhar-Duflo-Jackson-DiffusionOfMicrofinance-Science-2013.pdf
library(igraph)

## data on 8622 households
hh = read.csv("../data/microfi_households.csv", row.names="hh")
hh$village = factor(hh$village)

# each row is a househouse
head(hh, 10)

## household networks: based on survey data about household interactions
## commerce/friend/family/etc
edges = read.table("../data/microfi_edges.txt", colClasses="character")

# each row is a connection between households
head(edges, 10)

# pass into igraph for plotting, etc
hhnet = graph.edgelist(as.matrix(edges), directed=FALSE)

V(hhnet) ## our 8000+ household vertices

## Each vertex (node) has some attributes, and we can add more fron the hh data
V(hhnet)$village = as.character(hh[V(hhnet),'village'])

## we'll color vertices by village membership
vilcol = rainbow(nlevels(hh$village))
names(vilcol) = levels(hh$village)
V(hhnet)$color = vilcol[V(hhnet)$village]

## drop HH labels from plot
V(hhnet)$label=NA

# plots of large graphs can take awhile
# I've found edge.curved=FALSE speeds plots up a lot.  Not sure why.

## we'll use induced.subgraph to select subsets of nodes and plot a couple villages 
village1 = induced.subgraph(hhnet, v=which(V(hhnet)$village=="1"))
village33 = induced.subgraph(hhnet, v=which(V(hhnet)$village=="33"))

# vertex.size=3 is small.  default is 15
plot(village1, vertex.size=3, edge.curved=FALSE)
plot(village33, vertex.size=3, edge.curved=FALSE)


######  now, on to some regression stuff!
library(gamlr)

# Key scientific question: does centrality in the network
# predict receiving a microfinance loan?

## First have to match id's! I call these 'zebras'here because they are like
# "crosswalks" between the two data frames
# Each entry in zebra tells us where to look in the graph to find that household
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
