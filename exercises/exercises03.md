# ECO 395M: Exercises 3

Due date: links must be submitted by the beginning of class on Monday, April 8, 2019.   


## Model selection and regularization: green buildings

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
1) to build the best predictive model possible for price;  
2) to use this model to quantify the average change in rental income per square foot (whether in absolute or percentage terms) associated with green certification, holding other features of the building constant; and  
3) to assess whether the "green certification" effect is different for different buildings, or instead whether it seems to be roughly similar across all or most buildings.  

You can choose whether to consider LEED and EnergyStar separately or to collapse them into a single "green certified" category; either way, make sure to justify your choice.  You can use any modeling approaches in your toolkit, and you should also feel free to define new variables based on combinations of existing ones.  Just explain what you've done.  

Write a short report detailing your methods, modeling choice, and conclusions.    



## What causes what?  

First, listen to [this podcast from Planet Money.](https://www.npr.org/sections/money/2013/04/23/178635250/episode-453-what-causes-what)  Then use your knowledge of statistical learning to answer the following questions.

1. Why can’t I just get data from a few different cities and run the regression of “Crime”
on “Police” to understand how more cops in the streets affect crime? (“Crime” refers
to some measure of crime rate and “Police” measures the number of cops in a city.)  

2. How were the researchers from UPenn able to isolate this effect? Briefly describe
their approach and discuss their result in the “Table 2” below, from the researcher's paper.  

![Table 2](ex3table2.png)

3. Why did they have to control for Metro ridership? What was that trying to capture?  

4. Below I am showing you "Table 4" from the researchers' paper.  Just focus
on the first column of the table. Can you describe the model being estimated here?
What is the conclusion?

![Table 4](ex3table2.png)

