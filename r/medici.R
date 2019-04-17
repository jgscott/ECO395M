####
# Marriage and the Medici clan
####

## load the igraph package
library(igraph) 

medici = as.matrix(read.table("../data/medici.txt"))

## create the graph object
marriage = graph.edgelist(medici, directed=FALSE)

## set some color atributes (V() gives back the 'vertices' = nodes)
V(marriage)$color = "orange"
V(marriage)["Medici"]$color = "lightblue"
V(marriage)$frame.color = 0
V(marriage)$label.color = "black"

## plot it
plot(marriage, edge.curved=FALSE)

## print the degree for each family
sort(degree(marriage))

## print the betweenness for each family
betweenness(marriage)  %>% sort %>% round(1)

## calculate shortest paths
allPtoA = all_shortest_paths(marriage, from="Peruzzi", to="Acciaiuoli")

# Somewhat confusing return value
# vpath is a list of the shortest paths 
# First element of vpath is then your vector 
# of vertices along the path.
allPtoA$res[[1]]
