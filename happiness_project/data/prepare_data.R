# prepare happiness data
library(tidyverse)
library(readxl)

happiness_orig <- read_xls("../data/WHR2018Chapter2OnlineData.xls", sheet = 1)

happiness_clean <- happiness_orig |>
  select(country = country, 
         year = year,
         happiness = `Life Ladder`,
         happiness_sd = `Standard deviation of ladder by country-year`,
         log_gdp_per_capita = `Log GDP per capita`,
         social_support = `Social support`,
         life_expectancy = `Healthy life expectancy at birth`,
         freedom_choices = `Freedom to make life choices`,
         generosity = Generosity,
         corruption = `Perceptions of corruption`,
         positive_affect = `Positive affect`,
         negative_affect = `Negative affect`,
         government_confidence = `Confidence in national government`,
         democratic_quality = `Democratic Quality`,
         delivery_quality = `Delivery Quality`,
         gini_gallup = `gini of household income reported in Gallup, by wp5-year`,
         gini_world_bank = `GINI index (World Bank estimate)`,
         gini_world_bank_average = `GINI index (World Bank estimate), average 2000-15`) |>
  # add rows for missing country-year combinations
  complete(country, year)

write_csv(happiness_clean, "happiness_data.csv")
