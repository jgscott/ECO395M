library(tidyverse)
library(tm)
library(gamlr)

# Remember to source in the "reader" wrapper function
# it's stored as a Github gist at:
# https://gist.github.com/jgscott/28d9d1287a0c3c1477e2113f6758d5ff
readerPlain = function(fname){
				readPlain(elem=list(content=readLines(fname)), 
							id=fname, language='en') }
				
				
## Rolling two directories together into a single training corpus
train_dirs = Sys.glob('../data/ReutersC50/C50train/*')
train_dirs = train_dirs[c(45, 17)]
file_list = NULL
labels_train = NULL
for(author in train_dirs) {
	author_name = substring(author, first=29)
	files_to_add = Sys.glob(paste0(author, '/*.txt'))
	file_list = append(file_list, files_to_add)
	labels_train = append(labels_train, rep(author_name, length(files_to_add)))
}

# Need a more clever regex to get better names here
train_docs = lapply(file_list, readerPlain) 
names(train_docs) = file_list
names(train_docs) = sub('.txt', '', names(train_docs))

corpus_train = Corpus(VectorSource(train_docs))

corpus_train = corpus_train %>% tm_map(., content_transformer(tolower)) %>% 
				tm_map(., content_transformer(removeNumbers)) %>% 
				tm_map(., content_transformer(removePunctuation)) %>%
				tm_map(., content_transformer(stripWhitespace)) %>%
				tm_map(., content_transformer(removeWords), stopwords("SMART"))


## Same operations with the testing corpus
test_dirs = Sys.glob('../data/ReutersC50/C50test/*')
test_dirs = test_dirs[c(45, 17)]
file_list = NULL
labels_test = NULL
for(author in test_dirs) {
	author_name = substring(author, first=28)
	files_to_add = Sys.glob(paste0(author, '/*.txt'))
	file_list = append(file_list, files_to_add)
	labels_test = append(labels_test, rep(author_name, length(files_to_add)))
}

# Need a more clever regex to get better names here
test_docs = lapply(file_list, readerPlain) 
names(test_docs) = file_list
names(test_docs) = sub('.txt', '', names(train_docs))

corpus_test = Corpus(VectorSource(test_docs))

corpus_test = corpus_test %>% tm_map(., content_transformer(tolower)) %>% 
				tm_map(., content_transformer(removeNumbers)) %>% 
				tm_map(., content_transformer(removePunctuation)) %>%
				tm_map(., content_transformer(stripWhitespace)) %>%
				tm_map(., content_transformer(removeWords), stopwords("SMART"))


# create training and testing feature matrices
DTM_train = DocumentTermMatrix(corpus_train)
DTM_train # some basic summary statistics
DTM_train = removeSparseTerms(DTM_train, 0.9)


# restrict test-set vocabulary to the terms in DTM_train
DTM_test = DocumentTermMatrix(corpus_test,
                               control = list(dictionary=Terms(DTM_train)))

# outcome vector
y_train = 0 + {labels_train=='JoWinterbottom'}
y_test = 0 + {labels_test=='JoWinterbottom'}

# lasso logistic regression for document classification
logit1 = gamlr(DTM_train, y_train, family='binomial')
coef(logit1) 
plot(coef(logit1))
yhat_test = predict(logit1, DTM_test, type='response')

xtabs(~ {yhat_test > 0.5} + y_test)
boxplot(as.numeric(yhat_test) ~ y_test)


