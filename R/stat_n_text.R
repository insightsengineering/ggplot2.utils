#' @rdname ggplot2-ggproto
#' @format NULL
#' @usage NULL
#' @export
StatNText <- ggplot2::ggproto( # nolint
  "StatNText",
  ggplot2::Stat,

  required_aes = c("x"),

  setup_params = function(data, params) {
    if (!is.null(params$y_pos)) return(params)
    if (is.null(data$y)) stop("Without y aesthetic y_pos needs to be provided")
    range_y <- range(data$y, na.rm = TRUE)
    pos <- range_y[1] - diff(range_y) * params$y_expand_factor
    params$y_pos <- pos
    params
  },

  compute_panel = function(data, scales, y_pos, y_expand_factor) {
    n_tibble <- if (is.null(data$y)) {
      dplyr::summarize(
        dplyr::group_by(data, x),
        N = dplyr::n()
      )
    } else {
      dplyr::summarize(
        dplyr::group_by(data, x),
        N = sum(!is.na(y))
      )
    }

    n_vec <- unlist(n_tibble[, "N"]) # nolint
    lab <- paste0("n=", n_vec)

    data.frame(x = unlist(n_tibble[, "x"]), y = y_pos, label = lab)
  }
)

#' Add Text Indicating the Sample Size to a ggplot2 Plot
#'
#' For a strip plot or scatterplot produced using the package
#' \link[ggplot2]{ggplot2} (e.g., with \code{\link[ggplot2]{geom_point}}), for
#' each value on the \eqn{x}-axis, add text indicating the number of
#' \eqn{y}-values for that particular \eqn{x}-value.
#'
#' See the help file for \code{\link[ggplot2]{geom_text}} for details about how
#' \code{\link[ggplot2]{geom_text}} and \code{\link[ggplot2]{geom_label}} work.
#'
#' See the vignette \bold{Extending ggplot2} at
#' \url{https://cran.r-project.org/package=ggplot2/vignettes/extending-ggplot2.html}
#' for information on how to create a new stat.
#'
#' @param mapping,data,position,na_rm,show_legend,inherit_aes See the help file
#' for \code{\link[ggplot2]{geom_text}}. There the equivalent parameter name will have a dot \code{.} instead of
#' an underscore \code{_}.
#' @param geom Character string indicating which \code{geom} to use to display
#' the text.  Setting \code{geom="text"} will use
#' \code{\link[ggplot2]{geom_text}} to display the text, and setting
#' \code{geom="label"} will use \code{\link[ggplot2]{geom_label}} to display
#' the text.  The default value is \code{geom="text"} unless the user sets
#' \code{text_box=TRUE}.
#' @param y_pos Numeric scalar indicating the \eqn{y}-position of the text
#' (i.e., the value of the argument \code{y} that will be used in the call to
#' \code{\link[ggplot2]{geom_text}} or \code{\link[ggplot2]{geom_label}}).  The
#' default value is \code{y_pos=NULL}, in which case \code{y_pos} is set to the
#' minimum value of all \eqn{y}-values minus a proportion of the range of all
#' \eqn{y}-values, where the proportion is determined by the argument
#' \code{y_expand_factor} (see below).
#' @param y_expand_factor For the case when \code{y_pos=NULL}, a numeric scalar
#' indicating the proportion by which the range of all \eqn{y}-values should be
#' multiplied by before subtracting this value from the minimum value of all
#' \eqn{y}-values in order to compute the value of the argument \code{y_pos}
#' (see above).  The default value is \code{y_expand_factor=0.1}.
#' @param text_box Logical scalar indicating whether to surround the text with
#' a text box (i.e., whether to use \code{\link[ggplot2]{geom_label}} instead
#' of \code{\link[ggplot2]{geom_text}}).  This argument can be overridden by
#' simply specifying the argument \code{geom}.
#' @param alpha,angle,color,family,fontface,hjust,vjust,lineheight,size See the
#' help file for \code{\link[ggplot2]{geom_text}} and the vignette
#' \bold{Aesthetic specifications} at
#' \url{https://cran.r-project.org/package=ggplot2/vignettes/ggplot2-specs.html}.
#' @param label_padding,label_r,label_size See the help file for
#' \code{\link[ggplot2]{geom_text}}.
#' @param \dots Other arguments passed on to \code{\link[ggplot2]{layer}}.
#' @author Steven P. Millard (\email{EnvStats@@ProbStatInfo.com})
#' @seealso \code{\link[ggplot2]{geom_text}}, \code{\link[ggplot2]{geom_label}}.
#' @references Wickham, H. (2016).  \emph{ggplot2: Elegant Graphics for Data
#' Analysis (Use R!)}.  Second Edition.  Springer.
#' @keywords aplot
#' @export
#' @examples
#'
#' # Using the built-in data frame mtcars,
#' # plot miles per gallon vs. number of cylinders
#' # using different colors for each level of the number of cylinders.
#'
#' p <- ggplot(mtcars, aes(x = factor(cyl), y = mpg, color = factor(cyl))) +
#'   theme(legend.position = "none")
#'
#' p + geom_point() +
#'   labs(x = "Number of Cylinders", y = "Miles per Gallon")
#'
#'
#' # Now add the sample size for each level of cylinder.
#'
#' p + geom_point() +
#'   stat_n_text() +
#'   labs(x = "Number of Cylinders", y = "Miles per Gallon")
#'
#' # Repeat Example 1, but:
#' # 1) facet by transmission type,
#' # 2) make the size of the text smaller.
#'
#' p + geom_point() +
#'   stat_n_text(size = 3) +
#'   facet_wrap(~ am, labeller = label_both) +
#'   labs(x = "Number of Cylinders", y = "Miles per Gallon")
#'
#' # Repeat Example 1, but specify the y-position for the text.
#'
#' p + geom_point() +
#'   stat_n_text(y_pos = 5) +
#'   labs(x = "Number of Cylinders", y = "Miles per Gallon")
#'
#' # Repeat Example 1, but show the sample size in a text box.
#'
#' p + geom_point() +
#'   stat_n_text(text_box = TRUE) +
#'   labs(x = "Number of Cylinders", y = "Miles per Gallon")
#'
#' # Repeat Example 1, but use the color brown for the text.
#'
#' p + geom_point() +
#'   stat_n_text(color = "brown") +
#'   labs(x = "Number of Cylinders", y = "Miles per Gallon")
#'
#' # Repeat Example 1, but:
#' # 1) use the same colors for the text that are used for each group,
#' # 2) use the bold monospaced font.
#'
#' mat <- ggplot_build(p)$data[[1]]
#' group <- mat[, "group"]
#' colors <- mat[match(1:max(group), group), "colour"]
#'
#' p + geom_point() +
#'   stat_n_text(color = colors, size = 5,
#'     family = "mono", fontface = "bold") +
#'   labs(x = "Number of Cylinders", y = "Miles per Gallon")
#'
#' # Use it for a barplot - this needs `y_pos` specification since there is no y aesthetic.
#' p <- ggplot(mtcars, aes(x = factor(cyl), fill = factor(vs))) +
#'   geom_bar(position = "fill") +
#'   stat_n_text(y_pos = -0.05, text_box = TRUE)
#' p
stat_n_text <- function(mapping = NULL,
                        data = NULL,
                        geom = ifelse(text_box, "label", "text"),
                        position = "identity",
                        na_rm = FALSE,
                        show_legend = FALSE,
                        inherit_aes = TRUE,
                        y_pos = NULL,
                        y_expand_factor = 0.1,
                        text_box = FALSE,
                        alpha = 1,
                        angle = 0,
                        color = "black",
                        family = "",
                        fontface = "plain",
                        hjust = 0.5,
                        label_padding = ggplot2::unit(0.25, "lines"),
                        label_r = ggplot2::unit(0.15, "lines"),
                        label_size = 0.25,
                        lineheight = 1.2,
                        size = 4,
                        vjust = 0.5,
                        ...) {
  geom <- match.arg(geom, c("label", "text"))
  params <- list(
    y_pos = y_pos, y_expand_factor = y_expand_factor,
    alpha = alpha, angle = angle, color = color, family = family,
    fontface = fontface, hjust = hjust, lineheight = lineheight,
    size = size, vjust = vjust
  )
  params <- if (geom == "label") {
    c(params, list(label.padding = label_padding, label.r = label_r, label.size = label_size, na.rm = na_rm, ...))
  } else {
    c(params, na.rm = na_rm, ...)
  }
  ggplot2::layer(
    stat = StatNText, data = data, mapping = mapping,
    geom = geom, position = position, show.legend = show_legend,
    inherit.aes = inherit_aes, params = params)
}
