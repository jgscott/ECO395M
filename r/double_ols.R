library(tidyverse)
library(moderndive)

N = 100

# two correlated predictors
x1 = rnorm(N, 0, 1)
x2 = x1 + rnorm(N, 0, 1)

eps = rnorm(N, 0, 0.2)

# true (structural) causal model
y = x1 + x2 + eps

# wrong causal effect: confounded by x2
lm(y ~ x1) %>% get_regression_table()

# right causal effect
lm(y ~ x1 + x2) %>% get_regression_table()

# also the right causal effect!
yr = lm(y ~ x2)$residuals # isolate the part of y unexplained by x2
x1r = lm(x1 ~ x2)$residuals # isolate the part of x1 unexplained by x2

# "double OLS": regress residual on residual
lm(yr ~ x1r) %>% get_regression_table()

