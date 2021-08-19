test_that("stat_n_text works as expected", {
  test.nest::skip_if_too_deep(depth = 0)

  p <- ggplot(mtcars, aes(x = factor(cyl), y = mpg, color = factor(cyl))) +
    geom_point() +
    labs(x = "Number of Cylinders", y = "Miles per Gallon")
  result <- expect_silent(
    p + stat_n_text()
  )
  expect_is(result, "ggplot")
})
