#' @include stat_km_compute.R
NULL

#' Adds a Kaplan-Meier Estimate of Survival Statistic
#'
#' @description `r lifecycle::badge("experimental")`
#' This `stat` is for computing the Kaplan-Meier survival estimate for
#' right-censored data. It requires the aesthetic mapping `time` for the
#' observation times and `status` which indicates the event status,
#' either 0 for alive and 1 for dead, or 1 for alive and 2 for dead.
#'
#' @note Logical `status` is not supported.
#'
#' @inheritParams ggplot2::stat_identity
#'
#' @returns A `data.frame` with columns:
#'   - `time`: `time` in `data`.
#'   - `survival`: survival estimate at `time`.
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
#'   stat_km()
stat_km <- function(mapping = NULL,
                    data = NULL,
                    geom = "km",
                    position = "identity",
                    show.legend = NA,
                    inherit.aes = TRUE,
                    ...) {
  ggplot2::layer(
    stat = StatKm,
    data = data,
    mapping = mapping,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(...)
  )
}

#' @rdname ggproto
#' @export
StatKm <- ggplot2::ggproto(
  "StatKm",
  ggplot2::Stat,
  compute_group = stat_km_compute,
  default_aes = ggplot2::aes(y = ..survival.., x = ..time..),
  required_aes = c("time", "status"),
  dropped_aes = "status"
)
