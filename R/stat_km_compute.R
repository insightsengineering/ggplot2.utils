#' Helper for Common Kaplan-Meier Computations
#'
#' @param data (`data.frame`)\cr with `time` and `status` numeric columns.
#' @returns The [survival::survfit()] result as basis of
#'   the Kaplan-Meier estimate.
#'
#' @keywords internal
h_surv_fit <- function(data) {
  assert_data_frame(data)
  assert_subset(c("time", "status"), names(data))
  assert_numeric(data$status)
  assert_numeric(data$time)

  surv_fit <- survival::survfit(
    survival::Surv(data$time, data$status) ~ 1,
    se.fit = FALSE,
    stype = 1,
    ctype = 1
  )
  assert_numeric(surv_fit$surv)
  surv_fit
}

#' Helper for `stat_km`
#'
#' @inheritParams h_surv_fit
#' @param scales not used.
#' @returns A `data.frame` with `time` and `survival` columns.
#'
#' @keywords internal
stat_km_compute <- function(data, scales) {
  surv_fit <- h_surv_fit(data)
  first <- c(0, 1)
  data.frame(
    time = c(first[1], surv_fit$time),
    survival = c(first[2], surv_fit$surv)
  )
}

#' Helper for `stat_km_ticks`
#'
#' @inheritParams stat_km_compute
#' @returns A `data.frame` with `time`, `survival`, `n.risk`, `n.censor` and `n.event`
#'   columns.
#'
#' @keywords internal
stat_km_ticks_compute <- function(data, scales) {
  surv_fit <- h_surv_fit(data)
  data.frame(
    time = surv_fit$time,
    survival = surv_fit$surv,
    n.risk = surv_fit$n.risk,
    n.censor = surv_fit$n.censor,
    n.event = surv_fit$n.event
  )
}
