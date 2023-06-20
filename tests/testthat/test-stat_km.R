test_that("stat_km works as expected", {
  p <- ggplot(surv_df, aes(time = time, status = status))
  result <- expect_silent(
    p + stat_km()
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
