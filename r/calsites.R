library(tidyverse)
library(igraph)

caedges = read.csv("../data/CaliforniaEdges.csv")
casites = scan("../data/CaliforniaNodes.txt", "character")

# caedges has two columns: from and to
# these integers correspond to the entries in casites
head(casites, 20)

# create an edge matrix with the right names
edgemat = cbind(casites[caedges$from], casites[caedges$to])
edgemat[1,]

# create a graph from the edge list
# this data structure encodes all the node and edge information
# also has some nice plotting and summary methods
calink = graph.edgelist(edgemat)

# one link away
latimes = graph.neighborhood(calink, 1, V(calink)["http://www.latimes.com/HOME/"])[[1]]
plot(latimes, vertex.label=NA)

## two links away
latimes2 = graph.neighborhood(calink, 2, V(calink)["http://www.latimes.com/HOME/"])[[1]]
plot(latimes2, vertex.label=NA)

# a little prettier
# these graphics options from igraph get pretty complex
# need to spend some time with the docs to get the hang of it
# see the docs using ?plot.igraph
V(latimes2)$color <- "lightblue"  
V(latimes2)[V(latimes)$name]$color <- "gold"  # these are the level-one links
V(latimes2)["http://www.latimes.com/HOME/"]$color <- "navy"
plot(latimes2, vertex.label=NA, edge.arrow.width=0, edge.curved=FALSE,
     vertex.label=NA, vertex.frame.color=0, vertex.size=6)



# top 10 sites in the network by betweenness
order(betweenness(calink), decreasing=TRUE)
top10_ind = order(betweenness(calink), decreasing=TRUE)[1:10] %>% head(10)
V(calink)$name[top10_ind]

# run page rank
search = page.rank(calink)$vector
casites[order(search, decreasing=TRUE)[1:20]]

