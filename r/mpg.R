library(tidyverse)
library(ggplot2)

# Learning goals:
# 1) understand the grammar of graphics using ggplot2
# 2) make a scatterplot that encodes two (and then three) variables
# 3) learn about faceting: stratifying a basic plot by a third variable

# load the mpg data set (comes with tidyverse)
data(mpg)

# first few lines of the data set
# every row is a car, every column is a feature of that car
head(mpg)

# R's basic plotting command: plot(dataset$x, dataset$y)
plot(mpg$displ, mpg$hwy)

# Pros: simple syntax
# Cons: not that pretty, and very hard to do complex things

# We'll use ggplot2 instead
# Cons: commands are less intuitive at first
# Pros: much easier to make sophisticated, beautiful plots

# Basic structure of all statistical graphics:
# A graphic is a mapping of data variables to
# aesthetic attributes of geometric objects.
# all ggplot2 graphs have these three elements:
#   - a data set (data)
#   - a geometry (geom)
#   - an aesthetic mapping (aes)

# Below: creating a ggplot with the "grammar of graphics".
# The first layer tells ggplot where to look for variables (data)
# The second layer makes an "aesthetic mapping" (aes) from:
#   - data variable displ to aesthetic property x (horizontal location)
#   - data variable hwy to aesthetic property y (vertical location)
# It then displays the data in a scatter plot (geom_point)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))


####
# aesthetic mappings can get more complicated, with >2 variables.
####

# here we vary map class to point color
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

# Lots of options for point properties that can be changed.
# Some aesthetic mappings are more effective than others!
# For example, compare the following with our use of color above...

# size of point
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

# transparency
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

# point shape
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))


###
# facets
###

# Here we stratify a scatter plot by some third variable (here class).
# This is a more successful way to show this information than color.

# facet_wrap is added as a third layer to our plot
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

# Now adding our own title, caption, axis labels with labs()
# Here labs() is a fourth layer added to our previous plot.
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2) + 
  labs(
    title = "Fuel efficiency generally decreases with engine size",
    caption = "Data from fueleconomy.gov",
    x="Engine displacement (liters)",
    y="Highway gas mileage (mpg)"
  )


###
# Misc notes
###

# 1) You can save a ggplot as an R object
# try this:
p1 = ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

# Now adding a facet layer to p1
p1 + facet_wrap(~ class, nrow = 2)
p1 + facet_wrap(~ class, nrow = 1)


# 2) You can manually set an aesthetic property by
# placing it _outside_ the aes() command.
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")
