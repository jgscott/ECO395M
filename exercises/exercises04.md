# ECO 395M: Exercises 4

Due date: Monday, April 17, 5 PM US Central Time.  Email submissions to ruizuo11@utexas.edu.  


## Clustering and PCA

The data in [wine.csv](../data/wine.csv) contains information on 11 chemical properties of 6500 different bottles of _vinho verde_ wine from northern Portugal.  In addition, two other variables about each wine are recorded:
- whether the wine is red or white  
- the quality of the wine, as judged on a 1-10 scale by a panel of certified wine snobs.  

Run both PCA and a clustering algorithm of your choice on the 11 chemical properties (or suitable transformations thereof) and summarize your results.  Which dimensionality reduction technique makes more sense to you for this data?  Convince yourself (and me) that your chosen method is easily capable of distinguishing the reds from the whites, using only the "unsupervised" information contained in the data on chemical properties.  Does your unsupervised technique also seem capable of distinguishing the higher from the lower quality wines?  

To clarify: I'm not asking you to run an supervised learning algorithms.  Rather, I'm asking you to see whether the differences in the labels (red/white and quality score) emerge naturally from applying an unsupervised technique to the chemical properties.  This should be straightforward to assess using plots.  


## Market segmentation

Consider the data in [social_marketing.csv](../data/social_marketing.csv).  This was data collected in the course of a market-research study using followers of the Twitter account of a large consumer drinks brand that shall remain nameless---let's call it "NutrientH20" just to have a label.  The goal here was for NutrientH20 to understand its social-media audience a little bit better, so that it could hone its messaging a little more sharply.

A bit of background on the data collection: the advertising firm who runs NutrientH20's online-advertising campaigns took a sample of the brand's Twitter followers.  They collected every Twitter post ("tweet") by each of those followers over a seven-day period in June 2014.  Every post was examined by a human annotator contracted through [Amazon's Mechanical Turk](https://www.mturk.com/mturk/welcome) service.  Each tweet was categorized based on its content using a pre-specified scheme of 36 different categories, each representing a broad area of interest (e.g. politics, sports, family, etc.)  Annotators were allowed to classify a post as belonging to more than one category.  For example, a hypothetical post such as "I'm really excited to see grandpa go destroy the competition in his geriatric soccer league this Sunday!" might be categorized as both "family" and "sports."  You get the picture.

Each row of [social_marketing.csv](../data/social_marketing.csv) represents one user, labeled by a random (anonymous, unique) 9-digit alphanumeric code.  Each column represents an interest, which are labeled along the top of the data file.  The entries are the number of posts by a given user that fell into the given category.  Two interests of note here are "spam" (i.e. unsolicited advertising) and "adult" (posts that are pornographic or otherwise explicit).  There are a lot of spam and pornography ["bots" on Twitter](http://mashable.com/2013/11/08/twitter-spambots/); while these have been filtered out of the data set to some extent, there will certainly be some that slip through.  There's also an "uncategorized" label.  Annotators were told to use this sparingly, but it's there to capture posts that don't fit at all into any of the listed interest categories.  (A lot of annotators may used the "chatter" category for this as well.)  Keep in mind as you examine the data that you cannot expect perfect annotations of all posts.  Some annotators might have simply been asleep at the wheel some, or even all, of the time!  Thus there is some inevitable error and noisiness in the annotation process.

Your task to is analyze this data as you see fit, and to prepare a (short!) report for NutrientH20 that identifies any interesting market segments that appear to stand out in their social-media audience.  You have _complete freedom_ in deciding how to pre-process the data and how to define "market segment." (Is it a group of correlated interests?  A cluster? A principal component?  Etc.  You decide the answer to this question---don't ask me!)  Just use the data to come up with some interesting, well-supported insights about the audience and give your client some insight as to how they might position their brand to maximally appeal to each market segment.  



## Association rules for grocery purchases

Revisit the notes on association rule mining and the R example on music playlists: [playlists.R](../R/playlists.R) and [playlists.csv](../data/playlists.csv).  Then use the data on grocery purchases in [groceries.txt](../data/groceries.txt) and find some interesting association rules for these shopping baskets.  The data file is a list of shopping baskets: one person's basket for each row, with multiple items per row separated by commas -- you'll have to cobble together a few utilities for processing this into the format expected by the "arules" package.  Pick your own thresholds for lift and confidence; just be clear what these thresholds are and how you picked them.  Do your discovered item sets make sense?  Present your discoveries in an interesting and concise way.  



## Image classification with neural networks

In this problem, you will train a neural network to classify satellite images.  In the [data/EuroSAT_RGB](https://github.com/jgscott/STA380/tree/master/data/EuroSAT_RGB) directory, you will find 11 subdirectories, each corresponding to a different class of land or land use: e.g. industrial, crops, rivers, forest, etc.  Within each subdirectory, you will find examples in .jpg format of each type.  (Thus the name of the directory in which the image lives is the class label.)  

Your job is to set up a neural network that can classify the images as accurately as possible.  Use an 80/20 train test split.  Summarize your model and its accuracy in any way you see fit, but make you include _at a minimum_ the following elements:

- overall test-set accuracy, measured however you think is appropriate   
- show some of the example images from the test set, together with your model's predicted classes. 
- a confusion matrix showing the performance of the model on the set test, i.e. a table that cross-tabulates each test set example by (actual class, predicted class).  

I strongly recommend the use of PyTorch in a Jupyter notebook for this problem; look into PyTorch's `ImageFolder` data set class, which will streamline things considerably.  


