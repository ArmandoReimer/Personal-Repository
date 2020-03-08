This code is a simple  implementation of (not speed optimized) 
of AEFA, DEFA and EMAR methods proposed in [1]. 


The goal is to represent a given 2D shape with an automatically determined
number of ellipses, so that the total area covered by the ellipses is equal to the
area of the original shape without any assumption or prior knowledge about the
object structure. To solve this interesting theoretical problem, first we employ the
skeleton of the 2D shape which provides important information on the parameters
of the ellipses that could approximate the original shape. For a given number of
such ellipses, the hard Expectation-Maximization (EM) algorithm is employed to
maximise the shape coverage under the equal area constraint. Different models
(i.e., solutions involving different numbers of ellipses) are evaluated based on the
Akaike Information Criterion (AIC). This considers a novel, entropy-based shape
complexity measure that balances the model complexity and the model approxi-
mation error. In order to minimise the AIC criterion, two variants are proposed
and evaluated: (a) the augmentative method (AEFA) that gradually increases the number
of considered ellipses starting from a single one  and, (b) the decremental method (DEFA) 
that decreases the number of ellipses starting from a large, automatically defined
set. The obtained quantitative results on more than 4,000 2D shapes included in
standard as well as in custom datasets, quantify the performance of the proposed
methods and illustrate that their solutions agree with human intuition.


Files: 
   runBestEllipseFitting.m: implementation of the methods

The .gif files can be used to test the methods.

You can find more details and data in https://sites.google.com/site/costaspanagiotakis/research/EFA 
and www.csd.uoc.gr/~cpanag and http://users.ics.forth.gr/~argyros/
  

We will appreciate if you cite our paper [1] in your work: 

[1] C. Panagiotakis and A. Argyros, Parameter-free Modelling of 2D Shapes with Ellipses, Pattern Recognition, 2015.  

