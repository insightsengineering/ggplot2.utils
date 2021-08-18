library(dplyr)
library(tibble)

get_tb <- function() {
  mtcars %>%
    group_by(cyl) %>%
    summarize(wt = mean(wt), mpg = mean(mpg)) %>%
    ungroup() %>%
    mutate(
      wt = sprintf("%.2f", wt),
      mpg = sprintf("%.1f", mpg)
    )
}

test_that("ttheme_set works as expected but is not baked into objects", {
  tb <- get_tb()
  df <- tibble(x = 5.45, y = 34, tb = list(tb))
  ttheme_set()
  p1 <- ggplot(mtcars, aes(wt, mpg, colour = factor(cyl))) +
    geom_point() +
    geom_table(data = df, aes(x = x, y = y, label = tb))
  ttheme_set(ttheme_gtbw)
  p2 <- ggplot(mtcars, aes(wt, mpg, colour = factor(cyl))) +
    geom_point() +
    geom_table(data = df, aes(x = x, y = y, label = tb))
  expect_equal(p1, p2)
})
