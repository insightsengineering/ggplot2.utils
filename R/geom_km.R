#' Add a Kaplan-Meier Survival Curve
#'
#' @description `r lifecycle::badge("experimental")`
#' Adds the Kaplan-Meier survival curve.
#'
#' @inheritParams ggplot2::geom_step
#'
#' @section Aesthetics:
#' `geom_km()` understands the following aesthetics (required aesthetics in bold):
#'
#' - **`x`**: the survival/censoring times, automatically mapped by [stat_km()].
#' - **`y`**: the survival probability estimates, automatically mapped by [stat_km()].
#' - `alpha`
#' - `color`
#' - `linetype`
#' - `linewidth`
#'
#' @seealso The default `stat` for this `geom` is [stat_km()].
#'
#' @author Inspired by `geom_km` written by Michael Sachs (in `ggkm`) and
#'   Samer Mouksassi (in `ggquickeda`). Here we directly use [ggplot2::geom_step()]
#'   instead of the more general [ggplot2::geom_path()].
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
#'   geom_km()
geom_km <- function(mapping = NULL,
                    data = NULL,
                    stat = "km",
                    position = "identity",
                    show.legend = NA,
                    inherit.aes = TRUE,
                    na.rm = TRUE,
                    ...) {
  ggplot2::layer(
    geom = GeomKm,
    mapping = mapping,
    data = data,
    stat = stat,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

# GeomKm ----

#' @rdname ggproto
#' @export
GeomKm <- ggplot2::ggproto(
  "GeomKm",
  ggplot2::GeomStep,
  draw_group = function(data, scales, coordinates, ...) {
    path <- transform(data, alpha = NA)
    ggplot2::GeomStep$draw_panel(path, scales, coordinates, direction = "hv")
  },
  required_aes = c("x", "y"),
  default_aes = ggplot2::aes(
    colour = "black",
    fill = "grey60",
    linewidth = 0.75,
    linetype = 1,
    weight = 1,
    alpha = 1
  )
)
