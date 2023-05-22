install.packages("remotes")
# fix compile issue for stringr on jammy
install.packages("stringi")
# use posit binary linux packages
options(HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(), paste(getRversion(), R.version["platform"], R.version["arch"], R.version["os"])))
options(repos="https://packagemanager.rstudio.com/all/__linux__/focal/latest")
source("https://docs.posit.co/rspm/admin/check-user-agent.R")
# install rmarkdown
install.packages("rmarkdown")
