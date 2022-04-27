library(tidyverse)
library(tm)
library(gamlr)
library(randomForest)
library(naivebayes)

# Remember to source in the "reader" wrapper function
# it's stored as a Github gist at:
# https://gist.github.com/jgscott/28d9d1287a0c3c1477e2113f6758d5ff
readerPlain = function(fname){
  readPlain(elem=list(content=readLines(fname)), 
            id=fname, language='en') }


## Rolling all directories together into a single training corpus
train_dirs = Sys.glob('../data/ReutersC50/C50train/*')
file_list = NULL
labels_train = NULL
for(author in train_dirs) {
  author_name = substring(author, first=29)
  files_to_add = Sys.glob(paste0(author, '/*.txt'))
  file_list = append(file_list, files_to_add)
  labels_train = append(labels_train, rep(author_name, length(files_to_add)))
}

# create the corpus
corpus_train = Corpus(DirSource(train_dirs)) 

# tokenization and preprocessing
corpus_train = corpus_train %>% tm_map(., content_transformer(tolower)) %>% 
  tm_map(., content_transformer(removeNumbers)) %>% 
  tm_map(., content_transformer(removePunctuation)) %>%
  tm_map(., content_transformer(stripWhitespace)) %>%
  tm_map(., content_transformer(removeWords), stopwords("en"))


## Same operations with the testing corpus
test_dirs = Sys.glob('../data/ReutersC50/C50test/*')
file_list = NULL
labels_test = NULL
for(author in test_dirs) {
  author_name = substring(author, first=28)
  files_to_add = Sys.glob(paste0(author, '/*.txt'))
  file_list = append(file_list, files_to_add)
  labels_test = append(labels_test, rep(author_name, length(files_to_add)))
}

corpus_test = Corpus(DirSource(test_dirs)) 

corpus_test = corpus_test %>% tm_map(., content_transformer(tolower)) %>% 
  tm_map(., content_transformer(removeNumbers)) %>% 
  tm_map(., content_transformer(removePunctuation)) %>%
  tm_map(., content_transformer(stripWhitespace)) %>%
  tm_map(., content_transformer(removeWords), stopwords("en")) 


# create document-term matrices

# create training and testing feature matrices
DTM_train = DocumentTermMatrix(corpus_train)
DTM_train # some basic summary statistics
DTM_train = removeSparseTerms(DTM_train, 0.998) # at least 5 docs

# restrict test-set vocabulary to the terms in DTM_train
DTM_test = DocumentTermMatrix(corpus_test,
                              control = list(dictionary=Terms(DTM_train)))

labels_train = factor(labels_train)
labels_test = factor(labels_test)

###
# Let's try building a simple naive-Bayes classifier
###

x_train = Matrix(DTM_train, nrow=nrow(DTM_train))
x_test = Matrix(DTM_test, nrow=nrow(DTM_test))
colnames(x_train) = Terms(DTM_train)
colnames(x_test) = Terms(DTM_test)

# fit the naive Bayes model
nb_model = multinomial_naive_bayes(x = x_train, y = labels_train)
yhat_test = predict(nb_model, x_test)

# confusion matrix
conf_mat_test = xtabs(~labels_test + yhat_test)
sum(diag(conf_mat_test))/2500  # not bad for a first try

