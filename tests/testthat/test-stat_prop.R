test_that("stat_prop works as expected", {
  df <- as.data.frame(Titanic)
  p <- ggplot(df) +
    aes(x = Class, fill = Survived, weight = Freq, by = Class) +
    geom_bar(position = "fill")
  result <- expect_silent(
    p + geom_text(stat = "prop", position = position_fill(.5))
  )
  expect_is(result, "ggplot")
})
