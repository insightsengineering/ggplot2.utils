test_that("geom_km works as expected", {
  p <- ggplot(surv_df, aes(time = time, status = status))
  result <- expect_silent(
    p + geom_km()
  )
  expect_s3_class(result, "ggplot")

  first_layer <- layer_data(result, 1)
  expect_data_frame(first_layer)
  expect_named(
    first_layer,
    c(
      "x", "y", "time", "survival", "PANEL", "group", "colour", "fill",
      "linewidth", "linetype", "weight", "alpha"
    )
  )
})

test_that("geom_km looks as expected for a single group", {
  p <- ggplot(surv_df, aes(time = time, status = status)) +
    geom_km()
  vdiffr::expect_doppelganger("geom_km single group", p)
})

test_that("geom_km looks as expected for two groups", {
  p <- ggplot(surv_df, aes(time = time, status = status, color = factor(group))) +
    geom_km()
  vdiffr::expect_doppelganger("geom_km two groups", p)
})
