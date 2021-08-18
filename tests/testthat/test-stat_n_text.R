test_that("stat_n_text works as expected", {
  p <- ggplot(mtcars, aes(x = factor(cyl), y = mpg, color = factor(cyl))) +
    geom_point() +
    labs(x = "Number of Cylinders", y = "Miles per Gallon")
  result <- expect_silent(
    p + stat_n_text()
  )
  expect_is(result, "ggplot")
})
