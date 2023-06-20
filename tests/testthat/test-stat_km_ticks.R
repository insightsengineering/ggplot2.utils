test_that("stat_km_ticks works as expected", {
  p <- ggplot(surv_df, aes(time = time, status = status))
  result <- expect_silent(
    p + stat_km_ticks()
  )
  expect_s3_class(result, "ggplot")

  first_layer <- layer_data(result, 1)
  expect_data_frame(first_layer)
  expect_named(
    first_layer,
    c(
      "x", "y", "time", "survival", "n.risk", "n.censor", "n.event",
      "PANEL", "group", "shape", "colour", "size", "alpha",
      "stroke", "fill"
    )
  )
})
