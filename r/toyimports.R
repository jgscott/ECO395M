library(ggplot2)
library(tidyverse)

toyimports = read.csv('../data/toyimports.csv')

head(toyimports)

# filter by partner name
uk_toys = toyimports %>%
  filter(partner_name == 'United Kingdom')

head(uk_toys, 10)

#  sum up imports across all different categories
uk_toys_total = uk_toys %>%
  group_by(year) %>%
  summarize(toys = sum(US_report_import))


# Plot the resut over time in a line graph
ggplot(uk_toys_total) + 
  geom_line(aes(x=year, y=toys))

# The x axis is a bit goofy.  Let's manually tell ggplot
# where to put the axis ticks.
ggplot(uk_toys_total) + 
  geom_line(aes(x=year, y=toys)) +
  scale_x_continuous(breaks = 1996:2005)


# Let's look at three countries
country_list = c('China', 'Korea, Rep.', 'United Kingdom')

combined_toys = toyimports %>%
  filter(partner_name %in% country_list) %>%
  group_by(year, partner_name) %>%
  summarize(toys = sum(US_report_import))

combined_toys


# Plot all three as line graphs
ggplot(combined_toys) + 
  geom_line(aes(x=year, y=toys, color=partner_name)) +
  scale_x_continuous(breaks = 1996:2005)

# this plot fails because the three time series are on a
# a very different scale.
# The solution: a logarithmic scale for the y axis
ggplot(combined_toys) + 
  geom_line(aes(x=year, y=toys, color=partner_name)) +
  scale_x_continuous(breaks = 1996:2005) +
  scale_y_log10()

# using a y axis with ticks at specific values
ggplot(combined_toys) + 
  geom_line(aes(x=year, y=toys, color=partner_name)) +
  scale_x_continuous(breaks = 1996:2005) +
  scale_y_log10(breaks = c(5000, 10000, 50000, 1e5, 1e6, 5e6))