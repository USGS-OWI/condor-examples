library(ggplot2)
library(data.table)
outPath = "./outputs/"

allFiles <- paste0(outPath, list.files(outPath))

allData <- do.call("rbind", lapply(allFiles, fread, header= TRUE))

allData[ , aKnown :=
        as.factor(gsub( "a(\\d+)_b(\\d+)_sigma(0.\\d+)",
                        "\\1", scenario, perl = TRUE))]

allData[ , bKnown :=
        as.factor(gsub( "a(\\d+)_b(\\d+)_sigma(0.\\d+)",
                        "\\2", scenario, perl = TRUE))]

allData[ , sigmaKnown :=
        as.factor(gsub( "a(\\d+)_b(\\d+)_sigma(0.\\d+)",
                        "\\3", scenario, perl = TRUE))]
allData
meansOut <- copy(allData[parameters == "mean", ])
mediansOut <- copy(allData[parameters == "medians", ])
includeZeroOut <- copy(allData[parameters == "includeZero", ])
includeParOut <- copy(allData[parameters == "includePar", ])
outRange <- copy(allData[parameters == "outRange", ])


meanExample <- ggplot(meansOut, aes(x = aKnown, y = a, color = bKnown)) + 
    geom_boxplot()  +
    facet_grid( ~ sigmaKnown) +
    scale_color_manual(values = c("red", "blue", "black")) +
    theme_bw() +
    ylab("mead a value")


ggplot(mediansOut, aes(x = aKnown, y = a, color = bKnown)) +
    geom_boxplot()  +
    facet_grid( ~ sigmaKnown) +
    scale_color_manual(values = c("red", "blue", "black")) +
    theme_bw() +
    ylab("median a value")


    
ggplot(includeZeroOut, aes(x = aKnown, y = a, color = bKnown)) + 
    stat_summary(fun.data = "mean_cl_boot",
                 position = position_dodge(width = 0.5) )+
    facet_grid( ~ sigmaKnown) +
    scale_color_manual(values = c("red", "blue", "black")) +
    theme_bw() +
    ylab("Does the 90% CrI include the zero")



ggplot(includeParOut, aes(x = aKnown, y = a, color = bKnown)) + 
    stat_summary(fun.data = "mean_cl_boot",
                 position = position_dodge(width = 0.5)) +
    facet_grid( ~ sigmaKnown) +
    scale_color_manual(values = c("red", "blue", "black")) +
    theme_bw() +
    ylab("Does the 90% CrI include the true a?")


ggplot(outRange, aes(x = aKnown, y = a, color = bKnown)) + 
    stat_summary(fun.data = "mean_cl_boot",
                 position = position_dodge(width = 0.5)) +
    facet_grid( ~ sigmaKnown) +
    scale_color_manual(values = c("red", "blue", "black")) +
    theme_bw() +
    ylab("What is the range of the coverage?")







## ggplot(data = scn1Means, aes(x = model, y = tau, color = scenario)) +
##     geom_boxplot(fill = NA) + 
##     geom_point() +
##     scale_color_manual(values = c("blue", "black", "red", "navyblue", "skyblue")) +
##     geom_hline(yintercept = tau) +
##     stat_summary(fun.data = "mean_cl_boot", colour = "red", size = 1.5) +
##     ylab(expression("mean  " * tau))

## ggplot(data = scn1Medians, aes(x = model, y = tau, color = scenario)) +
##     geom_boxplot(fill = NA) + 
##     geom_point() +
##     scale_color_manual(values = c("blue", "black", "red", "navyblue", "skyblue")) +
##     geom_hline(yintercept = tau) +
##     stat_summary(fun.data = "mean_cl_boot", colour = "red", size = 1.5) +
##     ylab(expression("median  " * tau))
    

## ggplot(data = scn1OutRange, aes(x = model, y = tau, color = scenario)) +
##     geom_boxplot(fill = NA) + 
##     geom_point() +
##     scale_color_manual(values = c("blue", "black", "red", "navyblue", "skyblue")) +
##     stat_summary(fun.data = "mean_cl_boot", colour = "red", size = 1.5) +
##     ylab(expression("90% interval length for  " * tau))
    
## ggplot(data = scn1includePar, aes(x = model, y = tau, color = scenario)) +
##     stat_summary(fun.data = "mean_cl_boot") +
##     geom_hline(yintercept = 0.9) +
##     ## geom_point() +
##     scale_color_manual(values = c("blue", "black", "red", "navyblue", "skyblue")) + 
##     ylab(expression("proption of estimates containing  " * tau  *" in 90% CrI"))


## ggplot(data = scn1includeZero, aes(x = model , y = tau, color = scenario)) +
##     
##     scale_color_manual(values = c("blue", "black", "red", "navyblue", "skyblue")) + 
##     ylab(expression("proption of ranges for  " * tau  *" containing 0 in the 90% CrI"))

## ######## Other parameters
## ggplot(data = scn1Means, aes(x = model, y = alpha, color = scenario)) + geom_point() +
##     geom_boxplot(fill = NA) + 
##     geom_point() +
##     scale_color_manual(values = c("blue", "black", "red", "navyblue", "skyblue")) +
##     stat_summary(fun.data = "mean_cl_boot", colour = "red", size = 1.5) +
##     geom_hline(yintercept = alpha)

## ggplot(data = scn1Means, aes(x = model, y = gammaPar, color = scenario)) + geom_point() +
##     geom_boxplot(fill = NA) + 
##     geom_point() +
##     scale_color_manual(values = c("blue", "black", "red", "navyblue", "skyblue")) +
##     stat_summary(fun.data = "mean_cl_boot", colour = "red", size = 1.5) +
##     geom_hline(yintercept = gammaPar)

## ggplot(data = scn1Means, aes(x = model, y = sigmaEta, color = scenario)) + geom_point() +
##     geom_boxplot(fill = NA) + 
##     geom_point() +
##     scale_color_manual(values = c("blue", "black", "red", "navyblue", "skyblue")) +
##     stat_summary(fun.data = "mean_cl_boot", colour = "red", size = 1.5) +
##     geom_hline(yintercept = sigmaEta)
## x11()
## ggplot(data = scn1Means, aes(x = model, y = sigmaXi, color = scenario)) + geom_point() +
##     geom_boxplot(fill = NA) + 
##     geom_point() +
##     scale_color_manual(values = c("blue", "black", "red", "navyblue", "skyblue")) +
##     stat_summary(fun.data = "mean_cl_boot", colour = "red", size = 1.5) +
##     geom_hline(yintercept = sigmaXi)
