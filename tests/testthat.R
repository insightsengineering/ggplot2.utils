pkg_name <- "ggplot2.utils"
if (requireNamespace("testthat", quietly = TRUE)) {
  library(testthat)
  reporter <- MultiReporter$new(list(
    CheckReporter$new()
  ))
  test_results <- test_check(pkg_name, reporter = reporter)
  saveRDS(test_results, "unit_testing_results.rds")
}
