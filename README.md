# ECO 395M: Data Mining and Statistical Learning

Welcome to the Spring 2023 edition of ECO 395M, a course on data mining and statistical learning for students in the Master's program in Economics at UT-Austin.  All course materials can be found through this GitHub page.  Please see the [course syllabus](syllabus.md) for details about:  

- expectations  
- assignments and grading  
- readings  
- other important administrative information   

The exercises will be [posted here](https://github.com/jgscott/ECO395M/tree/master/exercises) as they are assigned throughout the semester.  

## Office hours

Tuesday, 1-2 PM, via Zoom (link on Canvas).

Wednesdays in person, 2:30-3:30 PM, CBA 6.478.  


## Topics outline  

I assume that you start the semester with a basic understanding of R and data visualization, at the level of [Lessons 1-5 of Data Science in R: A Gentle Introduction](https://bookdown.org/jgscott/DSGI/plots.html).  This material was covered in ECO 394D, and although we'll review some of these skills in the course of learning new stuff, it's expected that you're familiar with these lessons from day 1.  


### The data scientist's toolbox

[Slides here.](slides/01-intro/01_intro.pdf)  

Topics: Good data-curation and data-analysis practices; R; Markdown and RMarkdown; the importance of replicable analyses; version control with Git and Github.  Visualization and data workflow.  

Resources to learn Github and RMarkdown:  
- [Introduction to RMarkdown](http://rmarkdown.rstudio.com) and [RMarkdown tutorial](https://rmarkdown.rstudio.com/lesson-1.html)  
- [Introduction to GitHub](https://guides.github.com/activities/hello-world/)   
- [Getting starting with GitHub Desktop](https://help.github.com/en/desktop/getting-started-with-github-desktop)  

[Jeff Leek's guide to sharing data](https://github.com/jtleek/datasharing) is a great resource.  


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
- [saratoga_step.R](r/saratoga_step.R)  
- [semiconductor.R](r/semiconductor.R) and [semiconductor.csv](data/semiconductor.csv)  
- [hockey.R](r/hockey.R) and all the files in [data/hockey/](data/hockey/)  
- [gasoline.R](r/gasoline.R) and [gasoline.csv](data/gasoline.csv)  


### Trees

[Slides here.](slides/06-trees/06-trees.pdf)  

Reading: Chapter 8 of _Introduction to Statistical Learning_.

[The pdp package](https://journal.r-project.org/archive/2017/RJ-2017-016/RJ-2017-016.pdf) for partial dependence plots from nonparametric regression models.  


### Unsupervised learning: clustering    

[Slides here.](slides/07-clustering/07-clustering.pdf)  
Reading: chapter 10.3 of _Introduction to Statistical Learning_.

In class:  
- [cars.R](r/cars.R)  
- [hclust_examples.R](r/hclust_examples.R)  
- [linkage_minmax.R](r/linkage_minmax.R)  


### Unsupervised learning: PCA 

Reading: rest of chapter 10 of _Introduction to Statistical Learning_.

[Slides on PCA here.](slides/08-PCA/08-PCA.pdf)  

- [pca_intro.R](r/pca_intro.R)  
- [nbc.R](r/nbc.R), [nbc_showdetails.csv](data/nbc_showdetails.csv), [nbc_pilotsurvey.csv](data/nbc_pilotsurvey.csv)   
- [congress109.R](r/congress109.R)   
- [ercot_PCA.R](r/ercot_PCA.R), [ercot.zip](data/ercot.zip)  


### Text

[Slides on text](notes/text_intro.pdf).   

- [tm_examples.R](r/tm_examples.R) 
- [smallbeer.R](r/smallbeer.R) 


### Unsupervised learning: networks and association rules

[Intro slides on networks](notes/networks_intro.pdf).  

[Further slides on networks](slides/arx/Networks.pdf).  

[Slides on association rules here.](https://github.com/jgscott/ECO395M/blob/master/notes/association_rules.pdf)    


Miscellaneous:  
- [Gephi](https://gephi.org/), a great piece of software for exploring graphs  
- [The Gephi quick-start tutorial](https://gephi.org/tutorials/gephi-tutorial-quick_start.pdf)  
- a little Python utility for [scraping Spotify playlists](https://github.com/nithinphilips/spotifyscrape)  


### Treatment effects

Treatment effects; multi-armed bandits and Thompson sampling; high-dimensional treatment effects with the lasso.  

Slides:  
- [Treatments](slides/Treatments.pdf).   

Scripts and data:  
- [mab.R](R/mab.R) and [Ads_CTR_Optimisation.csv](data/Ads_CTR_Optimisation.csv)  
- [hockey.R](R/hockey.R) and all files in `data/hockey/`  
- [smallbeer.R](R/smallbeer.R) and [smallbeer.csv](data/smallbeer.csv)  


### Resampling methods   

[Slides here.](slides/bootstrap_VAR.pdf)    
    
 In class:  
- [portfolio.R](r/portfolio.R)  

<!-- 
[Slides here.](http://rpubs.com/jgscott/resampling)    
  
In class:  
- [bootstrap.R](r/bootstrap.R)  
- [residual_resampling.R](r/residual_resampling.R)  
- [predimed_bootstrap.R](data/predimed_bootstrap.R)    
- [chymotrypsin.csv](data/chymotrypsin.csv)   
- [ethanol.csv](data/ethanol.csv)    
- [predimed.csv](data/predimed.csv)    
 -->



