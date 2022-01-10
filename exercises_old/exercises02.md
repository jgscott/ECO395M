# ECO 395M: Exercises 2

Due date: links must be submitted by 9 AM on Monday, March 1, 2021  

## More visualization practice


## Problem 1: visualization

__Background__.  This problem takes you back to the data visualization unit.  Remember, data visualization is one of the most important tools of data science, and it's almost always an important part of building a regression model. The basic skills of "group/pipe/summarize" and plotting are really useful for exploring data, so it's good to keep them sharp.  

__Data and problem__: The data in `capmetro_UT.csv` contains data from Capital Metro, which runs the bus network in Austin, including shuttles (like the West Campus and 40 Acres routes) to, from, and around UT.  The data tracks ridership on buses in the UT area, which is measured by an optical scanner that counts how many people get on and off the bus at each stop.

Each row in the data set corresponds to a 15-minute period between the hours of 6 AM and 10 PM, each and every day, from September through November 2018.  The variables are:  

- timestamp: the beginning of the 15-minute window for that row of data  
- boarding: how many people got on board any Capital Metro bus on the UT campus in the specific 15 minute window  
- alighting: how many people got off ("alit") any Capital Metro bus on the UT campus in the specific 15 minute window  
- day_of_week and weekend: Monday, Tuesday, etc, as well as an indicator for whether it's a weekend.  
- temperature: temperature at that time in degrees F  
- hour_of_day: on 24-hour time, so 6 for 6 AM, 13 for 1 PM, 14 for 2 PM, etc.  
- month: which month  

Your task in this problem is __to make two faceted plots__ and to answer questions about them.     

- One panel of line graphs that plots __average boardings__ grouped by hour of the day, day of week, and month.  You should facet by day of week.  Each facet should include three lines, one for each month, colored differently and with colors labeled with a legend.  Give the figure an informative caption in which you explain what is shown in the figure and address the following questions, citing evidence from the figure.  Does the hour of peak boardings change from day to day, or is it broadly similar across days?   Why do you think average boardings on Mondays in September look lower, compared to other days and months?   Similarly, why do you think average boardings on Weds/Thurs/Fri in November look lower?  

