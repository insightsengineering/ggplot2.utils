# h_stat_km ----

test_that("h_stat_km works as expected", {
  result <- expect_silent(h_stat_km(surv_df))
  expect_list(result)
  expect_s3_class(result$surv_fit, "survfit")
  expect_numeric(result$x)
  expect_numeric(result$y)
  expect_identical(result$x, c(0, sort(unique(surv_df$time))))
  expect_identical(result$y[1], 1)
  expect_snapshot_value(result$y)
})

test_that("h_stat_km also works when there is only a single observation", {
  df <- data.frame(
    time = 1,
    status = 0
  )
  result <- expect_silent(h_stat_km(df))
  expect_identical(result$x, c(0, 1))
  expect_identical(result$y, c(1, 1))
})

# h_step ----

test_that("h_step returns NULL as expected when no finite values exist", {
  result <- expect_silent(h_step(Inf, Inf))
  expected <- NULL
  expect_identical(result, expected)
})

test_that("h_step works as expected for length 1", {
  x <- 3
  y <- 4
  result <- expect_silent(h_step(x, y))
  expected <- list(x = x, y = 4)
  expect_identical(result, expected)
})

test_that("h_step works as expected for length 2", {
  x <- c(3, 5)
  y <- c(4, 7)
  result <- expect_silent(h_step(x, y))
  expected <- list(x = c(3, 5, 5), y = c(4, 4, 7))
  expect_identical(result, expected)
})

test_that("h_step works as expected for longer vectors with plateaus", {
  x <- 1:10
  y <- c(0.2, 0.3, 0.4, 0.5, 0.5, 0.6, 0.6, 0.8, 0.8, 1)
  result <- expect_silent(h_step(x, y))
  expected <- list(
    x = as.integer(c(1, 2, 2, 3, 3, 4, 4, 6, 6, 8, 8, 10, 10)),
    y = c(0.2, 0.2, 0.3, 0.3, 0.4, 0.4, 0.5, 0.5, 0.6, 0.6, 0.8, 0.8, 1)
  )
  expect_identical(result, expected)
})

test_that("h_step works discards NA and Inf as expected", {
  x <- 1:12
  y <- c(0.5, 0.6, NA, 0.6, 0.6, 0.7, 0.7, 0.8, Inf, 0.9, 1, 1)
  result <- expect_silent(h_step(x, y))
  expected <- list(
    x = as.integer(c(1, 2, 2, 6, 6, 8, 8, 10, 10, 11, 11, 12)),
    y = c(0.5, 0.5, 0.6, 0.6, 0.7, 0.7, 0.8, 0.8, 0.9, 0.9, 1, 1)
  )
  expect_identical(result, expected)
})

