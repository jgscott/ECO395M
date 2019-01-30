library(tidyverse)

data(quakes)
summary(quakes)

# Change the default color theme
theme_set(theme_bw())

ggplot(data = quakes) + 
  geom_point(mapping = aes(x = long, y = lat))

# Cut the depth variable into 9 groups
# default cut points are the quantiles of the data set
quakes$Depth = cut(quakes$depth, 9)

# Use the depth variable as a category to facet on
ggplot(data = quakes) + 
  geom_point(mapping = aes(x = long, y = lat)) + 
  facet_wrap(~ Depth, nrow = 3)

# color points according to magnitude
p1 = ggplot(data = quakes) + 
  geom_point(mapping = aes(x = long, y = lat, color=mag)) + 
  facet_wrap(~ Depth, nrow = 3)
p1

# Note how we've saved the plot as an R object (p1)
# now we can reuse that object, e.g. to change the color scale
p1 + scale_color_gradientn(colors = rainbow(10))
p1 + scale_color_gradientn(colors = cm.colors(10))
p1 + scale_color_gradientn(colors = heat.colors(10))

# There are entire PhDs written on color scales!  Google is your friend here.
