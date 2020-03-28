# ECO 395M: Exercises 3

Due date: links must be submitted by the beginning of class on Monday, April 20, 2020.   


## Predictive model building  

Return to the data set on green buildings, [greenbuildings.csv](../data/greenbuildings.csv), from Exercises 1.  Recall that this contains data on 7,894 commercial rental properties from across the United States. Of these, 685 properties have been awarded either LEED or EnergyStar certification as a green building.  You can revisit the description in exercises 1 for a reminder of the business context here, but here is a list of the variables:

* CS.PropertyID:  the building's unique identifier in the database.  
* cluster:  an identifier for the building cluster, with each cluster containing one green-certified building and at least one other non-green-certified building within a quarter-mile radius of the cluster center.  
* size:  the total square footage of available rental space in the building.  
* empl.gr:  the year-on-year growth rate in employment in the building's geographic region.  
* Rent:  the rent charged to tenants in the building, in dollars per square foot per calendar year.  
* leasing.rate:  a measure of occupancy; the fraction of the building's available space currently under lease.  
* stories:  the height of the building in stories.  
* age:  the age of the building in years.  
* renovated:  whether the building has undergone substantial renovations during its lifetime.  
* class.a, class.b:  indicators for two classes of building quality (the third is Class C).  These are relative classifications within a specific market.  Class A buildings are generally the highest-quality properties in a given market.  Class B buildings are a notch down, but still of reasonable quality.  Class C buildings are the least desirable properties in a given market.  
* green.rating:  an indicator for whether the building is either LEED- or EnergyStar-certified.  
* LEED, Energystar:  indicators for the two specific kinds of green certifications.  
* net:  an indicator as to whether the rent is quoted on a ``net contract'' basis.  Tenants with net-rental contracts pay their own utility costs, which are otherwise included in the quoted rental price.  
* amenities:  an indicator of whether at least one of the following amenities is available on-site: bank, convenience store, dry cleaner, restaurant, retail shops, fitness center.  
* cd.total.07:  number of cooling degree days in the building's region in 2007.  A degree day is a measure of demand for energy; higher values mean greater demand.  Cooling degree days are measured relative to a baseline outdoor temperature, below which a building needs no cooling.  
* hd.total07:  number of heating degree days in the building's region in 2007.  Heating degree days are also measured relative to a baseline outdoor temperature, above which a building needs no heating.  
* total.dd.07:  the total number of degree days (either heating or cooling) in the building's region in 2007.  
* Precipitation:  annual precipitation in inches in the building's geographic region.
* Gas.Costs:  a measure of how much natural gas costs in the building's geographic region.  
* Electricity.Costs:  a measure of how much electricity costs in the building's geographic region.  
* cluster.rent:  a measure of average rent per square-foot per calendar year in the building's local market.  

Your goals are:  
1) to build the best predictive model possible for price; and
2) to use this model to quantify the average change in rental income per square foot (whether in absolute or percentage terms) associated with green certification, holding other features of the building constant.    


You can choose whether to consider LEED and EnergyStar separately or to collapse them into a single "green certified" category.  You can use any modeling approaches in your toolkit (regression variable selection, trees, etc), and you should also feel free to define new variables based on combinations of existing ones.  Just make sure to explain what you've done.  

Write a short report detailing your methods, modeling choice, and conclusions, following the [report-writing guidelines posted on the website](https://jgscott.github.io/teaching/writeups/write_ups/).  



## What causes what?  

First, listen to [this podcast from Planet Money.](https://www.npr.org/sections/money/2013/04/23/178635250/episode-453-what-causes-what)  Then use your knowledge of statistical learning to answer the following questions.

1. Why can’t I just get data from a few different cities and run the regression of “Crime” on “Police” to understand how more cops in the streets affect crime? (“Crime” refers to some measure of crime rate and “Police” measures the number of cops in a city.)  

2. How were the researchers from UPenn able to isolate this effect? Briefly describe their approach and discuss their result in the “Table 2” below, from the researchers' paper.  

![Table 2](ex3table2.png)

3. Why did they have to control for Metro ridership? What was that trying to capture?   

4. Below I am showing you "Table 4" from the researchers' paper.  Just focus
on the first column of the table. Can you describe the model being estimated here?
What is the conclusion?

![Table 4](ex3table4.png)



## Clustering and PCA

The data in [wine.csv](../data/wine.csv) contains information on 11 chemical properties of 6500 different bottles of _vinho verde_ wine from northern Portugal.  In addition, two other variables about each wine are recorded:
- whether the wine is red or white  
- the quality of the wine, as judged on a 1-10 scale by a panel of certified wine snobs.  

Run both PCA and a clustering algorithm of your choice on the 11 chemical properties (or suitable transformations thereof) and summarize your results. Which dimensionality reduction technique makes more sense to you for this data?  Convince yourself (and me) that your chosen method is easily capable of distinguishing the reds from the whites, using only the "unsupervised" information contained in the data on chemical properties.  Does this technique also seem capable of sorting the higher from the lower quality wines?


## Market segmentation

Consider the data in [social_marketing.csv](../data/social_marketing.csv).  This was data collected in the course of a market-research study using followers of the Twitter account of a large consumer brand that shall remain nameless---let's call it "NutrientH20" just to have a label.  The goal here was for NutrientH20 to understand its social-media audience a little bit better, so that it could hone its messaging a little more sharply.

A bit of background on the data collection: the advertising firm who runs NutrientH20's online-advertising campaigns took a sample of the brand's Twitter followers.  They collected every Twitter post ("tweet") by each of those followers over a seven-day period in June 2014.  Every post was examined by a human annotator contracted through [Amazon's Mechanical Turk](https://www.mturk.com/mturk/welcome) service.  Each tweet was categorized based on its content using a pre-specified scheme of 36 different categories, each representing a broad area of interest (e.g. politics, sports, family, etc.)  Annotators were allowed to classify a post as belonging to more than one category.  For example, a hypothetical post such as "I'm really excited to see grandpa go wreck shop in his geriatic soccer league this Sunday!" might be categorized as both "family" and "sports."  You get the picture.

Each row of [social_marketing.csv](../data/social_marketing.csv) represents one user, labeled by a random (anonymous, unique) 9-digit alphanumeric code.  Each column represents an interest, which are labeled along the top of the data file.  The entries are the number of posts by a given user that fell into the given category.  Two interests of note here are "spam" (i.e. unsolicited advertising) and "adult" (posts that are pornographic or otherwise explicit).  There are a lot of spam and pornography ["bots" on Twitter](http://mashable.com/2013/11/08/twitter-spambots/); while these have been filtered out of the data set to some extent, there will certainly be some that slip through.  There's also an "uncategorized" label.  Annotators were told to use this sparingly, but it's there to capture posts that don't fit at all into any of the listed interest categories.  (A lot of annotators may used the "chatter" category for this as well.)  Keep in mind as you examine the data that you cannot expect perfect annotations of all posts.  Some annotators might have simply been asleep at the wheel some, or even all, of the time!  Thus there is some inevitable error and noisiness in the annotation process.

Your task to is analyze this data as you see fit, and to prepare a (short!) report for NutrientH20 that identifies any interesting market segments that appear to stand out in their social-media audience.  You have complete freedom in deciding how to pre-process the data and how to define "market segment." (Is it a group of correlated interests?  A cluster? A principal component?  Etc.)  Just use the data to come up with some interesting, well-supported insights about the audience and give your client some insight as to how they might position their brand to maximally appeal to each market segment.  
