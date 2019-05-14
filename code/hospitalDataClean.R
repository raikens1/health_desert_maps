library(readr)
library(dplyr)
hosp17_util_data_final <- read_csv("../data/hosp17_util_data_final.csv")
hospClean <- hosp17_util_data_final %>%
  dplyr::select(FAC_NAME,FAC_ADDRESS_ONE,LATITUDE,LONGITUDE,COUNTY,TYPE_LIC,CENS_TRACT,FAC_CITY,TYPE_SVC_PRINCIPAL)
hospClean <- hospClean[-(c(1:3, 500)),]
write.csv(hospClean, file = "../data/hospDataClean.csv")
shape <- read_sf(dsn = "./tl_2017_06_tract", layer = "tl_2017_06_tract")

#geoid is the unique identifier

library(rdist)

coordMat1 <- hospClean %>% select(LATITUDE,LONGITUDE)
coordMat1$LATITUDE <- as.numeric(coordMat1$LATITUDE)
coordMat1$LONGITUDE <- as.numeric(coordMat1$LONGITUDE)
coordMat2 <- shape %>% as.data.frame() %>%  select(INTPTLAT,INTPTLON) 
coordMat2$INTPTLAT <- as.numeric(coordMat2$INTPTLAT)
coordMat2$INTPTLON <- as.numeric(coordMat2$INTPTLON)
distances <- cdist(coordMat1,coordMat2)
rownames(distances) <- hospClean$OSHPD_ID
colnames(distances) <- shape$GEOID

library(reshape)
distanceDF <- melt(distances)[melt(upper.tri(distances))$value,]
colnames(distanceDF) <- c("OSHPDID","CensusTractGEOID","Distance")


coordDF1 <- coordMat1
coordDF2 <- coordMat2
coordDF1$OSHPD_ID <- as.integer(hospClean$OSHPD_ID)
coordDF2$GEOID <- as.numeric(shape$GEOID)

distanceDFMerge <- left_join(distanceDF,coordDF1,by=c("OSHPDID"="OSHPD_ID"))
colnames(distanceDFMerge)[4:5] <- c("HospLat","HospLon")
distanceDFMerge <- left_join(distanceDFMerge,coordDF2,by=c("CensusTractGEOID"="GEOID"))
colnames(distanceDFMerge)[6:7] <- c("TractLat","TractLon")
