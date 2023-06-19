#' Helper for Common Kaplan-Meier Computations
#'
#' @param data (`data.frame`)\cr with `time` and `status` numeric columns.
#' @returns A list with the [survival::survfit()] result in `surv_fit`, and
#'   `x` and `y` coordinates of the Kaplan-Meier estimate.
#'
#' @keywords internal
h_stat_km <- function(data) {
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

  first <- c(0, 1)
  x <- c(first[1], surv_fit$time)
  y <- c(first[2], surv_fit$surv)

  list(
    surv_fit = surv_fit,
    x = x,
    y = y
  )
}

#' Helper for `stat_km_compute`
#'
#' @param x (`numeric`)\cr first dimension.
#' @param y (`numeric`)\cr second dimension
#' @returns List of `x` and `y` describing the step path.
#'
#' @keywords internal
h_step <- function(x, y) {
  assert_numeric(x, sorted = TRUE, unique = TRUE)
  assert_numeric(y, len = length(x))

  keep <- is.finite(x) & is.finite(y)
  if (!any(keep))
    return()
  if (!all(keep)) {
    x <- x[keep]
    y <- y[keep]
  }
  n <- length(x)
  if (n == 1)
    list(x = x, y = y)
  else if (n == 2)
    list(x = x[c(1, 2, 2)], y = y[c(1, 1, 2)])
  else {
    temp <- rle(y)$lengths
    drops <- 1 + cumsum(temp[-length(temp)])
    if (n %in% drops) {
      xrep <- c(x[1], rep(x[drops], each = 2))
      yrep <- rep(y[c(1, drops)], c(rep(2, length(drops)), 1))
    }
    else {
      xrep <- c(x[1], rep(x[drops], each = 2), x[n])
      yrep <- c(rep(y[c(1, drops)], each = 2))
    }
    list(x = xrep, y = yrep)
  }
}

#' Helper for `stat_km`
#'
#' @inheritParams h_stat_km
#' @param scales not used.
#' @returns A `data.frame` with `time` and `survival` columns.
#'
#' @keywords internal
stat_km_compute <- function(data, scales) {
  tmp <- h_stat_km(data)
  step <- h_step(tmp$x, tmp$y)
  data.frame(
    time = step$x,
    survival = step$y
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
  tmp <- h_stat_km(data)
  data.frame(
    time = tmp$x,
    survival = tmp$y,
    n.risk = tmp$surv_fit$n.risk,
    n.censor = tmp$surv_fit$n.censor,
    n.event = tmp$surv_fit$n.event
  )
}
