library(tidyverse)

data(mpg)
mpg

# creating a ggplot
# The first line sets up a coordinate system.
# the second line maps displ to x, hwy to y, and draws points
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

# mapping color to class
# adding a title by adding another layer
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  labs(title = "Fuel efficiency generally decreases with engine size")


# facets
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)



### Piping/grouping/summarizing

mpg %>%
	group_by(class) %>%
	summarize(mean.cty = mean(cty))

# Let's calculate average MPG for each model across years
mpg_summ = mpg %>%
  group_by(model)  %>%  # group the data points by model nae
  summarize(hwy.mean = mean(hwy))  # calculate a mean for each model

# still not in order...
ggplot(mpg_summ, aes(x=model, y=hwy.mean)) + 
  geom_bar(stat='identity') + 
  coord_flip()

# reorder the x labels
ggplot(mpg_summ, aes(x=reorder(model, hwy.mean), y=hwy.mean)) + 
  geom_bar(stat='identity') + 
  coord_flip()

