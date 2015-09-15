invLogit <- Vectorize(function(x){exp(x)/(1 + exp(x))})

readInData <- function(
    parName = "Means",
    allfiles = allFiles){
    
    parFiles <- allFiles[grep(parName, allFiles)]
    cFiles <- fread(paste0(outPath, parFiles[1]))
    pars <- strsplit(cFiles[, unique(scenario)], "_")[[1]]
    for(file in 2:length(parFiles)){
        cFiles <- rbind(cFiles,
                        fread(paste0(outPath, parFiles[file])))
    }


    pars <- strsplit(cFiles[, unique(scenario)], "_")[[1]]
    for(i in 1:length(pars)){
        colName = gsub("-", "", gsub("\\.", "",
            gsub( "[\\d]", "", pars[i], perl = TRUE)))
        cFiles[, (colName) := strsplit(scenario, "_")[[1]][i]]
    }

    lapply(cFiles[, scenario], strsplit, split = "_")
    strsplit(cFiles[, scenario], "_")[[1]]
    colValue
            colName = gsub("-", "", gsub("\\.", "",
                gsub( "[\\d]", "", pars[i], perl = TRUE)))

    cFiles[ , eval(as.symbol(colName))]
    cFiles[1 , ]
     gsub( "[a-z]", "", pars[i])
    colValue = gsub( colName, "", pars[i])
    
    cFiles[, scenario]

    
    return(cFiles)
}
dataExtractor <- function(scnOut, scenarioSaveName,
                          alpha,
                          gammaPar,
                          tau,
                          sigamEta,
                          sigamXi,
                          nu,
                          nYears,
                          n_reps
                          ){
    parSave1 = c(
        "alpha", "gammaPar",
        "rho", "tau", "nu",
        "sigmaEta", "sigmaXi",
        "sigmaEta")
    
    parSave2 = c(
        "alpha", "gammaPar",
        "rho", "tau", 
        "sigmaEta", "sigmaXi",
        "sigmaEta")
    
    parSave3 = c(
        "alpha", "gammaPar",
        "tau", 
        "sigmaEta", "sigmaXi",
        "sigmaEta")
    
    ## Means
    summary1 <- data.table(
        summarizeParData(x = scnOut, n_reps = n_reps,
                         parSave = parSave1, modelName = "fullMod",
                         scenarioSaveName  = scenarioSaveName, modelNo = 1))

    summary2 <- data.table(
        summarizeParData(x = scnOut,
                         n_reps = n_reps,
                         parSave = parSave2,
                         modelName = "NoNu",
                         scenarioSaveName  = scenarioSaveName , modelNo = 2))

    summary3 <- data.table(
        summarizeParData(x = scnOut,
                         n_reps = n_reps,
                         parSave = parSave3,
                         modelName = "NoNuNoRho",
                         scenarioSaveName  = scenarioSaveName , modelNo = 3))
    
    scnMeans <- allOutputs(parameter = "mean", summary1,
                           summary2, summary3)
    scnOutRange <- allOutputs(parameter = "outRange", summary1,
                              summary2, summary3)    
    scnMedians <- allOutputs(parameter = "medians", summary1,
                             summary2, summary3)    
    scnincludePar <- allOutputs(parameter = "includePar", summary1,
                                summary2, summary3)
    scnincludeZero <- allOutputs(parameter = "includeZero", summary1,
                                 summary2, summary3)    

    ## Create output directory if needed and save outputs
    outPath = "./simulatedResults/"
    dir.create(path = outPath, showWarning = FALSE)
    
    write.csv(scnMeans, paste0(outPath,
                                scenarioSaveName , "Means.csv"),
              row.names = FALSE)
    write.csv(scnOutRange, paste0(outPath,
                                   scenarioSaveName , "OutRange.csv"),
              row.names = FALSE)
    write.csv(scnMedians, paste0(outPath,
                                  scenarioSaveName , "Medians.csv"),
              row.names = FALSE)
    write.csv(scnincludePar, paste0(outPath,
                                     scenarioSaveName , "includePar.csv"),
              row.names = FALSE)
    write.csv(scnincludeZero, paste0(outPath,
                                      scenarioSaveName , "includeZero.csv"),
              row.names = FALSE)
    print(paste0("done with extracting scenario:    ", scenarioSaveName ))
    print(" ")
    ## return(list(
    ##     scnMeans = allOutputs(parameter = "mean", summary1,
    ##         summary2, summary3),
    ##     scnOutRange = allOutputs(parameter = "outRange", summary1,
    ##         summary2, summary3),
    ##     scnMedians = allOutputs(parameter = "medians", summary1,
    ##         summary2, summary3),
    ##     scnincludePar =allOutputs(parameter = "includePar", summary1,
    ##         summary2, summary3),
    ##     scnincludeZero =allOutputs(parameter = "includeZero", summary1,
    ##         summary2, summary3)    
    ##     ))
}



retMedian <- function(x){return(x[names(x) == "50%"])}

findZero <- function(x){return(findInterval(0, c(x[1], x[3])) == 1)}

