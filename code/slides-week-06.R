# packages ----------------------------------------------------------------
library(tidyverse)


# data --------------------------------------------------------------------
# copy and paste me!
NotTidy <- tibble::tribble(
  ~group,   ~`2019`,   ~`2020`,   ~`2021`,
  "A", "102/100", "123/100", "161/100",
  "B", "179/100", "199/100", "221/100",
  "C", "223/100", "146/100", "288/100")


# view --------------------------------------------------------------------

View(NotTidy)


# pivot longer ------------------------------------------------------------
NotTidy %>% 
  tidyr::pivot_longer(
    cols = -group, 
    names_to = "year", 
    values_to = "rate") %>% 
  View("Tidy")


# key & value  ------------------------------------------------------------
NotTidy %>% 
  tidyr::pivot_longer(
    cols = -group, 
    names_to = "key", 
    values_to = "value") %>% 
  View("Tidy")



# tidy data  --------------------------------------------------------------
Tidy <- NotTidy %>% 
  pivot_longer(
    cols = -group, 
    names_to = "year", 
    values_to = "rate", 
    names_transform = list(
      year = as.numeric))


# site rates data ----

SiteRates <- tibble::tribble(
  ~site, ~`2019_Q1`, ~`2019_Q2`, ~`2019_Q3`, ~`2019_Q4`,
  "Boston",         52,         31,         26,       33.4,
  "Philadelphia",       7.42,       5.51,       5.82,       6.99,
  "Cincinnati",       6.73,       4.87,       5.02,       4.66,
  "Texas",       18.2,       16.6,         17,         19)
SiteRates

## site rates pivot longer ----
SiteRates %>% 
  pivot_longer(
    -site,
    names_to = 
      c("year", "quarter"), 
    values_to = "rate",
    names_sep = "_Q", 
    names_transform = list(
      year = as.integer,
      quarter = as.integer))


# space dogs data ---------------------------------------------------------
SpaceDogs <- data.frame(
  date = c("1966-02-22", "1961-03-25", 
           "1961-03-09", "1960-12-22",
           "1960-12-01", "1960-09-22"),
  result = c("recovered safely", "recovered safely",
             "recovered safely", "recovered",
             "both dogs died","recovered safely"),
  name_1 = c("Ugolyok / Snezhok", "Zvezdochka", 
             "Chernuskha", "Shutka", "Mushka",
             "Kusachka / Otvazhnaya"),
  name_2 = c("Veterok / Bzdunok", NA, NA, 
             "Kometka", "Pchyolka", "Neva"))


# restructure space dogs --------------------------------------------------
SpaceDogs %>% 
  pivot_longer(
    # dplyr::starts_with()
    # dplyr::ends_with()
    cols = starts_with("name_"), 
    names_sep = "_",
    names_to = 
      c(".value", "dog_id"), # remove missing
    values_drop_na = TRUE)

TidySpaceDogs <- SpaceDogs %>% 
  pivot_longer(
    # dplyr::starts_with()
    # dplyr::ends_with()
    cols = starts_with("name_"), 
    names_sep = "_",
    names_to = 
      c(".value", "dog_id"), # remove missing
    values_drop_na = TRUE)


# cats vs. dogs data ------------------------------------------------------

CatVsDogWide <- tibble::tribble(
  ~metric,   ~CA,  ~TX,  ~FL,  ~NY,  ~PA,
  "no_of_households", 12974, 9002, 7609, 7512, 5172,
  "no_of_pet_households",  6865, 5265, 4138, 3802, 2942,
  "no_of_dog_households",  4260, 3960, 2718, 2177, 1702,
  "no_of_cat_households",  3687, 2544, 2079, 2189, 1748)

# original data
CatVsDogWide %>% View("CvDWide")

# long data
CatVsDogWide %>%
  pivot_longer(-metric, 
               names_to = "state", 
               values_to = "value") %>% 
  # view
  View("CvDLong")

CatVsDogWide %>%
  # longer 
  pivot_longer(cols = -metric, 
               names_to = "state", 
               values_to = "value") %>% 
  # wider
  pivot_wider(names_from = "metric", 
              values_from = "value") %>% 
  View("NewCvDWide")

# percentage cols
CatVsDogWide %>% # take original wide data
  # longer 
  pivot_longer(cols = -metric, 
               names_to = "state", 
               values_to = "value") %>% # make it longer
  # wider
  pivot_wider(names_from = "metric", 
              values_from = "value") %>% # make it wider 
  
  # add percentages 
  mutate(
    perc_pet_household = no_of_pet_households / no_of_households * 100,
    perc_pet_household = round(perc_pet_household, digits = 1),
    perc_dog_owners = no_of_dog_households / no_of_households * 100, 
    perc_dog_owners = round(perc_dog_owners, digits = 1),
    perc_cat_owners = no_of_cat_households / no_of_households * 100,
    perc_cat_owners = round(perc_cat_owners, digits = 1)) %>% # view 
  View("PercCatvDog")


# reorganize cols  --------------------------------------------------------
CatVsDogWide %>% # take original wide data
  # longer 
  pivot_longer(cols = -metric, 
               names_to = "state", 
               values_to = "value") %>% # make it longer
  # wider
  pivot_wider(names_from = "metric", 
              values_from = "value") %>% # make it wider 
  
  # add percentages 
  mutate(
    perc_pet_household = no_of_pet_households / no_of_households * 100,
    perc_pet_household = round(perc_pet_household, digits = 1),
    perc_dog_owners = no_of_dog_households / no_of_households * 100, 
    perc_dog_owners = round(perc_dog_owners, digits = 1),
    perc_cat_owners = no_of_cat_households / no_of_households * 100,
    perc_cat_owners = round(perc_cat_owners, digits = 1)) %>%
  # reorganize 
  select(state, 
         contains("perc_dog"), contains("perc_cat")) %>% # view 
  View("PercCatvDog")



