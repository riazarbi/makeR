# Base packages
install.packages(c("remotes", "pak"))

# Base packages
pak::pak_install_extra()

pak::pkg_install("rspm")

rspm::enable()
packages <- c("rmarkdown", "renv", "dplyr", "arrow", "duckdb", "imager")

pak::pkg_install(packages)