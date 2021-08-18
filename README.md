# ggplot2.utils

The `ggplot2.utils` package simplifies access to utility functions adding functionality to [ggplot2](https://ggplot2.tidyverse.org/). The package imports functions across multiple extensions packages and then exports them, so that the user only needs to load this package instead of multiple others.

# Installation

## Clone and install manually
1. Clone the repository

   The repository can be downloaded directly from the `github.com` site as an archive (see [Github tutorial on cloning to learn more](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository-from-github/cloning-a-repository)). Alternatively, Git command line tools offer the same functionality, without the need for manual downloading and unpacking the archive, but require to authenticate to Github. You can authenticate using a key pair or a Personal Access Token (PAT). Please refer to excellent Github tutorials on [connecting to Github using SSH](https://docs.github.com/en/github/authenticating-to-github) or [creating and using PAT](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token).
   1. Using PAT. Input in the Git Bash console, PowerShell or any Linux shell:

      ```
      $ git clone https://github.com/insightsengineering/ggplot2.utils.git
      Username: your_username_goes_here
      Password: your_token_goes_here
      ```
    1. Using SSH. If set up properly, the repository is ready to be cloned executing:

       ```
       $ git clone https://github.com/insightsengineering/ggplot2.utils.git
       ```
   This creates a sub-directory `ggplot2.utils` containing the cloned repository.

2. Build and install

   The native R tools provide a quick way to install a package. Run in PowerShell or any Linux shell:
   ```
   $ R CMD build ggplot2.utils
   ```
   This command builds the package and creates an archive. The name of the archive is output by the command at then of building. Then input in the shell:
   ```
   $ Rscript -e 'install.packages("name_of_the_archive")
   ```
   Here is an example of a real command (with name_of_the_archive substituted by the output of the build command):
   ```
   $ Rscript -e 'install.packages("ggplot2.utils_0.1.2.9000.tar.gz")'
   ```
