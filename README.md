# ECO 395M: Data Mining and Statistical Learning

Welcome to ECO 395M, a course on data mining and statistical learning for students in the Master's program in Economics at UT-Austin.  All course materials can be found through this GitHub page.  Please see the [course syllabus](syllabus.md) for links and descriptions of the readings mentioned below.


## Exercises

I will post the exercises [here](exercises/) and will call attention to their due dates in the week-by-week outline below.   

## Week-by-week running outline 

Every week I will update this outline to reflect what we're currently working on, as well as to give you a preview of what's coming.  


### Week 2: data visualization and practice with R

Contingency tables and bar plots; basic plots for numerical data (scatterplot, boxplot, histogram, line graphs); lattice plots.  Introduction to ggplot2.  

Examples of [bad graphics](notes/badgraphics.pdf).  [Baby set of slides here.](http://rpubs.com/jgscott/datavis1).

Some software walkthroughs that show some of the capabilities of basic R graphics: 
- [Survival on the Titanic](https://github.com/jgscott/learnR/blob/master/titanic/titanic.md): summarizing variation in categorical variables  
- [City temperatures](https://github.com/jgscott/learnR/blob/master/citytemps/citytemps.md): measuring and visualizing dispersion in one numerical variable.  
- [Test scores and GPA for UT grads](https://github.com/jgscott/learnR/blob/master/sat/sat.md): association between numerical and categorical variables.  

If you really want to get good at plotting in R, you should learn ggplot2:
- [mpg.R](r/mpg.R)  
- [Introduction to ggplot2](https://r4ds.had.co.nz/data-visualisation.html)
- [Graphics for communication](https://r4ds.had.co.nz/graphics-for-communication.html)  


Readings:   
- [excerpts](notes/DataExploration.pdf) from my course notes on data science.  We'll look at some example graphics in Chapter 1.  
- Good graphics: scan through some of the New York Times' best [data visualizations](https://www.nytimes.com/interactive/2017/12/21/us/2017-year-in-graphics.html).  Lots of good stuff here but for our purposes, the best things to look at are those in the "Data Visualizations" section, about 60% of the way down the page.  Control-F for "Data Visualization" and you'll find it.  Here are three examples:  
1) [Low-income students in college](https://www.nytimes.com/interactive/2017/01/18/upshot/some-colleges-have-more-students-from-the-top-1-percent-than-the-bottom-60.html)  
2) [The French presidential election](https://www.nytimes.com/interactive/2017/04/23/world/europe/french-election-results-maps.html)  
3) [LeBron James's playoff scoring record](https://www.nytimes.com/interactive/2017/05/25/sports/basketball/lebron-career-playoff-points-record.html)  


### Week 1: the data scientist's toolbox

[Slides here.](http://rpubs.com/jgscott/intro_ECO395M) 

Topics: Good data-curation and data-analysis practices; R; Markdown and RMarkdown; the importance of replicable analyses; version control with Git and Github.

The first thing to do is to install [R](http://www.r-project.org) and then [RStudio](http://www.rstudio.org) on your own computer.  Detailed instructions for installing these two programs [can be found here](https://github.com/jgscott/learnR/blob/master/basics/installing_R.md).  Both are free.

R is the underlying data-analysis program we'll use in this course, while RStudio provides a nice front-end interface to R that makes certain repetitive steps (e.g. loading data, saving plots) very simple.   I will use RStudio in class most days this semester, and you will use it most weeks for your homework.  RStudio depends upon having R available behind the scenes, so make sure you install both, even though you won't need to interact directly with R.  

Please install these on your own computer; you'll need them for the second day of class.  At some point before class next week, complete the following R walkthroughs if you need an R refresher.  If you're comfortable with R, you can safely skip these.   
- [Getting started with R.](https://github.com/jgscott/learnR/blob/master/heights/heights.md)   
- [Installing a library in R.](https://github.com/jgscott/learnR/blob/master/basics/installing_library.md)    


Important links:  
- [Introduction to RMarkdown](http://rmarkdown.rstudio.com)  
- [RMarkdown tutorial](https://rmarkdown.rstudio.com/lesson-1.html)  
- [Introduction to GitHub](https://guides.github.com/activities/hello-world/)   
- [Jeff Leek's guide to sharing data](https://github.com/jtleek/datasharing)  


Looking ahead to next week: data visualization.  The following software walkthroughs will help you get your feet wet -- a lot of this will probably be a reminder!    

- [Survival on the Titanic](https://github.com/jgscott/learnR/blob/master/titanic/titanic.md): summarizing variation in categorical variables  
- [City temperatures](https://github.com/jgscott/learnR/blob/master/citytemps/citytemps.md): measuring and visualizing dispersion in one numerical variable.  
- [Test scores and GPA for UT grads](https://github.com/jgscott/learnR/blob/master/sat/sat.md): association between numerical and categorical variables.  


<!-- Some examples of great data visualizations from the New York Times:  
- ["Thousands cried for help as Houston flooded"](https://www.nytimes.com/interactive/2017/08/30/us/houston-flood-rescue-cries-for-help.html)  
- [College attendance and income inequality](https://www.nytimes.com/interactive/2017/01/18/upshot/some-colleges-have-more-students-from-the-top-1-percent-than-the-bottom-60.html)  
- [Opioid overdose deaths in America](https://www.nytimes.com/interactive/2017/06/05/upshot/opioid-epidemic-drug-overdose-deaths-are-rising-faster-than-ever.html)  
- [Who likes which musical artists](https://www.nytimes.com/interactive/2017/08/07/upshot/music-fandom-maps.html)  
- [LeBron James and the playoff scoring record](https://www.nytimes.com/interactive/2017/05/25/sports/basketball/lebron-career-playoff-points-record.html)  
  -->

