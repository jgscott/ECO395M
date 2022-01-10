library(tidyverse)
library(arules)  # has a big ecosystem of packages built around it
library(arulesViz)
library(igraph)

# Association rule mining

# Read in playlists from users
# This is in "long" format -- every row is a single artist-listener pair
playlists_raw = read.csv("../data/playlists.csv")

str(playlists_raw)
summary(playlists_raw)

# Barplot of top 20 artists
playcounts = playlists_raw %>%
  group_by(artist) %>%
  summarize(count = n()) %>%
  arrange(desc(count))

head(playcounts, 20) %>%
  ggplot() +
  geom_col(aes(x=reorder(artist, count), y=count)) + 
  coord_flip()


####
# Data pre-preprocessing
####

# Turn user into a factor
playlists_raw$user = factor(playlists_raw$user)

# First create a list of baskets: vectors of items by consumer

# apriori algorithm expects a list of baskets in a special format.
# it's a bit finicky!
# In this case, one "basket" of songs per user
# First split data into a list of artists for each user
playlists = split(x=playlists_raw$artist, f=playlists_raw$user)

# the first users's playlist, the second user's etc
# note the [[ ]] indexing, this is how you extract
# numbered elements of a list in R
playlists[[1]]  # first user's playlist
playlists[[2]]  # second user's playlist

## Remove duplicates ("de-dupe")
# lapply says "apply a function to every element in a list"
# unique says "extract the unique elements" (i.e. remove duplicates)
playlists = lapply(playlists, unique)

## Cast this resulting list of playlists as a special arules "transactions" class.
playtrans = as(playlists, "transactions")
summary(playtrans)

# Now run the 'apriori' algorithm
# Look at rules with support > .01 & confidence >.1 & length (# artists) <= 5
musicrules = apriori(playtrans, 
	parameter=list(support=.01, confidence=.1, maxlen=2))
                         
# Look at the output... so many rules!
inspect(musicrules)

## Choose a subset
inspect(subset(musicrules, lift > 7))
inspect(subset(musicrules, confidence > 0.6))
inspect(subset(musicrules, lift > 10 & confidence > 0.05))

# plot all the rules in (support, confidence) space
# notice that high lift rules tend to have low support
plot(musicrules)

# can swap the axes and color scales
plot(musicrules, measure = c("support", "lift"), shading = "confidence")

# "two key" plot: coloring is by size (order) of item set
plot(musicrules, method='two-key plot')

# can now look at subsets driven by the plot
inspect(subset(musicrules, support > 0.035))
inspect(subset(musicrules, confidence > 0.6))


# graph-based visualization
sub1 = subset(musicrules, subset=confidence > 0.01 & support > 0.005)
summary(sub1)
plot(sub1, method='graph')
?plot.rules

plot(head(sub1, 100, by='lift'), method='graph')

# export a graph
sub1 = subset(musicrules, subset=confidence > 0.25 & support > 0.005)
saveAsGraph(sub1, file = "musicrules.graphml")
