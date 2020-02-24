library(textir)
library(wordcloud)
library(tidyverse)


we8thereRatings = read.csv('../data/we8thereRatings.csv')
we8thereCounts = read.csv('../data/we8thereCounts.csv')


wordcloud(colnames(we8thereCounts), colSums(we8thereCounts)/sum(we8thereCounts), max.words=250, random.order = FALSE)


ind5 = which(we8thereRatings$Overall == 5)
ind1 = which(we8thereRatings$Overall == 1)


cat5_vec = colSums(we8thereCounts[ind5,])
cat5_vec = cat5_vec/sum(cat5_vec)


cat1_vec = colSums(we8thereCounts[ind1,])
cat1_vec = cat1_vec/sum(cat1_vec)




