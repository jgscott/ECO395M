library(tidyverse)

data(mpg)
mpg

# creating a ggplot
# The first line sets up a coordinate system.
# the second line maps displ to x, hwy to y, and draws points
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

# aesthetic mappings can get more complicated:
# here we vary point color by some third variable
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

# Lots of options for point characeristics that can be changed.
# Some aesthetic mappings are more effective than others!
# For example, compare the following:
# size of point
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

# transparency
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

# point shape
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

# adding a title
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  labs(title = "Fuel efficiency generally decreases with engine size")

# manually setting an aesthetic property
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

# note: compare with
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))

# facets
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

# faceting on two variables
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)


# Add smoothing: how is this done?
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(title = "Fuel efficiency generally decreases with engine size")


# adding a caption
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(
    title = "Fuel efficiency generally decreases with engine size",
    caption = "Data from fueleconomy.gov"
  )


# axis labels
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_smooth(se = FALSE) +
  labs(
    x = "Engine displacement (L)",
    y = "Highway fuel economy (mpg)",
    colour = "Car type"
  )


# Density plot: like a histogram
g = ggplot(mpg, aes(x=cty))
g + geom_density(aes(fill=factor(cyl)))

# how about a little more transparency?
g + geom_density(aes(fill=factor(cyl)), alpha=0.6)

# now some labels
g + geom_density(aes(fill=factor(cyl)), alpha=0.6) +
  labs(title="Density plot", 
       subtitle="City Mileage vs Cylinders in Engine",
       caption="Source: mpg data set in R",
       x="City Gas Mileage",
       fill="# Cylinders")


# How about a bar chart?
ggplot(mpg, aes(x=model, y=hwy)) + 
  geom_bar(stat='identity')

# a little easier to read
ggplot(mpg, aes(x=model, y=hwy)) + 
  geom_bar(stat='identity') + 
  coord_flip()

# What's wrong?
mpg

# Let's calculate average MPG across model years
# We do this using pipes:
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


# what about plotting z scores instead?

# first add a new column using the mutate function
mpg_summ = mutate(mpg_summ, hwy.z = (hwy.mean - mean(hwy.mean))/sd(hwy.mean))

# now plot the newly defined variable
ggplot(mpg_summ, aes(x=reorder(model, hwy.z), y=hwy.z)) + 
  geom_bar(stat='identity') + 
  labs(title="Highway mileage by model", 
       caption="Source: mpg data set in R",
       y="Highway gas mileage (z-score)",
       x = "Model") + 
  coord_flip()


# here we keep the typical horizontal orientation,
# but change the angle of the axis labels to make them readable
ggplot(mpg_summ, aes(x=reorder(model, hwy.z), y=hwy.z)) + 
  geom_bar(stat='identity') + 
  labs(title="Highway mileage by model", 
       caption="Source: mpg data set in R",
       y="Highway gas mileage (z-score)",
       x = "Model") + 
  theme(axis.text.x = element_text(angle=90, vjust=0.6))
