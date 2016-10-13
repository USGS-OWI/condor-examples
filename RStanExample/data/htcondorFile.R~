library(rstan)
source("simulateDataFunctions.R")

# Systme wide parameters
nSims = 100
nChains = 3
nIter = 400
nYears = 10
nEndPoints = 5 # This is hard coded into another function

# HTCondor iteration
n <- as.numeric(commandArgs(trailingOnly = TRUE))
# HTCondor lives in zero-based index world, so we increment by 1
n <-n + 1

## Read in parameters to use for simulation
parameters <- read.csv("./data/parameters.csv")
a <- parameters[ n, "a"]
b <- parameters[ n, "b"]
sigma <- parameters[ n, "sigma"]

## create output storate data.frame
parNames = c("a", "b", "sigma") ## Also used latter
otherCols = c("model", "scenario", "parameters")

outFrame <- data.frame(matrix(NA, nrow = nEndPoints * nSims ,
                              ncol = (length(parNames) + length(otherCols))))
colnames(outFrame) <- c(parNames, otherCols)

## Complile model
modelFit1 <- stan(file = "modelSimple.Stan", data = NULL,
                  iter = 0, chains = 0)

lowSaveIndex = seq(1, (nSims * nEndPoints), by = nEndPoints)
highSaveIndex = seq(nEndPoints, (nSims * nEndPoints), by = nEndPoints)

## Generate paramter values
X <- rep(1:nYears, each = 3)
Y <- matrix(data = 0, ncol = nSims, nrow = length(X))
for(sim in 1:nSims){
    Y[ , sim] <- rnorm(n = length(X), a + b * X, sigma)
}

for(simLoop in 1:nSims){  
    scenario <- paste0("a", a, "_b", b, "_sigma", sigma)
    
    dataInput <- list(X = X, Y = Y[ , simLoop], nObs = length(Y[ , simLoop]))

    stanOut <- stan(fit = modelFit1, data = dataInput,
                    iter = nIter, chains = nChains)

    stanData <- extract(stanOut)

    outFrame[lowSaveIndex[simLoop]:highSaveIndex[simLoop], ] <-
        getOutputSummary(stanData, model = "model1",
                         scenarioSaveName = scenario,
                         parSave = parNames)

    write.csv(x = outFrame, file =
    		paste0("./scenarioSummary.csv"), row.names = FALSE)
}

