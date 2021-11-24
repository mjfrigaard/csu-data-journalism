#=====================================================================#
# File name: _scratch.R
# This is code to create: misc
# Authored by and feedback to: mjfrigaard
# Last updated: 2021-11-22
# MIT License
# Version: NA
# https://www.statology.org/ggplot2-legend-size/
#=====================================================================#


# packages ----------------------------------------------------------------
library(tidyverse)
library(Lahman)
library(reprex)
library(xaringan)
library(pagedown)
library(xaringanthemer)
library(vcdExtra)
library(ggrepel)
library(ggbeeswarm)
library(ggwaffle)
library(palmerpenguins)
library(fivethirtyeight)
library(ggmosaic)
library(treemapify)
library(ggdendro)


# datasets function -------------------------------------------------------
source("../code/vcsExtra-datasets-fun.R")

# create movies_data ------------------------------------------------------
source("../code/create-movie-data.R")
movies_data <- create_movie_data()
movies_data <- filter(movies_data, !is.na(budget)) %>%
  mutate(mpaa = factor(mpaa,
    levels = c("PG", "PG-13", "R")
  ))


# penguins data -----------------------------------------------------------
penguins <- palmerpenguins::penguins
# set theme ----
ggplot2::theme_set(theme(
  axis.text = element_text(size = 5),
  axis.text.x = element_text(size = 5),
  axis.text.y = element_text(size = 5),
  plot.title = element_text(size = 7),
  axis.title = element_text(size = 6),
  legend.text = element_text(size = 5),
  legend.title = element_text(size = 6),
  legend.position = "right",
  legend.key.size = unit(0.4, 'cm')
  ))

# diverging_bar_drug_use --------------------------------------------------
use <- drug_use %>%
  select(age, n, ends_with("_use")) %>%
  pivot_longer(-c(age, n), names_to = "drug", values_to = "use") %>%
  mutate(drug = str_sub(drug, start = 1, end = -5))
freq <- drug_use %>%
  select(age, n, ends_with("_freq")) %>%
  pivot_longer(-c(age, n), names_to = "drug", values_to = "freq") %>%
  mutate(drug = str_sub(drug, start = 1, end = -6))
diverging_bar_drug_use <- left_join(x = use, y = freq, by = c("age", "n", "drug")) %>%
  arrange(age) %>%
  select(age, n, drug, percent_using = use,
        median_use = freq) %>%
    filter(!is.na(median_use) &
             drug %in% c("alcohol", "cocaine", "marijuana",
                         "pain_releiver", "meth", "heroin")) %>%
  mutate(
    age = as.character(age),
    perc_using_wt = round((percent_using - mean(percent_using)) / sd(percent_using), 2),
    perc_using_cat = if_else(perc_using_wt < 0, "below", "above"),
    perc_using_cat = factor(perc_using_cat, levels = c("above", "below"))) %>%
  select(`% using (weighted)` = perc_using_wt,
         `Category` = perc_using_cat,
         Drug = drug)

diverging_bar_drug_use %>%
  ggplot(aes(x = Drug, y = `% using (weighted)`, label = Drug)) +
  geom_bar(aes(fill = `Category`),
           stat = "identity", width = .5)


# diverging_bar_candy -----------------------------------------------------
candy_names <- c("Kit Kat", "Snickers", 
                 "Reese's pieces", "Milky Way",
                 "Peanut butter M&M's", 
                 "Peanut M&Ms", "3 Musketeers",
                 "Starburst", "M&M's", 
                 "Nestle Crunch",
                 "Milky Way Simply Caramel", 
                 "Skittles original")

diverging_bar_candy <- candy_rankings %>%
  tidyr::pivot_longer(
    cols = -c(competitorname, sugarpercent, pricepercent, winpercent),
     names_to = "characteristics", values_to = "present") %>%
  mutate(present = as.logical(present)) %>% arrange(competitorname) %>%
  filter(present == TRUE) %>% distinct() %>%
  select(-present) %>%
  mutate(sugar_price_diff = sugarpercent - pricepercent,
         sugar_price_cat = if_else(sugar_price_diff < 0, "below", "above"),
         sugar_price_cat = factor(sugar_price_cat,
                                  levels = c("above", "below"))) %>%
  arrange(desc(winpercent)) %>%
  filter(competitorname %in% candy_names) %>%
  select(name = competitorname,
         `sugar % - price %` = sugar_price_diff,
         Characteristics = characteristics,
         `Diff Category` = sugar_price_cat)

