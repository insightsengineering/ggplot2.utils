test_that("loading ggplot2.utils works", {
  test.nest::skip_if_too_deep(depth = 0)

  expect_silent(library(ggplot2.utils))
})
