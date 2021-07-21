if (requireNamespace("testthat", quietly = TRUE)) {

  library(testthat)

  test_results <- test_package("ggplot2.utils")
  saveRDS(test_results, "unit_testing_results.rds")
}
