#' Compute proportions according to custom denominator
#'
#' [stat_prop()] is a variation of [ggplot2::stat_count()] allowing to compute custom
#' proportions according to the `by` aesthetic defining the denominator
#' (i.e. all proportions for a same value of `by` will sum to 1).
#' The `by` aesthetic should be a factor.
#'
#' @inheritParams ggplot2::stat_count
#' @param geom Override the default connection between [ggplot2::geom_bar()]
#'   and [stat_prop()].
#' @param na_rm,show_legend,inherit_aes See the help file
#' for \code{\link[ggplot2]{geom_text}}. There the equivalent parameter name will have a dot \code{.} instead of
#' an underscore \code{_}.
#' @section Aesthetics:
#' [stat_prop()] understands the following aesthetics:
#'
#' - `x` or `y` (required)
#' - `by` (required, this aesthetic should be a factor)
#' - `group` (optional)
#' - `weight` (optional)
#' @section Computed variables:
#' \describe{
#'   \item{count}{number of points in bin}
#'   \item{prop}{computed proportion}
#' }
#' @seealso [ggplot2::stat_count()]
#'
#' @import ggplot2
#' @author Joseph Larmarange
#' @export
#' @examples
#'
#' d <- as.data.frame(Titanic)
#'
#' p <- ggplot(d) +
#'   aes(x = Class, fill = Survived, weight = Freq, by = Class) +
#'   geom_bar(position = "fill") +
#'   geom_text(stat = "prop", position = position_fill(.5))
#' p
#' p + facet_grid(~ Sex)
#'
#' ggplot(d) +
#'   aes(x = Class, fill = Survived, weight = Freq) +
#'   geom_bar(position = "dodge") +
#'   geom_text(
#'     aes(by = Survived),
#'     stat = "prop",
#'     position = position_dodge(0.9),
#'     vjust = "bottom"
#'   )
#'
#' ggplot(d) +
#'   aes(x = Class, fill = Survived, weight = Freq, by = 1) +
#'   geom_bar() +
#'   geom_text(
#'     aes(label = scales::percent(after_stat(prop), accuracy = 1)),
#'     stat = "prop",
#'     position = position_stack(.5)
#'   )
stat_prop <- function(mapping = NULL,
                      data = NULL,
                      geom = "bar",
                      position = "fill",
                      ...,
                      width = NULL,
                      na_rm = FALSE,
                      orientation = NA,
                      show_legend = NA,
                      inherit_aes = TRUE
                      ) {

  params <- list(
    na.rm = na_rm,
    orientation = orientation,
    width = width,
    ...
  )
  if (!is.null(params$y)) {
    stop("stat_prop() must not be used with a y aesthetic.", call. = FALSE)
  }

  layer(
    data = data,
    mapping = mapping,
    stat = StatProp,
    geom = geom,
    position = position,
    show.legend = show_legend,
    inherit.aes = inherit_aes,
    params = params
  )
}

#' @rdname ggplot2-ggproto
#' @format NULL
#' @usage NULL
#' @export
StatProp <- ggproto( # nolint
  "StatProp",
  Stat,
  required_aes = c("x|y", "by"),
  default_aes = aes(
    x = after_stat(count), y = after_stat(count), weight = 1,
    label = scales::percent(after_stat(prop), accuracy = .1)
  ),

  setup_params = function(data, params) {
    params$flipped_aes <- has_flipped_aes(data, params, main_is_orthogonal = FALSE)

    has_x <- !(is.null(data$x) && is.null(params$x))
    has_y <- !(is.null(data$y) && is.null(params$y))
    if (!has_x && !has_y) {
      stop("stat_prop() requires an x or y aesthetic.", call. = FALSE)
    }
    if (has_x && has_y) {
      stop("stat_prop() can only have an x or y aesthetic.", call. = FALSE)
    }
    # there is an unresolved bug when by is a character vector. To be explored.
    if (is.character(data$by)) {
      stop("The by aesthetic should be a factor instead of a character.", call. = FALSE)
    }
    params
  },

  extra_params = c("na.rm"),

  compute_panel = function(self, data, scales, width = NULL, flipped_aes = FALSE) {
    data <- flip_data(data, flipped_aes)
    data$weight <- utils.nest::if_null(data$weight, rep(1, nrow(data)))
    width <- utils.nest::if_null(width, resolution(data$x) * 0.9)

    # sum weights for each combination of by and aesthetics
    # the use of . allows to consider all aesthetics defined in data
    panel <- stats::aggregate(weight ~ ., data = data, sum, na.rm = TRUE)

    names(panel)[which(names(panel) == "weight")] <- "count"
    panel$count[is.na(panel$count)] <- 0

    # compute proportions by by
    sum_abs <- function(x) sum(abs(x))
    panel$prop <- panel$count / ave(panel$count, panel$by, FUN = sum_abs)
    panel$width <- width
    panel$flipped_aes <- flipped_aes

    flip_data(panel, flipped_aes)
  }
)