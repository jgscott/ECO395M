# ECO 395M: Exercises 1

## Data visualization: flights at ABIA

Consider the data in [ABIA.csv](../data/ABIA.csv), which contains information on every commercial flight in 2008 that either departed from or landed at Austin-Bergstrom Interational Airport.  The variable codebook is as follows: 

- Year    all 2008  
- Month   1-12  
- DayofMonth  1-31
- DayOfWeek   1 (Monday) - 7 (Sunday)
- DepTime actual departure time (local, hhmm)
- CRSDepTime  scheduled departure time (local, hhmm)
- ArrTime actual arrival time (local, hhmm)
- CRSArrTime  scheduled arrival time (local, hhmm)
- UniqueCarrier   unique carrier code
- FlightNum   flight number
- TailNum plane tail number
- ActualElapsedTime   in minutes
- CRSElapsedTime  in minutes
- AirTime in minutes
- ArrDelay    arrival delay, in minutes
- DepDelay    departure delay, in minutes
- Origin  origin IATA airport code
- Dest    destination IATA airport code
- Distance    in miles
- TaxiIn  taxi in time, in minutes
- TaxiOut taxi out time in minutes
- Cancelled   was the flight cancelled?
- CancellationCode    reason for cancellation (A = carrier, B = weather, C = NAS, D = security)
- Diverted    1 = yes, 0 = no
- CarrierDelay    in minutes
- WeatherDelay    in minutes
- NASDelay    in minutes 
- SecurityDelay   in minutes  
- LateAircraftDelay   in minutes  

Your task is to create a figure, or set of related figures, that tell an interesting story about flights into and out of Austin.  You can annotate the figure with a detailed caption, of course, but strive to make it as stand-alone as possible.  It shouldn't need many, many paragraphs to convey its meaning.  Rather, the figure should speak for itself as far as possible.  For example, you might consider one of the following questions: 

- What is the best time of day to fly to minimize delays?  
- What is the best time of year to fly to minimize delays?  
- How do patterns of flights to different destinations or parts of the country change over the course of the year?  
- What are the bad airports to fly to?  

But anything interesting will fly.  If you want to try your hand at mapping or looking at geography, you can cross-reference the airport codes here: [https://github.com/datasets/airport-codes](https://github.com/datasets/airport-codes).  Combine this with a mapping package like ggmap, and you should have lots of possibilities!


### K-nearest neighbors  

The data in [sclass.csv](../data/sclass.csv) contains data on over 29,000 Mercedes S Class vehicles---essentially every such car in this class that was advertised on the secondary automobile market during 2014.  For websites like Cars.com or Truecar that aim to provide market-based pricing information to consumers, the Mercedes S class is a notoriously difficult case.  There is a huge range of sub-models that are all labeled "S Class,"" from large luxury sedans to high-performance sports cars; one sub-category of S class even serves as the official pace car in Formula 1 Races.  Moreover, individual submodels involve cars with many different features.  This extreme diversity---unusual for a single model of car---makes it difficult to provide accurate pricing predictions to consumers.

We'll revisit this data set later in the semester when we've got a larger toolkit for building predictive models.  For now, let's focus on three variables in particular:
- trim: categorical variable for car's trim level, e.g. 350, 63 AMG, etc.  The trim is like a sub-model designation.  
- mileage: mileage on the car
- price: the sales price in dollars of the car

Your goal is to use K-nearest neighbors to build a predictive model for price, given mileage, separately for each of two trim levels: 350 and 65 AMG.  (There are lots of other trim levels that you'll be ignoring for this question.) That is, you'll be treating the 350's and the 65 AMG's as two separate data sets.  See [sclass.R](../r/sclass.R) for some code that extracts these two subsets from the full data set.

For each of these two trim levels:
1) Split the data into a training and a testing set.  
2) Run K-nearest-neighbors, for many different values of K, starting at K=2 and going as high as you need to. For each value of K, fit the model to the training set and make predictions on your test set.
3) Calculate the out-of-sample root mean-squared error (RMSE) for each value of K.

For each trim, make a plot of RMSE versus K, so that we can see where it bottoms out.  Then for the optimal value of K, show a plot of the fitted model.  (Again, separately for each of the two trim levels.)

Which trim yields a larger optimal value of K?  Why do you think this is?


