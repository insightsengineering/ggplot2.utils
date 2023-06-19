#' Helper for Common Kaplan-Meier Computations
#'
#' @keywords internal
h_stat_km <- function(data,
                      scales,
                      trans = scales::identity_trans()) {
  assert_function(trans)

  surv_fit <- survival::survfit(
    survival::Surv(data$time, data$status) ~ 1,
    se.fit = FALSE,
    stype = 1,
    ctype = 1
  )
  transloc <- scales::as.trans(trans)$trans

  if(is.null(surv_fit$surv)) {
    x <- rep(surv_fit$time, 2)
    surv_fit$surv <- rep(1, length(x))
  }
  first <- c(0, 1)
  x <- c(first[1], surv_fit$time)
  y <- transloc(c(first[2], surv_fit$surv))
  y[y == -Inf] <- min(y[is.finite(y)])
  y[y == Inf] <- max(y[is.finite(y)])

  list(
    surv_fit = surv_fit,
    x = x,
    y = y
  )
}

#' Helper for `stat_km`
#'
#' @keywords internal
stat_km_compute <- function(data,
                            scales,
                            trans) {
  tmp <- h_stat_km(data, scales, trans)
  step <- dostep(tmp$x, tmp$y)
  data.frame(
    time = step$x,
    survival = step$y
  )
}

#' Helper for `stat_km_ticks`
#'
#' @keywords internal
stat_km_ticks_compute <- function(data,
                                  scales,
                                  trans) {
  tmp <- h_stat_km(data, scales, trans)
  data.frame(
    time = tmp$x,
    survival = tmp$y,
    n.risk = tmp$surv_fit$n.risk,
    n.censor = tmp$surv_fit$n.censor,
    n.event = tmp$surv_fit$n.event
  )
}
