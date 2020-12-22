library(tidyverse)
library(lubridate)

flu = read.csv("../data/gft_train.csv")

head(flu)
flu_long = pivot_longer(flu, cols=-week, values_to='level', names_to = 'term')
flu_long$date = mdy(flu_long$week)

flu_long$term = flu_long$term %>%
  factor %>%
  relevel('cdcflu')

ggplot(flu_long) + 
  geom_line(aes(x=date, y=level)) + 
  facet_wrap(~term, scales='free_y')


ggplot(filter(flu_long, term %in% c('cdcflu', 'fever.cough', 'how.to.get.over.the.flu', 'can.dogs.get.the.flu'))) + 
  geom_line(aes(x=date, y=level)) + 
  facet_wrap(~term, nrow=4, scales='free_y')

ggplot(filter(flu_long, term %in% c('cdcflu', 'i.have.the.flu', 'signs.of.the.flu', 'how.long.does.flu.last'))) + 
  geom_line(aes(x=date, y=level)) + 
  facet_wrap(~term, nrow=4, scales='free_y')

ggplot(filter(flu_long, term %in% c('cdcflu', 'flu.contagious', 'dangerous.fever', 'ear.thermometer'))) + 
  geom_line(aes(x=date, y=level)) + 
  facet_wrap(~term, nrow=4, scales='free_y')