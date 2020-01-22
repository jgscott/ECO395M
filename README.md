# ECO 395M: Data Mining and Statistical Learning

Welcome to ECO 395M, a course on data mining and statistical learning for students in the Master's program in Economics at UT-Austin.  All course materials can be found through this GitHub page.  Please see the [course syllabus](syllabus.md) for links and descriptions of the readings mentioned below.


## Exercises

I will post the exercises [here](exercises/).   

Hey, let's make a change!

## Software 

Please install the following free pieces of software on your own machine:  
- Statistical computing: [R](http://www.r-project.org), which we will use via [RStudio](http://www.rstudio.com), a free, platform-independent graphical front-end for R.  Make sure you have both installed, along with the [RMarkdown package](http://rmarkdown.rstudio.com).   
- Other software: please [install Git and create a GitHub account](https://help.github.com/articles/set-up-git/), if you don't already have one.  You will use GitHub for version control and to submit your assignments.  



## Topics outline  


### Week 1: the data scientist's toolbox

[Slides here.](slides/01-intro/01_intro.pdf)  

Topics: Good data-curation and data-analysis practices; R; Markdown and RMarkdown; the importance of replicable analyses; version control with Git and Github.

In class review of some R:    
- [mpg_review.R](r/mpg_review.R)  

Readings:  
- [Getting starting with GitHub Desktop](https://help.github.com/en/desktop/getting-started-with-github-desktop)  
- [Introduction to RMarkdown](http://rmarkdown.rstudio.com) and [RMarkdown tutorial](https://rmarkdown.rstudio.com/lesson-1.html)  
- [Introduction to GitHub](https://guides.github.com/activities/hello-world/)   
- [Jeff Leek's guide to sharing data](https://github.com/jtleek/datasharing)  

Note: If you'd like a refresher on some techniques for data visualization in R, please refer back to the "Data Exploration and Visualization" section in [ECO 394D](https://github.com/jgscott/ECO394D).  You'll find lots of R scripts and notes there.  


### Weeks 2-3: Basic concepts in statistical learning  

[Slides here.](slides/02-intro_learning/02_intro_learning.pdf)  

Reading: Chapters 1-2 of "Introduction to Statistical Learning."

In class:  
- [loadhou.R](r/loadhou.R)  
- [loadhou.csv](data/loadhou.csv)  
- [spamtoy.R](r/spamtoy.r)  
- [spamfit.csv](data/spamfit.csv) and [spamtest.csv](data/spamtest.csv)   


### Weeks 4-5: Linear models  

[Slides here.](slides/03-linear_regression/03_linear_models.pdf)  

Reading: Chapter 3 of "Introduction to Statistical Learning."

In class:  
- [oj.R](r/oj.R) and [oj.csv](data/oj.csv)   
- [saratoga_lm.R](r/saratoga_lm.R)  
- [gft_train.csv](data/gft_train.csv) and [gft_test.csv](data/gft_test.csv).  The goal here is to imagine you work at the CDC: build a flu-prediction model using the training data (`cdcflu` is the outcome) and make predictions on the testing data.   

### Week 6-7: Classification

[Slides here.](http://rpubs.com/jgscott/classification)

Reading: Chapter 4 of "Introduction to Statistical Learning."

In class:  
- [glass.R](r/glass.R)  
- [glass_mlr.R](r/glass_mlr.R)   
- [congress109_bayes.R](r/congress109_bayes.R)   
- [congress109.csv](data/congress109.csv)    
- [congress109members.csv](data/congress109members.csv)    


### Week 8: Resampling methods (CV, bootstrap)  

[Slides here.](http://rpubs.com/jgscott/resampling)    
  
In class:  
- [bootstrap.R](r/bootstrap.R)  
- [residual_resampling.R](r/residual_resampling.R)  
- [predimed_bootstrap.R](data/predimed_bootstrap.R)    
- [chymotrypsin.csv](data/chymotrypsin.csv)   
- [ethanol.csv](data/ethanol.csv)    
- [predimed.csv](data/predimed.csv)    


### Weeks 9-10: Model selection and regularization  

[Slides here.](http://rpubs.com/jgscott/selection_regularization)  

Reading: chapter 6 of _Introduction to Statistical Learning_.  



### Week 11: Unsupervised learning: clustering    

[Slides here.](http://rpubs.com/jgscott/clustering)    

Reading: chapter 10.3 of _Introduction to Statistical Learning_.



### Week 12-13: Unsupervised learning, continued: PCA, networks, and association rules

Reading: rest of chapter 10 of _Introduction to Statistical Learning_.

[Slides on PCA here.](http://rpubs.com/jgscott/PCA)    

[Intro slides on networks](notes/networks_intro.pdf).  

[Slides on association rules here.](https://github.com/jgscott/ECO395M/blob/master/notes/association_rules.pdf)    

Miscellaneous:  
- [Gephi](https://gephi.org/), a great piece of software for exploring graphs  
- [The Gephi quick-start tutorial](https://gephi.org/tutorials/gephi-tutorial-quick_start.pdf)  
- a little Python utility for [scraping Spotify playlists](https://github.com/nithinphilips/spotifyscrape)  



### Weeks 13-14: Trees

[Slides on trees](notes/trees.pdf).  

Reading: Chapter 8 of _Introduction to Statistical Learning_.

[The pdp package](https://journal.r-project.org/archive/2017/RJ-2017-016/RJ-2017-016.pdf) for partial dependence plots from nonparametric regression models.  



### Week 15: Text

[Slides on text](notes/text_intro.pdf).   


