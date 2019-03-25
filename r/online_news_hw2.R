online_news = read.csv('../data/online_news.csv')
head(online_news)

# first "regression and threshold"

# note that shares is hugely skewed
# probably want a log transformation here
hist(online_news$shares)

# much nicer :-)
hist(log(online_news$shares))

# first try on a 
lm1 = lm(log(shares) ~ . - url, data=online_news)
summary(lm1)


# drop things that seem (nearly) perfectly collinear with other variables
lm2 = lm(log(shares) ~ . - url - n_tokens_content - self_reference_max_shares -
           weekday_is_saturday - weekday_is_sunday - is_weekend -
           max_positive_polarity - min_negative_polarity,
         data=online_news)
summary(lm2)

lm_step = 
