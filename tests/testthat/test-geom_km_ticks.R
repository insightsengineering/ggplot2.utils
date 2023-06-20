test_that("geom_km_ticks works as expected", {
  p <- ggplot(surv_df, aes(time = time, status = status))
  result <- expect_silent(
    p + geom_km_ticks()
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

test_that("geom_km_ticks looks as expected for a single group", {
  p <- ggplot(surv_df, aes(time = time, status = status)) +
    geom_km_ticks()
  vdiffr::expect_doppelganger("geom_km_ticks single group", p)
})

test_that("geom_km_ticks looks as expected for two groups", {
  p <- ggplot(surv_df, aes(time = time, status = status, color = factor(group))) +
    geom_km_ticks()
  vdiffr::expect_doppelganger("geom_km_ticks two groups", p)
})
