#' Set default table theme
#'
#' @description `r lifecycle::badge("experimental")`
#'
#' See [ggpp::ttheme_set()] for details.
#'
#' @inherit ggpp::ttheme_set return
#'
#' @note When testing this function, we found that in contrast to the original
#'   documentation, the theme is not fixed when the plot object is constructed.
#'   Instead, the option setting affects the rendering of ready built plot
#'   objects.
#'
#' @name ttheme_set
#' @rdname ttheme_set
#'
#' @importFrom ggpp ttheme_set
#' @export
NULL
