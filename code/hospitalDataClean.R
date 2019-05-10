library(readr)
library(dplyr)
hosp17_util_data_final <- read_csv("~/Downloads/hosp17_util_data_final.csv")
hospClean <- hosp17_util_data_final %>%
  select(FAC_NAME,FAC_ADDRESS_ONE,LATITUDE,LONGITUDE,COUNTY,TYPE_LIC,CENS_TRACT,FAC_CITY,TYPE_SVC_PRINCIPAL)
hospClean <- hospClean[-(1:3),]
library(sf)
shape <- read_sf(dsn = "./tl_2017_06_tract", layer = "tl_2017_06_tract")

#geoid is the unique identifier

library(rdist)

coordMat1 <- hospClean %>% select(FAC_NAME,LATITUDE,LONGITUDE)
coordMat1$LATITUDE <- as.numeric(coordMat1$LATITUDE)
coordMat1$LONGITUDE <- as.numeric(coordMat1$LONGITUDE)
coordMat2 <- shape %>% as.data.frame() %>%  select(GEOID,INTPTLAT,INTPTLON) 
coordMat2$INTPTLAT <- as.numeric(coordMat2$INTPTLAT)
coordMat2$INTPTLON <- as.numeric(coordMat2$INTPTLON)
distances <- cdist(coordMat1,coordMat2)
rownames(distances) <- hospClean$FAC_NAME
colnames(distances) <- shape$GEOID

library(reshape)
distanceDF <- melt(distances)[melt(upper.tri(distances))$value,]
colnames(distanceDF) <- c("Hospital","CensusTractGEOID","Distance")

distanceDF$hospLat <- hospClean$LATITUDE[hospClean$FAC_NAME==distanceDF$Hospital]
