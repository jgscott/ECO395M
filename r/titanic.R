library(tidyverse)

TitanicSurvival = read.csv('../data/TitanicSurvival.csv')
summary(TitanicSurvival)

# a bit un-interesting
ggplot(data = TitanicSurvival) + 
  geom_bar(mapping = aes(x = survived))

# Let's create a new data set of survival percentages
# We'll group by sex
d1 = TitanicSurvival %>%
  group_by(sex) %>%
  summarize(surv_pct = sum(survived=='yes')/n())
d1

# now make a barplot of survival percentage by sex
ggplot(data = d1) + 
  geom_bar(mapping = aes(x=sex, y=surv_pct), stat='identity')


# aggregate the data set by more than one factor
d2 = TitanicSurvival %>%
  group_by(sex, passengerClass) %>%
  summarize(surv_pct = sum(survived=='yes')/n())
d2

# now plot survival vs passenger class, stratified by sex
# note: position = "dodge" places overlapping objects directly beside one another.
# This makes it easier to compare individual values.
ggplot(data = d2) + 
  geom_bar(mapping = aes(x=passengerClass, y=surv_pct, fill=sex),
           position="dodge", stat='identity') 

# could also facet on sex
ggplot(data = d2) + 
  geom_bar(mapping = aes(x=passengerClass, y=surv_pct), stat='identity') + 
  facet_wrap(~sex)


# Let's do one with three grouping variables

# first create a grouping variable for age
TitanicSurvival = TitanicSurvival %>%
  mutate(agecat = cut(age, c(0, 18, 100)))
summary(TitanicSurvival)

# for now, just remove the NAs
TitanicSurvival = na.omit(TitanicSurvival)

d3 = TitanicSurvival %>%
  group_by(sex, passengerClass, agecat) %>%
  summarize(surv_pct = sum(survived=='yes')/n(), n=n())
d3

# Now make a pretty plot
ggplot(data = d3) + 
  geom_bar(mapping = aes(x=passengerClass, y=surv_pct, fill=agecat),
           stat='identity', position ='dodge') + 
  facet_wrap(~sex) + 
  labs(title="Survival on the Titanic", 
       y="Fraction surviving",
       x = "Passenger Class",
       fill="Age")
