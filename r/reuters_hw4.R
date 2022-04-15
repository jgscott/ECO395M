## The tm library and related plugins comprise R's most popular text-mining stack.
## See http://cran.r-project.org/web/packages/tm/vignettes/tm.pdf
library(tm) 
library(tidyverse)
library(slam)
library(proxy)

source("https://gist.githubusercontent.com/jgscott/28d9d1287a0c3c1477e2113f6758d5ff/raw/1f2506b2e49671c879f3ff5862cfb4d25e0511a5/readerPlain.R")

# read in the training set
train_dirs = Sys.glob('../data/ReutersC50/C50train/*')[-c(8, 49)]

file_list = NULL
labels_train = NULL
for(author in train_dirs) {
  author_name = substring(author, first=29)
  files_to_add = Sys.glob(paste0(author, '/*.txt'))
  file_list = append(file_list, files_to_add)
  labels_train = append(labels_train, rep(author_name, length(files_to_add)))
}

corpus_train = Corpus(DirSource(train_dirs)) 

corpus_train = corpus_train %>% tm_map(., content_transformer(tolower)) %>% 
  tm_map(., content_transformer(removeNumbers)) %>% 
  tm_map(., content_transformer(removePunctuation)) %>%
  tm_map(., content_transformer(stripWhitespace)) %>%
  tm_map(., content_transformer(removeWords), stopwords("en"))

DTM_train = DocumentTermMatrix(corpus_train)
DTM_train = removeSparseTerms(DTM_train, 0.99)
DTM_train

# construct TF IDF weights
tfidf_train = weightTfIdf(DTM_train)

X = as.matrix(tfidf_train)
Z = scale(X)

pc_train = prcomp(Z, rank=5)
scores = pc_train$x

scores_by_author = scores %>% 
  as_tibble %>%
  mutate(author = labels_train) %>%
  group_by(author) %>%
  summarize_all(mean) %>%
  column_to_rownames('author')

ggplot(scores_by_author) + 
  geom_label(aes(x=PC1, y=PC2, label=author))


d_authors = dist(scores_by_author)
clust1 = hclust(d_authors, method='average')

plot(clust1)

