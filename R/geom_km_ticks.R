#' Add Tick Marks to a Kaplan-Meier Survival Curve
#'
#' @description `r lifecycle::badge("experimental")`
#' Adds tickmarks at the times when there are censored observations but no
#' events.
#'
#' @inheritParams ggplot2::geom_point
#'
#' @section Aesthetics:
#' `geom_km_ticks()` understands the following aesthetics (required aesthetics in bold):
#'
#' - **`x`**: the survival/censoring times, automatically mapped by [stat_km_ticks()].
#' - **`y`**: the survival probability estimates, automatically mapped by [stat_km_ticks()].
#' - `alpha`
#' - `color`
#' - `shape`
#' - `size`
#' - `stroke`
#' - `fill`
#'
#' @seealso The default `stat` for this `geom` is [stat_km_ticks()].
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
#' ggplot(df, aes(time = time, status = status, color = factor(sex), group = factor(sex))) +
#'   geom_km() +
#'   geom_km_ticks(col = "black")
geom_km_ticks <- function(mapping = NULL,
                          data = NULL,
                          stat = "km_ticks",
                          position = "identity",
                          show.legend = NA,
                          inherit.aes = TRUE,
                          na.rm = TRUE,
                          ...) {
  ggplot2::layer(
    geom = GeomKmTicks,
    mapping = mapping,
    data = data,
    stat = stat,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

# GeomKmTicks ----

#' @rdname ggproto
#' @export
GeomKmTicks <- ggplot2::ggproto(
  "GeomKmTicks",
  ggplot2::Geom,
  draw_group = function(data, scales, coordinates, ...) {
    showpoints <- data$n.censor > 0 & data$n.event == 0
    coordsp <- coordinates$transform(data, scales)[showpoints, , drop = FALSE]
    if (nrow(coordsp) == 0) {
      grid::nullGrob()
    } else {
      grid::pointsGrob(
        coordsp$x,
        coordsp$y,
        pch = coordsp$shape,
        size = grid::unit(coordsp$size, "char"),
        gp = grid::gpar(
          col = coordsp$colour,
          fill = coordsp$fill,
          alpha = coordsp$alpha
        )
      )
    }
  },
  required_aes = c("x", "y"),
  non_missing_aes = c("size", "shape"),
  default_aes = ggplot2::aes(
    shape = 3,
    colour = "black",
    size = .75,
    alpha = 1,
    stroke = 0.5,
    fill = "black"
  ),
  draw_key = ggplot2::draw_key_point
)