findPar  <- function(x){
    x2 = matrix(unlist(x), ncol = 3, byrow = TRUE)[, -2]
    y2 = unlist(
        lapply(
            lapply(names( x ),
                   parse, file = NULL, n = NULL), eval)
        )
    
    return(
        x2[,1] <= y2 & x2[,2] >= y2
        )
}

findRange  <- function(x, parSummary){
    x2 = matrix(unlist(x), ncol = 3, byrow = TRUE)[, -2]
    y2 = unlist(lapply(lapply(names( x),
        parse, file = NULL, n = NULL), eval))
    
    return(
        x2[,2] - x2[,1]
        )
}

getOutputSummary <- function(out, model, scenarioSaveName , parSave){
    parSummary <-
        lapply(out[names(out) %in% parSave], quantile, c(0.05, 0.5, 0.95))
    medians <- unlist(lapply(parSummary, retMedian))
    mean <- unlist(lapply(out[names(out) %in% parSave], mean))
    includeZero <- unlist(lapply(parSummary, findZero))
    includePar <- findPar(parSummary)
    outRange <- findRange(parSummary)
    
    output <- as.data.frame(rbind(
        medians,
        mean,
        includeZero,
        includePar,
        outRange
        ))
    output$model = model
    output$scenario <- scenarioSaveName
    output$parameters <- rownames(output)
    return(output)
}

runSim <- function(
    nSites = nSites,
    nYears = nYears,
    nSurveys = nSurveys,
    alpha =   alpha,
    gammaPar = gammaPar,
    tau = tau,
    sigmaXi = sigmaXi,
    sigmaEta = sigmaEta,
    rho = rho,
    nu = nu,
    scenario = "sim",
    modelFit1 = modelFit1,
    modelFit2 = modelFit2,
    modelFit3 = modelFit3,
    nIter = nIter,
    n_chains = n_chains
    ){
    library(rstan)
    ## source("simulateDataFunctions.R")
    
    simData <- simulateOcc(nSites = nSites,
                           nYears = nYears,
                           nSurveys = nSurveys,
                           alpha =  alpha,
                           gamma =  gammaPar,
                           tau = tau,
                           sigmaXi = sigmaXi,
                           sigmaEta = sigmaEta,
                           rho = rho,
                           nu = nu)
        
    nObs <- length(simData$Y)
    dummyYear <- rep(1:nYears, each = nSites)
    yearLessOne = 0:(nYears - 1)

    dataModel <- list(Y = simData$Y,
                      nObs = nObs,
                      nSites = nSites,
                      nSurveys = nSurveys,
                      nYears = nYears,
                      yearLessOne = yearLessOne,
                      dummyYear = dummyYear)

    seed = sample.int(.Machine$integer.max, 1)
    outRaw1 <- stan(fit = modelFit1, data = dataModel,
                   iter = nIter, chains = n_chains,
                    seed = seed)   

    out1 <- extract(outRaw1)
    seed = sample.int(.Machine$integer.max, 1)
    outRaw2 <- stan(fit = modelFit2, data = dataModel,
                    iter = nIter, chains = n_chains,
                    seed = seed)
    out2 <- extract(outRaw2)

    seed = sample.int(.Machine$integer.max, 1)
    outRaw3 <- stan(fit = modelFit3, data = dataModel,
                   iter = nIter, chains = n_chains,
                    seed = seed)
    out3 <- extract(outRaw3)

    return(list(out1 = out1, out2 = out2, out3 = out3))

}


ggMyPlot <- function(data = allParsMeans, parameter = "tau"){
    library(ggplot2)
    ggOut <-
        ggplot(data = allParsMeans, aes_string(x = 'model',
                        color = 'scenario', y = parameter)) +
             geom_hline(yintercept = parameter) + 
             geom_point() +
             scale_color_manual(
                 values = c("blue",
                     "red", "black",
                     "seagreen", "orange",
                     "navyblue")) +
             theme_bw() +
             stat_summary(fun.data = "mean_cl_boot", colour = "red")
    return(ggOut)
    }

allOutputs <- function(parameterIn, summary1, summary2, summary3){
    allParsMeans <- data.table(
        rbind(
            data.frame(summary1[parameter == parameterIn,
                       list(alpha, gammaPar, tau, sigmaEta,
                            sigmaXi, model, scenario)]),
            data.frame(summary2[parameter == parameterIn,
                                list(alpha, gammaPar, tau, sigmaEta,
                                     sigmaXi, model, scenario)]),
            data.frame(summary3[parameter == parameterIn,
                                list(alpha, gammaPar, tau, sigmaEta,
                                     sigmaXi, model, scenario)])
            )
        )
    
    return(
        allParsMeans
           )
}


