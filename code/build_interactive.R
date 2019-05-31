# Build Interactive Heatmaps
# Author: Elizabeth Chin

# This file should contain code that reads in a data file (csv format)
# of travel times to hospital in an area of interest
# and produce a heatmap of travel times to hospital over that area

# This file may have comment lines written above the data
# Comment lines all must begin with #
# The column headings will be included. This line should not start with a header

require(stringr)
require(dplyr) 
require(ggplot2) # tidyverse vis package
require(readr)

require(sf) # dependency for maps
require(raster)
require(spData)
require(tmap)    # for static and interactive maps
require(leaflet) # for interactive maps
require(mapview) # for interactive maps
require(shiny)   # for web applications
require(ggmap)
require(tidycensus) # for census data queries

#census_api_key("6020dd87f4d614074553da9b317878cb026a7c88")

# Load data on hospitals, travel-times, and cesus tract info
#hosp_df <- read_csv("../data/hospDataClean.csv")
#travel_df <- read_csv("../data/map_times.csv")
#CA_census <- get_acs(geography = "tract", 
#                     variables = "B01003_001", 
#                     state = "CA",
#                     geometry = TRUE) %>%
#  mutate(GEOID = as.numeric(GEOID))

#' @title Make Map
#' @description Makes a leaflet map of travel time to hospital
#' @param travel_df data.frame - contains travel times from each tract to 3 nearest hospitals
#' @param hosp_df data.frame - contains hospital locations and names

IconSet <- awesomeIconList(
  "selected"= makeAwesomeIcon(icon= 'hospital', markerColor = 'red', iconColor = 'white', library = "fa"),
  "unselected" = makeAwesomeIcon(icon= 'hospital', markerColor = 'gray', iconColor = 'white', library = "fa")
)

icons <- makeIcon(
  iconUrl = "../data/marker.png",
  iconWidth = 15,
  iconHeight = 15
)

make_background <- function(CA_census, travel_df, hosp_df, title_text) {

  CA_travel <- left_join(CA_census, travel_df, by = "GEOID")
  
  pal <- colorQuantile(palette = "viridis", domain = CA_travel$min_duration, n = 10)
  
  CA_spatial <- CA_travel %>%
    st_transform(crs = "+init=epsg:4326")
  
  return(list("map" = renderLeaflet({
    leaflet(data = CA_spatial, width = "100%") %>%
      addProviderTiles(provider = "CartoDB.Positron") %>%
      addMarkers(data = hosp_df, ~LONGITUDE, ~LATITUDE, icon = icons, ~FAC_NAME, label = ~FAC_NAME) %>%
      #addAwesomeMarkers(data = hosp_df, ~LONGITUDE, ~LATITUDE, icon = IconSet["selected"], ~FAC_NAME, label = ~FAC_NAME) %>%
      addPolygons(popup = ~ str_extract(NAME, "^([^,]*)"),
                  stroke = FALSE,
                  smoothFactor = 0,
                  fillOpacity = 0.7,
                  label = ~ GEOID,
                  color = ~ pal(min_duration)) %>%
      addLegend("bottomright", 
                pal = pal, 
                values = ~ min_duration,
                title = title_text,
                opacity = 1)
    }),
  "spatial" = CA_spatial,
  "palette" = pal))
}

ui <- fluidPage(leafletOutput("map"), downloadButton('downloadData', 'Download data'))

build_heatmap <- function(CA_census, travel_df, hosp_df, title_text, output_fi){
  shinyApp(ui, 
           server = shinyServer(function(input, output) {
             #create empty vector to hold all click ids
             clicked <- reactiveValues(clickedMarker=NULL)
             
             hosp_df$FAC_NAME <- as.character(hosp_df$FAC_NAME)
             
             ## Make your initial map
             travel_df <- travel_df %>% mutate(min_duration = pmin(duration_0, duration_1, duration_2, na.rm = TRUE))
             a <- make_background(CA_census, travel_df, hosp_df, title_text)
             output$map <- a$map
             CA_spatial <- a$spatial
             pal <- a$palette
             
             CA_spatial$min_duration_og <- CA_spatial$min_duration
             
             # observe the marker click info and print to console when it is changed.
             observeEvent(input$map_marker_click,{
               clicked$clickedMarker <- input$map_marker_click
               OSHPD_ID <- hosp_df[hosp_df$FAC_NAME == clicked$clickedMarker$id,]$OSHPD_ID
               for(i in 1:3){
                 CA_spatial[[paste0("duration_",i - 1)]][CA_spatial[[paste0("OSHPDID_",i)]] == OSHPD_ID] = Inf
               }
               filtered_df <- CA_spatial %>% filter((OSHPDID_1 == OSHPD_ID) | (OSHPDID_2 == OSHPD_ID) | (OSHPDID_3 == OSHPD_ID)) %>%
                 mutate(min_duration = min(duration_0, duration_1, duration_2))
               
               leafletProxy("map") %>% removeMarker(layerId = clicked$clickedMarker$id)
               if(nrow(filtered_df) > 0) {
                 leafletProxy("map", data = filtered_df) %>%
                   addPolygons(label = ~GEOID,
                               stroke = FALSE,
                               smoothFactor = 0,
                               fillOpacity = 0.7,
                               color = ~ pal(min_duration))
               }
               
               #print(clicked$clickedMarker)
               clicked$clickedMarker <- NULL
             }
             )
             
             ##########################################################
             output$downloadData <- downloadHandler(
               filename = output_fi,
               content = function(file) {
                 CA_spatial <- CA_spatial %>% mutate(min_duration = pmin(duration_0, duration_1, duration_2, na.rm = TRUE))
                 write_csv(CA_spatial,file)
               })

           })
      )
}