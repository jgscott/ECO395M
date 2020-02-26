library(wordcloud)
library(tidyverse)


we8thereRatings = read.csv('../data/we8thereRatings.csv', row.names=1)
we8thereCounts = read.csv('../data/we8thereCounts.csv', row.names=1)


ind5 = which(we8thereRatings$Overall == 5)
ind1 = which(we8thereRatings$Overall == 1)


cat5_vec = colSums(we8thereCounts[ind5,])
cat5_vec = cat5_vec/sum(cat5_vec)


cat1_vec = colSums(we8thereCounts[ind1,])
cat1_vec = cat1_vec/sum(cat1_vec)




