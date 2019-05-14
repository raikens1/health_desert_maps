library(readr)
library(dplyr)
hosp17_util_data_final <- read_csv("../data/hosp17_util_data_final.csv")
hospClean <- hosp17_util_data_final %>%
  dplyr::select(FAC_NAME,FAC_ADDRESS_ONE,LATITUDE,LONGITUDE,COUNTY,TYPE_LIC,CENS_TRACT,FAC_CITY,TYPE_SVC_PRINCIPAL)
hospClean <- hospClean[-(c(1:3, 500)),]
write.csv(hospClean, file = "../data/hospDataClean.csv")