summarizeParData <- function(x, n_reps, parSave,
                             modelName, scenarioSaveName,
                             modelNo){
    out <-
        getOutputSummary(out = x[[1]][[modelNo]], model = modelName,
                         scenarioSaveName  = scenarioSaveName,
                         parSave = parSave)
    for(index in 2:n_reps){
        out <-
            rbind(out,
                  getOutputSummary(out = x[[ index ]][[modelNo]],
                                   model = modelName,
                                   scenarioSaveName  = scenarioSaveName ,
                                   parSave = parSave)
                  )
    }
    out$parameter <- gsub("\\d+", "", rownames(out))
    setnames(out,
             gsub( ".50%*", "",
                  colnames(out)))
    
    return(out)
}
    
simulateOcc <- function(
    nSites = 100,
    nYears = 15,
    nSurveys = 5,
    alpha =  - 1.5,
    gamma =  -1.1,
    tau = 0.05,
    sigmaXi = 0.2,
    sigmaEta = 0.2,
    rho = 0.2,
    nu = 0.8){
    
    yearOneLess = 0:(nYears- 1)
    eta <- rnorm(nYears, 0, sigmaEta)
    epsilon <- numeric(nYears)
    epsilon[1] <-  eta[1]
    for(year in 2:nYears){
        epsilon[year] <- rho * epsilon[year - 1] + eta[year]
    }
    xi <- rnorm(nYears, 0, sigmaXi)
    Psi <- invLogit(alpha + tau * yearOneLess + epsilon)
    meanPsi <- Psi - mean(Psi)
    P   <- invLogit(gamma + nu * meanPsi + xi)
    Z <- rbinom(n = nSites * nYears, 1, prob = rep(Psi, each = nSites))
    Y <- numeric(nSites * nYears)
    Y[Z > 0] <- rbinom(n = Z[Z > 0], size = nSurveys, prob = rep(P, each = nSites))
return(list(P = P, Psi = Psi, Y = Y, Z = Z))
}


## library("RcppArmadillo")
## library("Rcpp")
## library("inline")

## srcCode <- '
##    int nYearsX      = Rcpp::as<int>(nYears);
##    int nSitesX      = Rcpp::as<int>(nSites);
##    int nSurveysX    = Rcpp::as<int>(nSurveys);
##    double alphaX    = Rcpp::as<double>(alpha);
##    double gammaX    = Rcpp::as<double>(gamma);
##    double tauX      = Rcpp::as<double>(tau);
##    double sigmaEtaX = Rcpp::as<double>(sigmaEta);
##    double sigmaXiX  = Rcpp::as<double>(sigmaXi);
##    double rhoX      = Rcpp::as<double>(rho);
##    double nuX       = Rcpp::as<double>(nu);
## //
##    IntegerVector yearLessOne = seq_len( nYearsX ) - 1;
##    vector<int> yearLessOneX = Rcpp::as<int>(yearLessOne);
##    NumericVector eta = Rcpp::rnorm( nYearsX, 0.0, sigmaEtaX );
##    NumericVector xi  = Rcpp::rnorm( nYearsX, 0.0, sigmaXiX );
##    NumericVector epsilon = xi;
## //
##    epsilon(0) = eta(0);
##    for(int year = 1; year < nYearsX; year++) {
##       epsilon( year ) =  rhoX * epsilon( year - 1 ) + eta( year);
##    }
## //
##    NumericVector muPsi = epsilon;
##    for(int year = 0; year < nYearsX; year++) {
##       muPsi( year ) =  alpha  + epsilon(year);
##    }
## //
## //
## //   NumericVector Psi = exp( muPsi )/(1 + exp( muPsi ) );
## //
## //
##    return Rcpp::List::create(Rcpp::Named("nYears") = nYearsX,
##                              Rcpp::Named("nObs") = nYearsX * nSitesX,
##                              Rcpp::Named("nSurveys") = nSurveysX,
##                              Rcpp::Named("Psi") = Psi,
##                              Rcpp::Named("yearLessOne") = yearLessOne );
## '
## ## '
## ##    arma::mat P0X = Rcpp::as<arma::mat>(P0);
## ##    arma::mat AX  = Rcpp::as<arma::mat>(A);
## ##    arma::mat PX(AX.n_cols, nYearsX + 1);
## ##    PX.col(0) = P0X;

## ##    for(int t = 0; t < nYearsX; t++) {
## ##    PX.col(t + 1) =  AX * PX.col(t);
## ##    }

## ##    return Rcpp::wrap(PX);
## ## '

## rm(simulateOccRcpp)
## simulateOccRcpp <- cxxfunction(signature(nSites = "integer",
##                                          nYears = "integer",
##                                          nSurveys = "integer",
##                                          alpha =  "numeric",
##                                          gamma = "numeric",
##                                          tau = "numeric",
##                                          sigmaXi = "numeric",
##                                          sigmaEta = "numeric",
##                                          rho = "numeric",
##                                          nu = "numeric"
##                                      ),    
##                                srcCode, plugin = "RcppArmadillo")

## simulateOccRcpp(nSites = nSites,
##                 nSurveys = nSurveys,
##                 nYears = nYears,
##                 alpha = alpha,
##                 gamma = gamma,
##                 tau = tau,
##                 sigmaXi = sigmaXi,
##                 sigmaEta = sigmaEta,
##                 rho = rho,
##                 nu = nu)
