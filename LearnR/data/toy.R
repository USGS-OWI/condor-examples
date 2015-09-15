# Print node name
print("currently using computer name")
print(Sys.info())


# pull the index off of the command line for which file to run
n <- as.numeric(commandArgs(trailingOnly = TRUE))
# HTCondor lives in zero-based index world, so we increment by 1
n <-n+1

print (paste0("Hi there, I am running process ",n,""))

output = data.frame(x = n, y = rnorm(10, n, 1), n = n)

## Save output as a csv file 
write.csv(x = output, file = "out.csv")
