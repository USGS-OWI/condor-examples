a = c(0, 1, 2)
b = c(0, 1, 3)
sigma = c(0.05, 0.1, 0.2)

lenA <- length(a)
lenB <- length(b)
lenS <- length(sigma)

parameters <- expand.grid(a = a, b = b, sigma = sigma)

write.csv(x = parameters, file = "parameters.csv", row.names = FALSE)
