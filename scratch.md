

### Data visualization

Contingency tables and bar plots; basic plots for numerical data (scatterplot, boxplot, histogram, line graphs); lattice plots.  

Some (optional) software walkthroughs: 
- [Survival on the Titanic](https://github.com/jgscott/learnR/blob/master/titanic/titanic.md): summarizing variation in categorical variables  
- [City temperatures](https://github.com/jgscott/learnR/blob/master/citytemps/citytemps.md): measuring and visualizing dispersion in one numerical variable.  
- [Test scores and GPA for UT grads](https://github.com/jgscott/learnR/blob/master/sat/sat.md): association between numerical and categorical variables.  

Readings:  
- [excerpts](notes/DataScience.pdf) from my course notes on data science.  We'll look at some example graphics in Chapter 1.  
- Another interesting (if aesthetically dated) reference is the NIST Handbook, Chapter 1.  
- [Bad graphics ](notes/badgraphics.pdf)  
- Good graphics: scan through some of the New York Times' best [data visualizations](https://www.nytimes.com/interactive/2017/12/21/us/2017-year-in-graphics.html).  Lots of good stuff here but for our purposes, the best things to look at are those in the "Data Visualizations" section, about 60% of the way down the page.  Control-F for "Data Visualization" and you'll find it.  Here are three examples:  
1) [Low-income students in college](https://www.nytimes.com/interactive/2017/01/18/upshot/some-colleges-have-more-students-from-the-top-1-percent-than-the-bottom-60.html)  
2) [The French presidential election](https://www.nytimes.com/interactive/2017/04/23/world/europe/french-election-results-maps.html)  
3) [LeBron James's playoff scoring record](https://www.nytimes.com/interactive/2017/05/25/sports/basketball/lebron-career-playoff-points-record.html)  




### Statistical learning: an introduction 
- Regression vs. K-nearest neighbors
- Cross validation 


### Linear models
 


### Regularization and feature selection


### Classification



### Trees and ensembles




### Clustering

Basics of clustering; K-means clustering; hierarchical clustering.

Scripts and data:  
- [protein.R](R/protein.R) and [protein.csv](data/protein.csv) 
- [cars.R](R/cars.R) and [cars.csv](data/cars.csv) 
- [we8there.R](R/we8there.R)  
- [hclust_examples.R](R/hclust_examples.R)   

Readings:  
- ISL Section 10.1 and 10.3 or Elements Chapter 14.3 (more advanced)    
- [K means examples](notes/kmeans_examples.pdf): a few stylized examples to build your intuition for how k-means behaves.  
- [Hierarchical clustering notes](notes/hierarchical_clustering.pdf): some slides on hierarchical clustering.  
- K-means++ [original paper](http://ilpubs.stanford.edu:8090/778/1/2006-13.pdf) or [simple explanation on Wikipedia](https://en.wikipedia.org/wiki/K-means%2B%2B).  This is a better recipe for initializing cluster centers in k-means than the more typical random initialization.


### Latent-feature models

Principal component analysis (PCA).   Using PCA for dimensionality reduction in regression.  

Scripts and data:  
- [pca_intro.R](R/pca_intro.R)  
- [congress109.R](R/congress109.R), [congress109.csv](data/congress109.csv), and [congress109members.csv](data/congress109members.csv)  
- [FXmonthly.R](R/FXmonthly.R), [FXmonthly.csv](data/FXmonthly.csv), and [currency_codes.txt](data/currency_codes.txt)  

If time:  
- [gasoline.R](R/gasoline.R) and [gasoline.csv](data/gasoline.csv)  



Readings:  
- ISL Section 10.2 

Supplemental readings (optional and more advanced):  
- Elements Chapter 14.5   
- Shalizi Chapters 18 and 19.  In particular, Chapter 19 has a lot more advanced material on factor models, beyond what we covered in class.      


### Networks and Association Rules  

Networks and association rule mining.  

Scripts and data: 
- [medici.R](R/medici.R) and [medici.txt](data/medici.txt)  
- [playlists.R](R/playlists.R) and [playlists.csv](data/playlists.csv)  

Readings: 
- [Intro slides on networks](notes/networks_intro.pdf)  
- [Notes on association rule mining](notes/association_rules.pdf)    
- [In-depth explanation of the Apriori algorithm](http://www.rsrikant.com/papers/vldb94_rj.pdf)  

Miscellaneous:  
- [Gephi](https://gephi.org/), a great piece of software for exploring graphs  
- [The Gephi quick-start tutorial](https://gephi.org/tutorials/gephi-tutorial-quick_start.pdf)  
- a little Python utility for [scraping Spotify playlists](https://github.com/nithinphilips/spotifyscrape)  




### Monte Carlo simulation

Using the bootstrap to approximate value at risk (VaR). 

Scripts:  
- [R walkthrough on Monte Carlo simulation](https://github.com/jgscott/learnR/blob/master/montecarlo/montecarlo_intro.md)  
- [portfolio.R](R/portfolio.R)  

Readings:  
- [Section 2 of these notes](notes/decisions_supplement.pdf), on bootstrap resampling.  You can ignore the stuff about utility if you want.  
- Any basic explanation of the concept of value at risk (VaR) for a financial portfolio, e.g. [here](https://en.wikipedia.org/wiki/Value_at_risk), [here](http://www.investopedia.com/articles/04/092904.asp), or [here](http://people.stern.nyu.edu/adamodar/pdfiles/papers/VAR.pdf).




### Text data

Co-occurrence statistics; naive Bayes; TF-IDF; topic models; vector-space models of text (if time allows).

Scripts and data:  
<!-- - [textutils.R](R/textutils.R) 
- [nyt_stories.R](R/nyt_stories.R) and [selections from the New York Times](https://github.com/jgscott/STA380/tree/master/data/nyt_corpus). -->
- [tm_examples.R](R/tm_examples.R) and [selections from the Reuters newswire](https://github.com/jgscott/STA380/tree/master/data/ReutersC50).
- [congress109_classify.R](R/congress109_classify.R)  
- [art_examples.R](R/art_examples.R)

Readings: 
- [Intro slides on text](notes/text_intro.pdf)  
- [Stanford NLP notes](http://nlp.stanford.edu/IR-book/html/htmledition/scoring-term-weighting-and-the-vector-space-model-1.html) on vector-space models of text, TF-IDF weighting, and so forth.  
- [Great blog post about word vectors](https://blog.acolyer.org/2016/04/21/the-amazing-power-of-word-vectors/).  
- [Using the tm package](http://cran.r-project.org/web/packages/tm/vignettes/tm.pdf) for text mining in R.  
- [Dave Blei's survey of topic models](https://www.cs.princeton.edu/~blei/papers/Blei2012.pdf).  
- [A pretty long blog post on naive-Bayes classification](https://www.bionicspirit.com/blog/2012/02/09/howto-build-naive-bayes-classifier.html).  


### Further topics  

Causal inference meets statistical learning.

Neural networks.  
