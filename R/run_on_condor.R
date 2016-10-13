# run one WiLMA lake based on command line input

#Setup libraries
dir.create('rLibs')

install.packages('sbtools', repos='file:packages', lib='rLibs')

args <- commandArgs(trailingOnly = TRUE)

cat(args, '\n')

lake_indx = as.numeric(args[1])+1


library(sbtools)


# do something

#write a file or something