- One panel of scatter plots showing boardings (y) vs. temperature (x) in each 15-minute window, faceted by hour of the day, and with points colored in according to whether it is a weekday or weekend.  Give the figure an informative caption in which you explain what is shown in the figure and answer the following question, citing evidence from the figure.  When we hold hour of day and weekend status constant, does temperature seem to have a noticeable effect on the number of UT students riding the bus?    
These are exactly the kind of figures that Capital Metro planners might use to understand seasonal and intra-week variation in demand for UT bus service.  They're also the kind of figures you'd make to assist in building a model to predict ridership (even though, in this problem you won't actually be building that model).    


### Notes:

All you need to turn in here are the two figures and their captions.  Keep each figure + caption to a single page combined (i.e. two pages, one page for first figure + caption, a second page for second figure + caption).    

Second, a feature of R is that it orders categorical variables alphabetically by default.  This doesn't make sense for something like the day of the week or the month of the year.  So if you want to re-order these variables in their usual order, try pasting the following block of code into your R script at the top, and executing it before you start further work on it.  
```
# Recode the categorical variables in sensible, rather than alphabetical, order
capmetro_UT = mutate(capmetro_UT,
               day_of_week = factor(day_of_week,
                 levels=c("Mon", "Tue", "Wed","Thu", "Fri", "Sat", "Sun")),
               month = factor(month,
                 levels=c("Sep", "Oct","Nov")))
```

## Problem 2: Saratoga house prices

Return to the data set on house prices in Saratoga, NY that we considered in class.  Recall that a starter script here is in `saratoga_lm.R`.  For this data set, you'll run a "horse race" (i.e. a model comparison exercise) between two model classes: linear models and KNN.  

- Build the best linear model for price that you can.  It should clearly outperform the "medium" model that we considered in class.  Use any combination of transformations, engineering features, polynomial terms, and interactions that you want; and use any strategy for selecting the model that you want.  
- Now build the best K-nearest-neighbor regression model for price that you can.  Note: you still need to choose which features should go into a KNN model, but you don't explicitly include interactions or polynomial terms.  The method is sufficiently adaptable to find interactions and nonlinearities, if they are there.   But do make sure to _standardize_ your variables before applying KNN, or at least do something that accounts for the large differences in scale across the different variables here.  

Which model seems to do better at achieving lower out-of-sample mean-squared error?   Write a report on your findings as if you were describing your price-modeling strategies for a local taxing authority, who needs to form predicted market values for properties in order to know how much to tax them.  Keep the main focus on the conclusions and model performance; any relevant technical details should be put in an appendix.  

Note: When measuring out-of-sample performance, there is _random variation_ due to the particular choice of data points that end up in your train/test split.  Make sure your script addresses this by averaging the estimate of out-of-sample RMSE over many different random train/test splits, either randomly or by cross-validation.   


## Problem 3: Classification and retrospective sampling

Consider the data in `german_credit.csv` on loan defaults from a German bank.  The outcome variable of interest in this data set is `default`: a 0/1 indicator for whether a loan fell into default at some point before it was paid back to the bank.  All other variables are features of the loan or borrower that might, in principle, help the bank predict whether a borrower is likely to default on a loan.

This data was collected in a retrospective, "case-control" design.  Defaults are rare, and so the bank sampled a set of loans that had defaulted for inclusion in the study.  It then attempted to match each default with similar sets of loans that had not defaulted, including all reasonably close matches in the analysis.  This resulted in a substantial oversampling of defaults, relative to a random sample of loans in the bank's overall portfolio.  

Of particular interest here is the "credit history" variable (`history`), in which a borrower's credit rating is classified as "Good", "Poor," or "Terrible."  Make a bar plot of default probability by credit history, and build a logistic regression model for predicting default probability, using the variables `duration + amount + installment + age + history + purpose + foreign`.

What do you notice about the `history` variable vis-a-vis predicting defaults?  What do you think is going on here?  In light of what you see here, do you think this data set is appropriate for building a predictive model of defaults, if the purpose of the model is to screen prospective borrowers to classify them into "high" versus "low" probability of default?  Why or why not---and if not, would you recommend any changes to the bank's sampling scheme?    


## Problem 4: Children and hotel reservations

The files `hotels_dev.csv` and `hotels_val.csv` contains data on tens of thousands of hotel stays from a major U.S.-based hotel chain.  The goal of this problem is simple: to build a predictive model for whether a hotel booking will have children on it.  

Why would that be important?  For an equally simple reason: when booking a hotel stay on a website, parents often enter the reservation exclusively for themselves and forget to include their children on the form.  Obviously, the hotel isn't going to turn parents away from their room if they neglected to mention that their children would be staying with them.  But __not__ knowing about those children does, at least in the aggregate, prevent the hotel from making accurate forecasts of resource utilization.   So if, for example, you could use the _other_ features associated with a booking to forecast that a bunch of kids were going to show up unannounced, you might know to order more chicken nuggets for the restaurant and less tequila for the bar.  (Or maybe more tequila, depending on how frazzled the parents who stay at your hotel tend to be.)  In any event, as a hotel operator, if you can forecast the arrival of those kids a bit better, you can  be just a bit more efficient, operationally speaking.  This is an excellent use case for an ML model: a piece of software that can scan the bookings for the week ahead and produce an estimate for how likely each one is to have a "hidden" child on it.  

The target variable of interest is `children`: a dummy variable for whether the booking has children on it.  All other variables in the data set can be used to predict the `children` variable, and the names are pretty self-explanatory.   

### Model building

Using only the data in `hotels.dev.csv`, please compare the out-of-sample performance of the following models:  

1. baseline 1: a small model that uses only the `market_segment`, `adults`, `customer_type`, and `is_repeated_guest` variables as features.   
2. baseline 2: a big model that uses all the possible predictors _except_ the `arrival_date` variable (main effects only).  
3. the best linear model you can build, including any engineered features that you can think of that improve the performance (interactions, features derived from time stamps, etc).  

Use the `hotels_dev.csv` file for your __entire__ model building and testing pipeline.  That is, you'll create your train/test splits using `hotels_dev` only, and not testing at all on `hotels_val`.  Everything in `hotels_val` should be held back for the next part of this exercise.

Note: you can measure out-of-sample performance in any reasonable way that we've talked about in class or that you've encountered in the reading, as long as you are clear how you're doing it.  


### Model validation: step 1

Once you've built your best model and assessed its out-of-sample performance using `hotels_dev`, now turn to the data in `hotels_val`.  Now you'll __validate__ your model using this entirely fresh subset of the data, i.e. one that wasn't used to fit OR test as part of the model-building stage.  (Using a separate "validation" set, completely apart from your training and testing set, is a generally accepted best practice in machine learning.)  

Produce an ROC curve for your best model, using the data in `hotels_val`: that is, plot TPR(t) versus FPR(t) as you vary the classification threshold t.  


### Model validation: step 2

Next, create 20 folds of `hotels_val`.  There are 4,999 bookings in `hotels_val`, so each fold will have about 250 bookings in it -- roughly the number of bookings the hotel might have on a single busy weekend.  For each fold:  

1. Predict whether each booking will have children on it.  
2. Sum up the predicted probabilities for all the bookings in the fold.  This gives an estimate of the expected number of bookings with children for that fold.  
3. Compare this "expected" number of bookings with children versus the actual number of bookings with children in that fold.

How well does your model do at predicting the total number of bookings with children in a group of 250 bookings?  Summarize this performance across all 20 folds of the `val` set in an appropriate figure or table.  