diverging_bar_candy %>% ggplot(aes(x = `sugar % - price %`, 
 y =  reorder(name, `sugar % - price %`), label = Characteristics)) +
  geom_bar(aes(fill = `Diff Category`), stat = "identity", 
           width = .5) + labs(y = " ")


# heatmap_births_2000_2014 -------------------------
heatmap_births_2000_2014 <- fivethirtyeight::US_births_2000_2014 %>% 
    mutate(year = factor(year), 
           weekday = as.character(day_of_week),
           weekday = factor(weekday)) 

heatmap_births_2000_2014 %>% 
    ggplot(aes(weekday, year, fill = births)) +
    geom_raster() + 
    scale_fill_distiller(palette = "RdPu")
    

# penguins_waffle_data ----------------------------------------------------
# https://github.com/hrbrmstr/waffle
penguins_waffle <- mutate(penguins, island = as.character(island))
penguins_waffle_data <- ggwaffle::waffle_iron(penguins_waffle, 
                                     aes_d(group = island))

penguins_waffle_data %>% 
  ggplot(aes(x, y, fill = group)) + 
  ggwaffle::geom_waffle() + 
  theme_waffle() + labs(x = " ", y = " ")

penguins_waffle_data %>% 
  ggplot(aes(x, y, fill = group)) + 
  ggwaffle::geom_waffle() +
    theme(rect = element_blank(), 
          axis.ticks = element_blank(),
          legend.text = element_text(size = 12),
          legend.title = element_text(size = 14),
          legend.position = "right",
          legend.key.size = unit(0.4, 'cm')
          ) + 
    labs(x = " ", y = " ")


# flying_mosaic -----------------------------------------------------------
flying_mosaic <- fivethirtyeight::flying %>% 
    select(recline_frequency, recline_rude) %>% 
    filter(!is.na(recline_frequency) & !is.na(recline_rude)) %>% 
    mutate(
        # character 
        recline_rude = as.character(recline_rude),
        # factor
        recline_rude = factor(recline_rude), 
        # character
        recline_often = as.character(recline_frequency), 
        # factor
        recline_often = factor(recline_often))
    

flying_mosaic %>% ggplot() + 
    geom_mosaic(aes(x = product(recline_rude), 
    fill = recline_often)) + 
    theme(rect = element_blank(), 
          axis.ticks = element_blank())

# treemap_candy -----------------------------------------------------------
treemap_candy <- candy_rankings %>%
  tidyr::pivot_longer(
    cols = -c(competitorname, sugarpercent, pricepercent, winpercent),
     names_to = "characteristics", values_to = "present") %>%
  mutate(present = as.logical(present)) %>% arrange(competitorname) %>%
  filter(present == TRUE) %>% 
  select(-present, -characteristics) %>% 
  group_by(competitorname) %>% 
  slice_max(winpercent, n = 1) %>% 
  ungroup() %>% 
  distinct() %>% 
  transmute(name = competitorname, 
            win_percent = winpercent, 
            `sugar %` = round(sugarpercent, 1),
            `price %` = round(pricepercent, 1)) %>% 
    slice_sample(n = 20, replace = FALSE)

treemap_candy %>% 
  ggplot(aes(area = `sugar %`, fill = `price %`, label = name)) +
  geom_treemap() + geom_treemap_text(min.size = 3, colour = "white", 
  place = "centre", grow = TRUE)

# TO-DO SUNBURST PLOTS -------------------------
# + https://towardsdatascience.com/visualize-nested-data-with-sunburst-plots-in-r-a65710388379
# + https://github.com/didacs/ggsunburst
# devtools::install_github("didacs/ggsunburst")
# library(ggsunburst)


