library(readr)
library(dplyr)
library(sf)


# Read general Hospital data, clean it, and write it to a file
#=====================================================
hosp17_util_data_final <- read_csv("../data/hosp17_util_data_final.csv")
hospClean <- hosp17_util_data_final %>%
  dplyr::select(FAC_NAME,FAC_ADDRESS_ONE,LATITUDE,LONGITUDE,COUNTY,TYPE_LIC,CENS_TRACT,FAC_CITY,TYPE_SVC_PRINCIPAL, OSHPD_ID)
hospClean <- hospClean[-(c(1:3, 500)),]

#write.csv(hospClean, file = "../data/hospDataClean.csv", row.names = F)


# Get Geometric Distances between hospitals and census tracts
#=====================================================
shape <- read_sf(dsn = "../data/tl_2017_06_tract", layer = "tl_2017_06_tract")

#geoid is the unique identifier

library(rdist)

coordMat1 <- hospClean %>% dplyr::select(LATITUDE,LONGITUDE)
coordMat1$LATITUDE <- as.numeric(coordMat1$LATITUDE)
coordMat1$LONGITUDE <- as.numeric(coordMat1$LONGITUDE)
coordMat2 <- shape %>% as.data.frame() %>%  dplyr::select(INTPTLAT,INTPTLON) 
coordMat2$INTPTLAT <- as.numeric(coordMat2$INTPTLAT)
coordMat2$INTPTLON <- as.numeric(coordMat2$INTPTLON)

# make distance matrix between hospitals and census tract centroids
distances <- cdist(coordMat1,coordMat2)
rownames(distances) <- hospClean$OSHPD_ID
colnames(distances) <- shape$GEOID

library(reshape)
distanceDF <- melt(distances) #[melt(upper.tri(distances))$value,]
colnames(distanceDF) <- c("OSHPDID","CensusTractGEOID","Distance")

coordDF1 <- coordMat1
coordDF2 <- coordMat2
coordDF1$OSHPD_ID <- as.integer(hospClean$OSHPD_ID)
coordDF2$GEOID <- as.numeric(shape$GEOID)

distanceDFMerge <- left_join(distanceDF,coordDF1,by=c("OSHPDID"="OSHPD_ID"))
colnames(distanceDFMerge)[4:5] <- c("HospLat","HospLon")
distanceDFMerge <- left_join(distanceDFMerge,coordDF2,by=c("CensusTractGEOID"="GEOID"))
colnames(distanceDFMerge)[6:7] <- c("TractLat","TractLon")


# Reformat to show top 3 nearest Hospitals of each tract, and write to file
#=====================================================

ntracts <- dim(distances)[2]

nearest3DistanceDF <- distanceDFMerge %>% 
  group_by(CensusTractGEOID) %>% 
  top_n(3, wt = -Distance) %>%
  arrange(CensusTractGEOID, Distance)%>%
  ungroup() %>%
  mutate(GEOID = CensusTractGEOID)

# There's probably a zippy tidyr way to do this but here's what I did quick and dirty
tidyNearest3DF <- nearest3DistanceDF %>%
  group_by(GEOID, TractLat, TractLon) %>%
  summarise(OSHPDID_1 = nth(OSHPDID, 1),
            HospLat_1 = nth(HospLat, 1),
            HospLon_1 = nth(HospLon, 1),
            Dist_1 = nth(Distance, 1),
            OSHPDID_2 = nth(OSHPDID, 2),
            HospLat_2 = nth(HospLat, 2),
            HospLon_2 = nth(HospLon, 2),
            Dist_2 = nth(Distance, 2),
            OSHPDID_3 = nth(OSHPDID, 3),
            HospLat_3 = nth(HospLat, 3),
            HospLon_3 = nth(HospLon, 3),
            Dist_3 = nth(Distance, 3)) %>%
  ungroup()

write.csv(tidyNearest3DF, file = "../data/GeoDistances.csv", row.names = FALSE)
