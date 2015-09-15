# pull the index off of the command line for which file to run
n <- as.numeric(commandArgs(trailingOnly = TRUE))
# HTCondor lives in zero-based index world, so we increment by 1
n <-n+1

print (paste0("Hi there, I am running proccess ",n,""))
tt<-getwd()

output = data.frame(x = n, y = rnorm(100, n, 1), n = n)

## Save output as a csv file 
write.csv(x = output, file = "out.csv")
