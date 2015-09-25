# Windows R and Rtools sandbox
This is an example of "bringing along" R and Rtools to a windows machine. 
Includes adjusting the PATH so the necessary components can be found for 
running the R code. 

This can be especially useful when trying to run code that must be 
compiled, but you don't want to install and administer R and Rtools on 
all the windows worker nodes. Plus, this way you can control the R version. 

In the example, the Rcpp package is installed from CRAN. I would not recommend
doing this on a large cluster as your internet connection (and potentially CRAN) will
be quickly overwhelmed with package downloads.
