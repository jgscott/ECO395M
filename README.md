# ECO 395M: Data Mining and Statistical Learning

Welcome to the Spring 2021 edition of ECO 395M, a course on data mining and statistical learning for students in the Master's program in Economics at UT-Austin.  All course materials can be found through this GitHub page.  Please see the [course syllabus](syllabus.md) for details about:  

- expectations  
- assignments and grading  
- readings  
- other important administrative information   

The exercises are [posted here.](https://github.com/jgscott/ECO395M/tree/master/exercises)    

## Office hours

All office hours are held via Zoom:

- James: Mondays and Wednesdays, 8:30 AM to 9:30 AM US Central time.  
- Rui: Tuesdays, 7:00 PM US Central time.  

## Topics outline  


### The data scientist's toolbox

[Slides here.](slides/01-intro/01_intro.pdf)  

Topics: Good data-curation and data-analysis practices; R; Markdown and RMarkdown; the importance of replicable analyses; version control with Git and Github.  Visualization and data workflow.  

Resources to learn Github and RMarkdown:  
- [Introduction to RMarkdown](http://rmarkdown.rstudio.com) and [RMarkdown tutorial](https://rmarkdown.rstudio.com/lesson-1.html)  
- [Introduction to GitHub](https://guides.github.com/activities/hello-world/)   
- [Getting starting with GitHub Desktop](https://help.github.com/en/desktop/getting-started-with-github-desktop)  

[Jeff Leek's guide to sharing data](https://github.com/jtleek/datasharing) is a great resource.  


### Data visualization  

To review material on visualization, please watch these R walkthroughs out of class.  You can find the R scripts and data sets for these videos under the [R](./r) and [data](./data) folders, respectively. 

- [Intro to ggplot2](https://www.youtube.com/watch?v=UK2FhxMnmjQ)  
- [Data workflow and bar plots](https://www.youtube.com/watch?v=k76R7ifcyvs)   
- [Visualizing distributions](https://www.youtube.com/watch?v=wFpzPtdIfTg)   
- [Line graphs](https://www.youtube.com/watch?v=LSDMuOE02ME)   

The idea of these walkthroughs is to give you the resources you'll need to complete the visualization exercises on Homework 1.   Some of this might be review for you, so if that's the case, feel free to move quickly and/or skip familiar bits.   

 On the other hand, if you'd like even _more_ review and practice with R, then I'd suggest working your way through Chapters 1-4 of [Statistical Inference via Data Science: A ModernDive into R and the Tidyverse](https://moderndive.com/index.html), by Ismay and Kim.  In particular, you should know how to create their "five named graphs" in R---those are scatter plots, boxplots, histograms, bar plots, and line graphs.  (The videos are designed to cover these, while the Ismay and Kim reading serves as an extra, optional resource.)  

We'll spend some time in class practicing these skills by working in small groups on your homework problems.   


### Basic concepts in statistical learning  

[Slides here.](slides/02-intro_learning/02_intro_learning.pdf)  

Reading: Chapters 1-2 of "Introduction to Statistical Learning."

In class:  
- [loadhou.R](./r/loadhou.R)  
- [loadhou.csv](./data/loadhou.csv)  


### Linear models  

[Slides here.](slides/03-linear_regression/03_linear_models.pdf)  

Reading: Chapter 3 of "Introduction to Statistical Learning."

In class:  
- [oj.R](r/oj.R) and [oj.csv](data/oj.csv)   
- [saratoga_lm.R](r/saratoga_lm.R)  
- [feature_engineer.R](r/feature_engineer.R))  


### Classification

[Slides here.](slides/04-classification/04-classification.pdf)  


Reading: Chapter 4 of "Introduction to Statistical Learning."

In class:  
- [spamtoy.R](r/spamtoy.r)  
- [spamfit.csv](data/spamfit.csv) and [spamtest.csv](data/spamtest.csv)   
- [glass.R](r/glass.R)  
- [glass_mlr.R](r/glass_mlr.R)   
- [congress109_bayes.R](r/congress109_bayes.R)   
- [congress109.csv](data/congress109.csv)    
- [congress109members.csv](data/congress109members.csv)    
- [glass_LDA.R](r/glass_LDA.R)  


### Model selection and regularization  

[Slides here.](slides/05-selection_regularization/05-selection_regularization.pdf)  


Reading: chapter 6 of _Introduction to Statistical Learning_.  

In-class:  
- [semiconductor.R](r/semiconductor.R) and [semiconductor.csv](data/semiconductor.csv)  
- [gasoline.R](r/gasoline.R) and [gasoline.csv](data/gasoline.csv)  
- [gft_train.csv](data/gft_train.csv) and [gft_test.csv](data/gft_test.csv).  The goal here is to imagine you work at the CDC: build a flu-prediction model using the training data (`cdcflu` is the outcome) and make predictions on the testing data.   


### Trees

[Slides here.](slides/06-trees/06-trees.pdf)  

Reading: Chapter 8 of _Introduction to Statistical Learning_.

[The pdp package](https://journal.r-project.org/archive/2017/RJ-2017-016/RJ-2017-016.pdf) for partial dependence plots from nonparametric regression models.  


### Unsupervised learning: clustering    

[Slides here.](slides/08-clustering/08-clustering.pdf)  
Reading: chapter 10.3 of _Introduction to Statistical Learning_.

In class:  
- [cars.R](r/cars.R)  
- [hclust_examples.R](r/hclust_examples.R)  
- [linkage_minmax.R](r/linkage_minmax.R)  


### Unsupervised learning, continued: PCA, networks, and association rules

Reading: rest of chapter 10 of _Introduction to Statistical Learning_.

[Slides on PCA here.](slides/09-PCA/09-PCA.pdf)  
- [pca_intro.R](r/pca_intro.R)  
- [congress109.R](r/congress109.R)  
- [NCI60.R](r/NCI60.R)  


[Intro slides on networks](notes/networks_intro.pdf).  

[Further slides on networks](slides/arx/Networks.pdf).  

[Slides on association rules here.](https://github.com/jgscott/ECO395M/blob/master/notes/association_rules.pdf)    


Miscellaneous:  
- [Gephi](https://gephi.org/), a great piece of software for exploring graphs  
- [The Gephi quick-start tutorial](https://gephi.org/tutorials/gephi-tutorial-quick_start.pdf)  
- a little Python utility for [scraping Spotify playlists](https://github.com/nithinphilips/spotifyscrape)  



### Text

[Slides on text](notes/text_intro.pdf).   
- [tm_examples.R](r/tm_examples.R) 
- [smallbeer.R](r/smallbeer.R) 

[A bit on treatment-effect estimation](slides/arx/Treatments.pdf). 

### Resampling methods (CV, bootstrap)  

[Slides here.](http://rpubs.com/jgscott/resampling)    
  
In class:  
- [bootstrap.R](r/bootstrap.R)  
- [residual_resampling.R](r/residual_resampling.R)  
- [predimed_bootstrap.R](data/predimed_bootstrap.R)    
- [chymotrypsin.csv](data/chymotrypsin.csv)   
- [ethanol.csv](data/ethanol.csv)    
- [predimed.csv](data/predimed.csv)    




