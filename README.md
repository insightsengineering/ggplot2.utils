# ggplot2.utils

The `ggplot2.utils` package simplifies access to utility functions adding functionality to [ggplot2](https://ggplot2.tidyverse.org/). The package imports functions across multiple extensions packages and then exports them, so that the user only needs to load this package instead of multiple others.

## Installation

This repository requires a personal access token to install see here [creating and using PAT](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token). Once this is set up, to install the latest released version of the package run:

```r
Sys.setenv(GITHUB_PAT = "your_access_token_here")
if (!require("devtools")) install.packages("devtools")
devtools::install_github("insightsengineering/ggplot2.utils@*release")
```

[![Forkers repo roster for @insightsengineering/ggplot2.utils](https://reporoster.com/forks/insightsengineering/ggplot2.utils)](https://github.com/insightsengineering/ggplot2.utils/network/members)

## Stargazers over time

[![Stargazers over time](https://starchart.cc/insightsengineering/ggplot2.utils.svg)](https://starchart.cc/insightsengineering/ggplot2.utils)
