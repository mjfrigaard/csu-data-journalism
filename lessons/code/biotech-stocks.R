

# packages ----------------------------------------------------------------

library(tidyverse)
library(janitor)


# data source -------------------------------------------------------------
# https://finance.yahoo.com/u/yahoo-finance/watchlists/biotech-and-drug-stocks
BioTechDrugStocks <- tibble::tribble(
     ~Symbol,                           ~Company.Name, ~Last.Price, ~Change, ~`%.Change`,  ~Market.Time,   ~Volume, ~`Avg.Vol.(3.month)`, ~Market.Cap,
       "JNJ",                     "Johnson & Johnson",      152.95,     0.7,    "+0.46%", "4:00 PM EST",   "5.97M",              "6.89M",   "402.65B",
     "RHHBY",                      "Roche Holding AG",       43.21,    0.03,    "+0.07%", "4:00 PM EST",   "1.42M",              "1.17M",   "294.49B",
       "PFE",                           "Pfizer Inc.",       41.12,   -0.61,    "-1.46%", "4:02 PM EST",  "58.90M",             "38.86M",   "228.56B",
       "NVS",                           "Novartis AG",       92.62,    0.94,    "+1.03%", "4:00 PM EST",   "1.89M",              "1.91M",   "209.99B",
       "MRK",                     "Merck & Co., Inc.",       82.96,   -0.03,    "-0.04%", "4:02 PM EST",   "7.23M",              "8.37M",   "209.89B",
      "ABBV",                           "AbbVie Inc.",      106.34,   -1.15,    "-1.07%", "4:02 PM EST",   "4.99M",              "8.19M",   "187.74B",
       "NVO",                      "Novo Nordisk A/S",       69.54,    0.26,    "+0.38%", "4:00 PM EST", "615.27k",              "1.10M",   "160.30B",
       "LLY",                 "Eli Lilly and Company",      160.04,   -0.96,    "-0.60%", "4:03 PM EST",   "3.44M",              "4.20M",   "153.09B",
       "AZN",                       "AstraZeneca PLC",       54.27,    0.38,    "+0.71%", "4:00 PM EST",   "3.82M",              "5.45M",   "143.11B",
       "BMY",          "Bristol-Myers Squibb Company",       60.72,    0.52,    "+0.86%", "4:00 PM EST",   "8.50M",             "10.35M",   "137.21B",
      "AMGN",                            "Amgen Inc.",       227.4,   -0.76,    "-0.33%", "4:00 PM EST",   "1.90M",              "2.59M",   "132.39B",
       "SNY",                                "Sanofi",       47.83,   -1.91,    "-3.84%", "4:00 PM EST",   "3.16M",              "1.14M",   "119.21B",
       "GSK",                   "GlaxoSmithKline plc",       37.59,   -0.38,    "-1.00%", "4:00 PM EST",   "4.23M",              "4.73M",    "94.09B",
     "GLAXF",                   "GlaxoSmithKline plc",       18.46,   -0.42,    "-2.21%", "3:06 PM EST", "677.36k",            "206.02k",    "92.94B",
      "GILD",                 "Gilead Sciences, Inc.",       60.76,    0.31,    "+0.51%", "4:00 PM EST",   "7.45M",              "9.30M",    "76.16B",
       "ZTS",                           "Zoetis Inc.",      159.53,    1.41,    "+0.89%", "4:03 PM EST",   "1.26M",              "1.72M",    "75.82B",
      "MRNA",                         "Moderna, Inc.",      156.93,    1.24,    "+0.80%", "4:00 PM EST",  "21.12M",             "16.59M",    "62.10B",
      "VRTX",   "Vertex Pharmaceuticals Incorporated",      224.17,    0.13,    "+0.06%", "4:00 PM EST",   "1.33M",              "2.08M",    "58.29B",
       "TAK", "Takeda Pharmaceutical Company Limited",       18.79,    0.01,    "+0.05%", "4:00 PM EST",   "2.11M",              "1.24M",    "58.15B",
     "BAYRY",              "Bayer Aktiengesellschaft",       14.12,   -0.27,    "-1.88%", "3:59 PM EST", "549.99k",            "772.07k",    "55.21B",
      "REGN",       "Regeneron Pharmaceuticals, Inc.",      479.77,    0.79,    "+0.16%", "4:00 PM EST", "923.01k",            "998.15k",    "51.19B",
      "BIIB",                           "Biogen Inc.",      241.43,   -1.55,    "-0.64%", "4:00 PM EST",   "1.02M",              "1.65M",    "37.15B",
      "SGEN",                           "Seagen Inc.",     191.175,    4.63,    "+2.48%", "4:00 PM EST", "724.62k",            "988.26k",    "34.22B",
      "BNTX",                           "BioNTech SE",       127.3,   -2.24,    "-1.73%", "4:00 PM EST",   "4.16M",              "3.60M",    "30.65B",
      "RPRX",                    "Royalty Pharma plc",       42.41,   -2.79,    "-6.17%", "4:00 PM EST",   "2.09M",              "1.67M",    "26.52B",
      "ALXN",         "Alexion Pharmaceuticals, Inc.",      120.98,    2.11,    "+1.78%", "4:00 PM EST",   "1.32M",              "1.84M",    "26.48B",
      "GMAB",                            "Genmab A/S",        39.1,    0.26,    "+0.67%", "4:00 PM EST", "322.13k",            "535.68k",    "25.63B",
      "CVAC",                          "CureVac N.V.",      118.08,  -10.87,    "-8.43%", "4:00 PM EST", "824.44k",            "576.38k",    "21.01B",
      "VTRS",                          "Viatris Inc.",       17.34,   -0.35,    "-1.98%", "4:00 PM EST",  "15.46M",             "10.43M",    "20.85B",
      "BGNE",                         "BeiGene, Ltd.",      228.25,     0.3,    "+0.13%", "4:00 PM EST", "486.66k",            "377.09k",    "20.23B") %>%
  janitor::clean_names()


# export ------------------------------------------------------------------

BioTechDrugStocks %>% write_csv(x = .,
                                paste0("data/",
                              noquote(lubridate::today()),
                              "-BioTechDrugStocks.csv"))
