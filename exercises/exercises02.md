# ECO 395M: Exercises 2

Due date: links must be submitted by 5 PM on Friday, March 6, 2020  

## Saratoga house prices

Return to the data set on house prices in Saratoga, NY that we considered in class.  Recall that a starter script here is in `saratoga_lm.R`.  

- See if you can "hand-build" a model for price that outperforms the "medium" model that we considered in class.  Use any combination of transformations, polynomial/spline terms, and interactions that you want.  
- Are there any variables or interactions that seem to be especially strong drivers of house prices?  You can judge this question by assessing how much a variable or interaction improves the out-of-sample RMSE when it is included in the model.  
- Then see if you can turn this hand-built linear model into a better-performing nonparametric model.  Note: don't explicitly include interactions or polynomial terms in your KNN model.  The method is sufficiently adaptable to find them, if they are there.  However, if your linear model did include composite features (like sqft of house per acre of land, or something like that), then you _should_ include those in KNN.  Make sure to _standardize_ your variables before applying KNN, and make sure to include a plot of RMSE versus K.   

Write your report as if you were describing your price-modeling strategies for a local taxing authority, who needs to form predicted market values for properties in order to know how much to tax them.  Keep the focus on the conclusions and model performance, rather than on the technical details.   

Note: When measuring out-of-sample performance, there is _random variation_ due to the particular choice of data points that end up in your train/test split.  Make sure your script addresses this by averaging the estimate of out-of-sample RMSE over many different random train/test splits.   


## A hospital audit

The data in [brca.csv](../data/brca.csv) consist of 987 [screening mammograms](https://www.nlm.nih.gov/medlineplus/mammography.html) administered at a hospital in Seattle, Washington. Five radiologists, each of whom frequently read mammograms, were selected at random from those at the hospital. For each radiologist, roughly 200 of the mammograms each had read were selected at random. Each row of the data set corresponds to a single woman's mammogram.  The radiologist who read it is identified by a three-number code (1-999).

For each patient, two outcomes are recorded.  The first is an indicator of whether the patient was recalled by the radiologist for further diagnostic screening after the radiologist read the mammogram (1=Recalled for further diagnostic screening, 0=Not recalled).  The second outcome is an indicator of whether there was an actual diagnosis of breast cancer within 12 months following the screening mammogram (1=Yes, 0=No).   Ideally, the radiologist should be: (1) minimizing false negatives, i.e. recalling the patients who do end up getting cancer, so that they can be treated as early as possible; and (2) also minimizing false positives, i.e. not recalling the patients who do not end up getting cancer, so that they are not alarmed unnecessarily.  Of course, this ideal not attainable.  Mammography is inexact, and sometimes there will be mistakes.

### Data

In addition to the cancer and recall outcomes, several risk factors for breast cancer identified in previous studies are provided in the data set. Referent values for a “typical patient are indicated by asterisks:
- age: 40-49*, 50-59, 60-69, 70 and older  
- history of breast biopsy/surgery: 0=No*, 1=Yes  
- breast cancer symptoms: 0=No*, 1=Yes  
- menopause/hormone-therapy status: Pre-menopausal, Post-menopausal & no hormone replacement
therapy (HT), Post-menopausal & HT*, Post-menopausal & unknown HT  
- previous mammogram: 0=No*, 1=Yes  
- breast density classification: 1=Almost entirely fatty, 2=Scattered fibroglandular tissue*, 3=Heterogenously dense, 4=Extremely dense  


### Audit goals

The goal of this case study is to examine the performance of the radiologists. This kind of statistical audit is a crucial link in the chain of modern evidence-based hospital practice. Specifically, your audit should address two questions.

First question: are some radiologists more clinically conservative than others in recalling patients, holding patient risk factors equal?

Some advice: imagine two radiologists who see the mammogram of a single patient, who has a specific set of risk factors. If radiologist A has a higher probability of recalling that patient than radiologist B, we’d say that radiologist A is more conservative (because they have a lower threshold for wanting to double-check the patient’s results). So if all five radiologists saw the same set of patients, we’d easily find out whether some radiologists are more conservative than others.  The problem is that the radiologists don’t see the same patients. So we can’t just look at raw recall rates—some radiologists might have seen patients whose clinical situation mandated more conservatism in the first place. Can you build a classification model that addresses this problem, i.e. that holds risk factors constant in assessing whether some radiologists are more conservative than others in recalling patients?

Second question: when the radiologists at this hospital interpret a mammogram to make a decision on whether to recall the patient, does the data suggest that they should be weighing some clinical risk factors more heavily than they currently are?

Again, some advice: let’s focus on family history as a specific risk factor (a similar line of reasoning applies to any risk factor). Consider two different regression models: Model A, which regresses a patient’s cancer outcome on the radiologist’s recall decision; and Model B, which regresses a patient’s cancer outcome on the radiologist’s recall decision AND the patient’s family history. If the radiologist were appropriately accounting for a patient’s family history of breast cancer in interpreting the mammogram and deciding whether to recall the patient for further screening, would you expect that Model B would be any better than Model A at predicting cancer status? Why or why not? If it turns out that Model B is significantly better than Model A, what does that say about the radiologist’s process for making a recall decision?

Prepare your write-up as if you were address the senior doctors in charge of the oncology unit.  You can assume they are familiar with best practices in statistical learning, but that they care most fundamentally about the medicine and take-home lessons of your analysis, rather than the technical details.  


## Predicting when articles go viral

The data in [online_news.csv](../data/online_news.csv) contains data on 39,797 online rticles published by Mashable during 2013 and 2014.  The target variable is `shares`, i.e. how many times the article was shared on social media.  The other variables are article-level features: things like how long the headline is, how long the article is, how positive or negative the "sentiment" of the article was, and so on.  The full list of features is in [online_news_codes.txt](../data/online_news_codes.txt).  

Mashable is interested in building a model for whether the article goes viral or not.  They judge this on the basis of a cutoff of 1400 shares -- that is, the article is judged to be "viral" if shares > 1400.  (This cutoff is somewhat but not entirely arbitrary, because it ultimately has to do with pricing for any ads that appear next to those articles.)  Mashable wants to know if there's anything they can learn about how to improve an article's chance of reaching this threshold.  (E.g. by telling people to write shorter headlines, snarkier articles, or whatever.)  

First approach this problem from the standpoint of regression.  That is, try building your best model for `shares`, or perhaps some transformation of `shares`, using any tools you know (linear modeling, KNN, etc).  To assess the performance of your model on a test set, you should _threshold_ the model's predictions:
- if predicted shares exceeds 1400, predict the article as "viral"
- if predicted shares are 1400 or lower, predict the article as "not viral"

Then compare the predicted viral status with whether the actual test article exceeded 1400 shares.  Note that while the predictions of your model are numerical (shares), the ultimate evaluation is in terms of a binary prediction (shares > 1400).  Report the confusion matrix, overall error rate, true positive rate, and false positive rate for your best model.  Make sure to average these quantities across multiple train/test splits.  How do these numbers compare with a reasonable baseline or "null" model (such as the model which always predicts "not viral")?  

As a second pass, approach this problem from the standpoint of classification.  That is, define a new variable `viral = ifelse(shares > 1400, 1, 0)` and build your very best model for directly predicting viral status as a target variable.  As above, report the confusion matrix, overall error rate, true positive rate, and false positive rate for your best model.  Make sure to average these quantities across multiple train/test splits. 

Which approach performs better: regress first and threshold second, or threshold first and regress/classify second?  Why do you think this is?

Note: don't use the `url` variable as a predictor; it's there for reference only, although you can definitely waste a lot of time reading them all!  




