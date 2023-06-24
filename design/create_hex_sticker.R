pkg_color <- "#00008B"
fill_color <- "#FFFAF0"

make_hexplot <- function(out_path = "../man/figures/logo.png") {
  require(hexSticker)
  require(showtext)

  subplot <- "points.svg"

  hexSticker::sticker(
    subplot = "points.svg",
    package = "ggplot2.utils",
    p_size = 3.5,
    p_color = pkg_color,
    p_y = 1.6,
    s_y = 1.18,
    s_x = 1,
    s_width = 0.9,
    s_height = 0.9,
    h_fill = fill_color,
    h_color = "black",
    h_size = 2,
    url = "github.com/insightsengineering/ggplot2.utils",
    u_size = 1,
    u_color = pkg_color,
    filename = out_path,
    p_family = "mono",
    white_around_sticker = FALSE,
    dpi = 2000
  )
}

make_hexplot()
usethis::use_logo("../man/figures/logo.png")
