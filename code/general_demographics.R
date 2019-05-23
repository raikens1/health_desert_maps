# Reads in and writes out census tract general demographics DP05

# Source: ACS survey https://factfinder.census.gov/faces/nav/jsf/pages/index.xhtml

# Author: Karina
# Version: 2019-05-21

# Libraries
library(tidyverse)


#Input File
file_raw <- here::here("data-raw/ACS_17_5YR_general_demographics.csv")

# Output file
file_out <- here::here("data/ACS_17_5YR_general_demographics.rds")

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
    -contains("ratio"), 
    -contains("error"),
    -contains("combination"),
    -matches("_\\d*$"),
    -contains("race alone"),
    -contains("Not Hispanic"),
    -contains("housing")
  ) %>% 
  gather(key = type, value = value, -Id, -Id2, -Geography) %>% 
  mutate(
    type = str_remove(type, "^([^-]*)- "),
    type = 
      case_when(
        str_detect(type, "Latino \\(of any") ~ "Hispanic or Latino",
        str_detect(type, "Two or more races") ~ "Mixed",
        str_detect(type, "Some other race") ~ "Other",
        str_detect(type, "Native Hawaiian") ~ "Pacific Islander",
        str_detect(type, "Asian") ~ "Asian",
        str_detect(type, "American Indian") ~ "Native American",
        TRUE ~ type
      )
  ) %>% 
  group_by(Id, Id2, Geography, type) %>% 
  summarize(value = sum(value, na.rm = TRUE)) %>% 
  mutate(
    value =
      if_else(
        type == "Total population",
        value / 2,
        value
      )
  ) %>% 
  drop_na(type) %>% 
  spread(key = type, value = value) %>% 
  write_rds(file_out)
