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

test_that("table themes can be used and work", {
  tb <- get_tb()
  df <- tibble(x = 5.45, y = 34, tb = list(tb))
  p <- ggplot(mtcars, aes(wt, mpg, colour = factor(cyl))) +
    geom_point() +
    geom_table(data = df, aes(x = x, y = y, label = tb))

  ttheme_set(ttheme_gtbw)
  expect_silent(show(p))

  ttheme_set(ttheme_gtdark)
  expect_silent(show(p))

  ttheme_set(ttheme_gtdefault)
  expect_silent(show(p))

  ttheme_set(ttheme_gtlight)
  expect_silent(show(p))

  ttheme_set(ttheme_gtminimal)
  expect_silent(show(p))

  ttheme_set(ttheme_gtplain)
  expect_silent(show(p))

  ttheme_set(ttheme_gtsimple)
  expect_silent(show(p))

  ttheme_set(ttheme_gtstripes)
  expect_silent(show(p))
})
