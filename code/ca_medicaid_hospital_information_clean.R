# Reads in and writes out hospital information for medicaid data

# Source: https://data.medicare.gov/data/hospital-compare

# Author: Karina
# Version: 2019-05-14

# Libraries
library(tidyverse)
library(ggmap)


#Input File
file_raw <- here::here("data-raw/Hospital_General Information.csv")

# Output file
file_ca_out <- here::here("data/ca_hospital_general_info.rds")

# register_google(key = "[KEY HERE]", write = TRUE)

#===============================================================================


hospital_info <- 
  read_csv(file_raw) %>% 
  mutate_at(vars(Address, City), str_to_title) %>%
  filter(State == "CA") %>% 
  unite(col = full_address, Address, City, State, `ZIP Code`, sep = " ", remove = FALSE) %>%
  pull(full_address) %>%
  map_dfr( ~ geocode(., output = "latlona", source = "google")) %>%
  bind_cols(hospital_info) %>%
  write_rds(file_ca_out)