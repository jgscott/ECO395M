library(tidyverse)
library(ggplot2)
### *** data on tv shows from NBC *** ###

shows = read.csv("../data/nbc_showdetails.csv", row.names=1) ## show details; ratings and engagement
# https://digiday.com/marketing/what-is-a-grp-gross-ratings-point/

# predicted engagement versus gross ratings points
ggplot(shows) + 
	geom_point(aes(x=PE, y=GRP, color=Genre))

## Now read the pilot focus group survey results
## for each question, 1=strongly disagree, 5=strongly agree.
## 1: 'The show makes me feel ____', 2: 'I found the show ____'
survey = read.csv("../data/nbc_pilotsurvey.csv") 

pilot_results = survey %>%
	group_by(Show) %>% 
	select(-Viewer) %>%
	summarize_all(mean) %>%
	column_to_rownames(var="Show")
	
# Now look at PCA of the (average) survey responses.  
# This is a common way to treat survey data
PCApilot = prcomp(pilot_results, scale=TRUE)

## variance plot
plot(PCApilot)
summary(PCApilot)

# first few pcs
round(PCApilot$rotation[,1:3],2) 

shows = merge(shows, PCApilot$x[,1:3], by="row.names")
shows = rename(shows, Show = Row.names)

ggplot(shows) + 
	geom_text(aes(x=PC2, y=PC3, label=Show), size=3)

# principal component regression: predicted engagement
lm1 = lm(PE ~ PC1 + PC2 + PC3, data=shows)
summary(lm1)

# gross ratings points
lm2 = lm(GRP ~ PC1 + PC2 + PC3, data=shows)
summary(lm2)

# Conclusion: we can predict engagement and ratings
# with PCA summaries of the pilot survey
plot(PE ~ fitted(lm1), data=shows)
plot(GRP ~ fitted(lm2), data=shows)