# dumbbell_plot_police_deaths ---------------------------------------------
dumbbell_plot_police_deaths <- fivethirtyeight::police_deaths %>%
    group_by(state, year) %>% 
    summarize(deaths = n()) %>% 
    ungroup() %>% 
    filter(year == 1997 | year == 2007) %>% 
    arrange(desc(deaths)) 
death_states <- c("TX", "NY", "CA", "FL", "LA", "IN",
            "IL", "AZ", "NC", "MS", "SC", "AR")
dumbbell_plot_police_deaths <- dumbbell_plot_police_deaths %>% 
    count(state, sort = TRUE) %>% 
    filter(n == 2) %>% 
    inner_join(x = ., y = dumbbell_plot_police_deaths, by = "state") %>% 
    arrange(desc(state)) %>% 
    filter(state %in% death_states) %>% 
    mutate(paired = rep(1:(n()/2), each = 2),
            year = factor(year)) %>% 
    select(`Police Deaths` = deaths, 
           State = state,
           Year = year, 
           paired)

dumbbell_plot_police_deaths %>% 
  ggplot(aes(x = `Police Deaths`, y = State, group = paired)) +
  geom_line(size = 0.1) + geom_point(aes(color = Year), size = 0.2) 

# ggdendro ---------------------------------------

deaths_year <- fivethirtyeight::police_deaths %>%
    filter(year == 2015) %>% 
    group_by(state, year) %>% 
    summarize(deaths = n()) %>% 
    ungroup()
killings_year <- fivethirtyeight::police_killings %>% 
    group_by(state, year) %>% 
    summarize(killings = n()) %>% 
    ungroup()

police_death_killing_year <- inner_join(deaths_year, killings_year, 
           by = c("state", "year")) 

hclust_police <- police_death_killing_year %>%
    column_to_rownames(var = 'state') %>% 
    select(deaths, killings) 

police_hcmodel <- hclust(dist(hclust_police), method = "average")
dhc_police <- as.dendrogram(police_hcmodel)
rect_police_data <- dendro_data(dhc_police, type = "rectangle")

ggplot(ggdendro::segment(rect_police_data)) + 
geom_segment(aes(x = x, y = y, xend = xend, yend = yend), size = 0.2) + 
geom_text(data = ggdendro::label(rect_police_data), aes(x = x, y = y, 
          label = label, hjust = -0.1), size = 1.8) + coord_flip() +
          scale_y_reverse(expand = c(0.2, 0)) + 
          labs(x = " ", y = " ")


# scatter-plot -------------------------------------------------
scatter_movie_data <- movies_data %>% 
    mutate(budget_mil = budget / 1000000,
           budget_mil = paste0(budget_mil, " mil"),
           budget_mil = factor(budget_mil)) %>% 
    select(title, year, rating, length, 
           budget, budget_mil, mpaa, genres)
# glimpse(scatter_movie_data) 
scatter_movie_data %>% 
    ggplot(aes(x = length, y = rating)) + 
    geom_point(size = 0.3)

scatter_movie_data %>% 
    ggplot(aes(x = length, y = rating)) + 
    geom_point(aes(color = mpaa), size = 0.3, alpha = 1/3)

bubble_movie_data <- movies_data %>% 
    mutate(`budget (million)` = budget / 1000000,
           budget_mil_fct = paste0(`budget (million)`, " mil"),
           budget_mil_fct = factor(budget_mil_fct)) %>% 
    select(title, year, rating, length, `budget (million)`, 
           budget, budget_mil_fct, mpaa, genres)

bubble_movie_data %>% ggplot(aes(x = length, y = rating)) + 
  geom_point(aes(color = mpaa, size = `budget (million)`), 
               alpha = 1/3) + theme(
                      legend.position = "left",
                      axis.text = element_text(size = 8),
                      axis.text.x = element_text(size = 8),
                      axis.text.y = element_text(size = 8),
                      plot.title = element_text(size = 10),
                      axis.title = element_text(size = 9),
                      legend.text = element_text(size = 7),
                      legend.title = element_text(size = 8),
                      legend.key.size = unit(0.9, 'cm')
                   )
