# h_surv_fit ----

test_that("h_surv_fit works as expected", {
  result <- expect_silent(h_surv_fit(surv_df))
  expect_list(result)
  expect_s3_class(result, "survfit")
  expect_numeric(result$time)
  expect_numeric(result$surv)
  expect_identical(result$time, sort(unique(surv_df$time)))
  expect_snapshot_value(result$surv, style = "deparse")
})

test_that("h_surv_fit also works when there is only a single observation", {
  df <- data.frame(
    time = 1,
    status = 0
  )
  result <- expect_silent(h_surv_fit(df))
  expect_identical(result$time, 1)
  expect_identical(result$surv, 1)
})

# stat_km_compute ----

test_that("stat_km_compute works as expected", {
  result <- expect_silent(stat_km_compute(surv_df))
  expect_data_frame(result)
  expect_named(result, c("time", "survival"))
  expect_snapshot_value(result, style = "deparse")
})

# stat_km_ticks_compute ----

test_that("stat_km_ticks_compute works as expected", {
  result <- expect_silent(stat_km_ticks_compute(surv_df))
  expect_data_frame(result)
  expect_named(result, c("time", "survival", "n.risk", "n.censor", "n.event"))
  expect_snapshot_value(result, style = "deparse")
})
