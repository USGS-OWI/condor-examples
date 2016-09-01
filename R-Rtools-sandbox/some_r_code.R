
cat('hello world!\n\n')

#lets make sure we can install R packages that require building from source
install.packages('Rcpp', type='source', repos='http://cran.rstudio.com')

library(Rcpp)

ls('package:Rcpp')