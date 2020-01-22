library(mosaic)
sclass = read.csv('../data/sclass.csv')

# The variables involved
summary(sclass)

# Focus on 2 trim levels: 350 and 65 AMG
sclass550 = subset(sclass, trim == '350')
dim(sclass550)

sclass65AMG = subset(sclass, trim == '65 AMG')
summary(sclass65AMG)

# Look at price vs mileage for each trim level
plot(price ~ mileage, data = sclass550)
plot(price ~ mileage, data = sclass65AMG)

