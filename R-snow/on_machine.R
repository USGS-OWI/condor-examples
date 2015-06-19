
library(parallel)

#Start a cluster, wait for them to connect
c1 = makePSOCKcluster(paste0('machine', 1:50), manual=TRUE, port=4043)

clusterCall(c1, function(){install.packages('devtools', repos='http://cran.rstudio.com')})
clusterCall(c1, function(){install.packages('rLakeAnalyzer', repos='http://cran.rstudio.com')})
clusterCall(c1, function(){install.packages('dplyr', repos='http://cran.rstudio.com')})

clusterCall(c1, function(){library(devtools)})

glmr_install     = clusterCall(c1, function(){install_github('lawinslow/GLMr')})

to_run = 1:1000

do_something = function(run_id){
    
    library(dplyr)
    
    ## do something
    
    
    ## return results
    #return(result)
    
}


out = clusterApplyLB(c1, to_run, do_something)