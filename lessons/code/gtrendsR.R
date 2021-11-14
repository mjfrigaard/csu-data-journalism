
# description -------------------------------------------------------------
# download google trend data in R


# packages ----------------------------------------------------------------
# install.packages("gtrendsR")
library(gtrendsR)
library(tidyverse)


# trend data --------------------------------------------------------------
BmrmGoogle <- gtrendsR::gtrends(keyword = "BioMarin",
                                geo = "US",
                                time = "today 12-m")


# plot --------------------------------------------------------------------

plot(BmrmGoogle)


# export ------------------------------------------------------------------

write_rds(x = BmrmGoogle, file = paste0("data/",
                              noquote(lubridate::today()),
                              "-BmrmGoogle.rds"))
