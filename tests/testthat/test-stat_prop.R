test_that("stat_prop works as expected", {
  test.nest::skip_if_too_deep(depth = 0)

  df <- as.data.frame(Titanic)
  p <- ggplot(df) +
    aes(x = Class, fill = Survived, weight = Freq, by = Class) +
    geom_bar(position = "fill")
  result <- expect_silent(
    p + geom_text(stat = "prop", position = position_fill(.5))
  )
  expect_is(result, "ggplot")
})
