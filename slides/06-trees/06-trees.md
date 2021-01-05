Tree models
========================================================
author: ECO 395M
date: James Scott (UT-Austin)
autosize: false
font-family: 'Gill Sans'
transition: none

<style>
.small-code pre code {
  font-size: 1em;
}
</style>



Reference: Introduction to Statistical Learning Chapter 8


Outline
========================================================
 
1. Trees
2. Trees 
3. Trees



Decision trees
========================================================

<img src="fig/umbrella_tree.png" title="plot of chunk unnamed-chunk-1" alt="plot of chunk unnamed-chunk-1" width="700px" style="display: block; margin: auto;" />

Trees involve simple mini-decisions that combine to make a choice or prediction.  

Each decision is a _node_; the final choice or prediction is a _leaf node._  


Decision trees
========================================================

You can think of a tree as a form of regression model:  
- inputs $x$: forecast, current conditions  
- output $y$: need for an umbrella  

Based on previous data, the  the goal is to specify branches/choices that lead to good predictions in new scenarios.

In other words, you want to estimate a __Tree Model__: instead of linear coefficients, we need to find ‘decision nodes’: binary splitting rules defined by some dimension of x.   


A regression tree  
========================================================

Let's see a simple example on a familiar data set:  
- x = temperature at Houston's Hobby airport in degrees C  
- y = peak power consumption in the ERCOT coast region  

The tree looks as follows:    
- all splits are of the form $x < t$ for some threshold $t$.  
- the terminal leaf nodes are the predicted power consumption.  

A regression tree  
========================================================

<img src="fig/ercot_tree1.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" width="800px" style="display: block; margin: auto;" />

Making a prediction is like pinball: you "drop" a specific x down the tree and see which leaf it lands in.  This gives E(y | x).  

A regression tree  
========================================================

<img src="fig/ercot_tree2.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="1000px" style="display: block; margin: auto;" />

This is the fitted regression function $f(x) = E(y \mid x)$.  


A classification tree  
========================================================

