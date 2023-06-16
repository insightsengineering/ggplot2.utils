#' Adds a Kaplan-Meier Estimate of Survival Statistic
#'
#' @description `r lifecycle::badge("experimental")`
#' This `stat` is for computing the Kaplan-Meier survival estimate for
#' right-censored data. It requires the aesthetic mapping `x` for the
#' observation times and `status` which indicates the event status,
#' either 0 for alive and 1 for dead, or 1 for alive and 2 for dead.
#'
#' @note Logical `status` is not supported.
#'
#' @inheritParams ggplot2::stat_identity
#' @param trans (`function`)\cr transformation to apply to the survival
#'   probabilities, see [`scales`] for more options.
#' @param first (length 2 `numeric`)\cr the starting point for the survival curves
#'   in `(x, y)` coordinates.
#' @param start.time (`number`)\cr see [survival::survfit.formula].
#'
#' @returns A `data.frame` with additional columns:
#'   - `x`: `x` in `data`.
#'   - `y`: survival estimate at `x`.
#'
#' @author Michael Sachs (in `ggkm`), Samer Mouksassi (in `ggquickeda`).
#' @export
#' @examples
#' library(ggplot2)
#' sex <- rbinom(250, 1, .5)
#' df <- data.frame(
#'   time = exp(rnorm(250, mean = sex)),
#'   status = rbinom(250, 1, .75),
#'   sex = sex
#' )
#' ggplot(df, aes(time = time, status = status, color = factor(sex))) +
#'  stat_km()
#'
#' p1 <- ggplot(df, aes(time = time, status = status))
#' p1 + stat_km()
#' p1 + stat_km(trans = "cumhaz")
#' p1 + stat_km(trans = "cloglog") + scale_x_log10()
#' p1 + stat_km(start.time = 5)
stat_km <- function(mapping = NULL,
                    data = NULL,
                    geom = "km",
                    position = "identity",
                    show.legend = NA,
                    inherit.aes = TRUE,
                    trans = scales::identity_trans(),
                    first = c(0, 1),
                    start.time = 0,
                    ...) {
  ggplot2::layer(
    stat = StatKm,
    data = data,
    mapping = mapping,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      trans = trans,
      first = first,
      type = type,
      start.time = start.time,
      ...
    )
  )
}

#' @rdname ggproto
#' @export
StatKm <- ggplot2::ggproto(
  "StatKm",
  ggplot2::Stat,
  compute_group = function(data,
                           scales,
                           trans = scales::identity_trans(),
                           first = c(0, 1),
                           start.time = 0) {
    assert_function(trans)
    assert_numeric(first, finite = TRUE, any.missing = FALSE, len = 2L)
    assert_number(start.time)

    sf <- survival::survfit.formula(
      survival::Surv(data$time, data$status) ~ 1,
      se.fit = FALSE,
      start.time = start.time,
      # We use standard Kaplan-Meier estimator, therefore:
      stype = 1,
      ctype = 1
    )
    transloc <- scales::as.trans(trans)$trans
    if(is.null(sf$surv)) {
      x <- rep(sf$time, 2)
      sf$surv <- rep(1, length(x))
    }
    x <- c(first[1], sf$time)
    y <- transloc(c(first[2], sf$surv))
    y[y == -Inf] <- min(y[is.finite(y)])
    y[y == Inf] <- max(y[is.finite(y)])
    step <- dostep(x, y)
    data.frame(time = step$x, survival = step$y)
  },
  default_aes = ggplot2::aes(y = ..survival.., x = ..time..),
  required_aes = c("time", "status")
)
