data {
  int<lower = 1> nObs;
  vector[nObs] X;
  vector[nObs] Y;
}
parameters {
  real a;
  real b;
  real<lower = 0> sigma;
}
model {
  a ~ normal( 0, 5);
  b ~ normal( 0, 5);
  sigma ~ cauchy(0, 5);
  
  Y ~ normal( a + b * X , sigma);
}
