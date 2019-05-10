# Build Heatmaps

# This file should contain code that reads in a data file (csv format)
# of travel times to hospital in an area of interest
# and produce a heatmap of travel times to hospital over that area

# The input file should have rows which each represent a distinct start location
# The columns of the input file should be:
# census_tract_id: `string`
# start_longitude: `string?`
# start_latitude: `string?`
# t_1: `int` minutes to nearest hospital
# t_2: `int` minutes to second nearest hospital
# t_3: `int` minutes to third nearest hospital

# This file may have comment lines written above the data
# Comment lines all must begin with #
# The column headings will be included. This line should not start with a header

library(sf) # dependency for tmap
library(raster)
library(spData)

library(dplyr)
library(tmap)    # for static and interactive maps
library(leaflet) # for interactive maps
library(mapview) # for interactive maps
library(ggplot2) # tidyverse vis package
library(shiny)   # for web applications
library(stringr)
library(tidycensus)

census_api_key("6020dd87f4d614074553da9b317878cb026a7c88")

CA_pop <- get_acs(geography = "tract", 
                     variables = "B01003_001", 
                     state = "CA",
                     geometry = TRUE) 

CA_pop

pal <- colorQuantile(palette = "viridis", domain = CA_pop$estimate, n = 5)

CA_pop %>%
  st_transform(crs = "+init=epsg:4326") %>%
  leaflet(width = "100%") %>%
  addProviderTiles(provider = "CartoDB.Positron") %>%
  addPolygons(popup = ~ str_extract(NAME, "^([^,]*)"),
              stroke = FALSE,
              smoothFactor = 0,
              fillOpacity = 0.7,
              color = ~ pal(estimate)) %>%
  addLegend("bottomright", 
            pal = pal, 
            values = ~ estimate,
            title = "Population percentiles",
            opacity = 1)
