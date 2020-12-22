library(tidyverse)
library(ggplot2)

# Use the Import Dataset button, or change the path name
# to the appropriate location on your computer
us_counties = read.csv('../data/us_counties.csv')

###
# visualizing distributions
###

# R's basic histogram
hist(us_counties$median_income2018)

# histogram in ggplot2
ggplot(data=us_counties) + 
  geom_histogram(aes(x=median_income2018))

# With specified bin width (here $2000)
ggplot(data=us_counties) + 
  geom_histogram(aes(x=median_income2018), binwidth = 2000)

# a density histogram (total area under bars = 1)
ggplot(data=us_counties) + 
  geom_histogram(aes(x=median_income2018, after_stat(density)), binwidth = 2000)

# faceting by rural_urban_code
# 1 = most urban, 9 = most rural
# see https://seer.cancer.gov/seerstat/variables/countyattribs/ruralurban.html
ggplot(data=us_counties) + 
  geom_histogram(aes(x=median_income2018, after_stat(density)), binwidth = 2000) + 
  facet_wrap(~rural_urban_code)


# compare with:
us_counties %>%
  group_by(rural_urban_code) %>%
  summarize(income = mean(median_income2018))

# some in-between options: boxplots and violin plots

# boxplots
# note: factor tells R to treat a numerical code as a categorical variable
ggplot(data=us_counties) + 
  geom_boxplot(aes(x=factor(rural_urban_code), y=median_income2018))

# a boxplot with three variables
ggplot(data=us_counties) + 
  geom_boxplot(aes(x=factor(rural_urban_code), y=median_income2018,
                   fill=percent_college2018>25.5))

# violin plot
ggplot(data=us_counties) + 
  geom_violin(aes(x=factor(rural_urban_code), y=median_income2018))


# use coord_flip to make the boxes go horizontally
ggplot(data=us_counties) + 
  geom_boxplot(aes(x=factor(rural_urban_code), y=median_income2018,
                   fill=percent_college2018>25.5)) + 
  coord_flip()
 



# a variation using ntile
#

# add a variable indicating the education quartile of each county
# using ntile to segment by quartile (4 groups)
us_counties = us_counties %>%
  mutate(educ_quartile = ntile(percent_college2018, 4))

# now make the boxplots filled-in by quartile
p0 = ggplot(data=us_counties) + 
  geom_boxplot(aes(x=factor(rural_urban_code), y=median_income2018,
                   fill=factor(educ_quartile)))
p0

# add some nicer labels and axis ticks to our basic plot
p1 = p0 + labs(x="Rural-urban continuum code (1 = most urban)", 
       y='Median county income', 
       fill='Education quartile') +
  scale_y_continuous(breaks=seq(20000, 140000, by=20000))

p1

# changing the position of the legend
p1 + theme(legend.position = 'bottom')
  