library(readr)
library(dplyr)
hosp17_util_data_final <- read_csv("~/Downloads/hosp17_util_data_final.csv")
hospClean <- hosp17_util_data_final %>%
  select(FAC_NAME,FAC_ADDRESS_ONE,LATITUDE,LONGITUDE,COUNTY,TYPE_LIC,CENS_TRACT,FAC_CITY,TYPE_SVC_PRINCIPAL)
hospClean <- hospClean[-(1:3),]
