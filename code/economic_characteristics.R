# Reads in and writes out census tract economic characteristics DP03

# Source: ACS survey https://factfinder.census.gov/faces/nav/jsf/pages/index.xhtml

# Author: Karina
# Version: 2019-05-21

# Libraries
library(tidyverse)

file_raw <- here::here("data-raw/ACS_17_5YR_economic_characteristics.csv")

# Output file
file_out <- here::here("data/ACS_17_5YR_economic_characteristics.rds")

#===============================================================================

file_raw %>% 
  read_csv(
    skip = 1,
    na = c("NA", "(X)", "-")
  ) %>% 
  select(
    Id, 
    Id2, 
    Geography, 
    contains("Percent"),
    -contains("Estimate"),
    -contains("ratio"), 
    -contains("error"),
    -contains("With earnings"),
    -contains("With Supplemental Security Income"),
    -contains("- Families -"),
    -contains("Nonfamily"),
    -contains("children of the")
  ) %>% 
  write_rds(file_out)