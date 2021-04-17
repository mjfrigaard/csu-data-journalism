#=====================================================================#
# This is code to create: covid-vaccination-rates.R
# Authored by and feedback to: @mjfrigaard
# MIT License
# Version: 01
#=====================================================================#


# packages -----------------------------------------------------------
library(tidyverse)
library(rvest)
library(xml2)

# scrape wikipedia table ---------------------------------------------
# Read html from url
wiki_html <- xml2::read_html("https://en.wikipedia.org/wiki/COVID-19_vaccine")
# extract html nodes
wiki_html_tables <- wiki_html %>% rvest::html_nodes(css = "table")
# identify relevant html table with 'distribution' in the title
relevant_tables <- wiki_html_tables[grep("distribution", wiki_html_tables)]
# convert table to data.frame
COVID19VaxDistByLoc <- rvest::html_table(relevant_tables[[1]],
                                         fill = TRUE)
# assign names to first three columns
COVID19VaxDistByLoc <- COVID19VaxDistByLoc[ , 1:3] %>%
  magrittr::set_names(x = ., value = c("location", "n_vaccinated",
                                       "perc_of_pop"))

