set.seed(123)
n_df <- 10
surv_group <- rbinom(n_df, size = 1, prob = 0.5)
surv_df <- data.frame(
  time = round(exp(rnorm(n_df, mean = surv_group)), 1),
  status = rbinom(n_df, size = 1, prob = 0.75),
  group = surv_group
)
