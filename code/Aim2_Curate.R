######################
##  Michael Chavez  ##
######################

## My harddrive (Harddrive = Qi Lab scSeq+CyTOF Drive)
setwd("E:/BMI_212/")
library(reshape2)
library(dplyr)
library(sf)

## Load travel times data
Hospital_con <- read.csv("map_times_hosptials_congested.csv")
Hospital_non <- read.csv("map_times_hosptials_noncongested.csv")
Primary_con  <- read.csv("map_times_primaryCare_congested.csv")
Primary_non  <- read.csv("mapTimes_primaryCare_noncongested.csv")
Medicare_con <- read.csv("map_times_medicare_congested.csv")
Medicare_non <- read.csv("map_times_medicare_noncongested.csv")
Safetynet_con <- read.csv("safetynetTimesCongestedFinalFinalFinalVersion2EditFinal.csv")
Safetynet_non <- read.csv("map_times_safetynet_noncongested.csv")

## Find minimum travel times

Hospital_con_min <- apply(Hospital_con[,19:21], 1, FUN=min, na.rm=TRUE)
Hospital_non_min <- apply(Hospital_non[,19:21], 1, FUN=min, na.rm=TRUE)
Primary_con_min  <- apply(Primary_con[,19:21] , 1, FUN=min, na.rm=TRUE)
Primary_non_min  <- apply(Primary_non[,19:21] , 1, FUN=min, na.rm=TRUE)
Medicare_con_min <- apply(Medicare_con[,19:21], 1, FUN=min, na.rm=TRUE)
Medicare_non_min <- apply(Medicare_non[,19:21], 1, FUN=min, na.rm=TRUE)
Safety_con_min   <- apply(Safetynet_con[,19:21], 1, FUN=min, na.rm=TRUE)
Safety_non_min   <- apply(Safetynet_non[,19:21], 1, FUN=min, na.rm=TRUE)

## Add NA values to where the API gapped

Hospital_con_min[Hospital_con_min == Inf] <- NA
Hospital_non_min[Hospital_non_min == Inf] <- NA
Primary_con_min[Primary_con_min == Inf]   <- NA
Primary_non_min[Primary_non_min == Inf]   <- NA
Medicare_non_min[Medicare_non_min == Inf] <- NA
Medicare_con_min[Medicare_con_min == Inf] <- NA
Safety_con_min[Safety_con_min == Inf] <- NA
Safety_non_min[Safety_non_min == Inf] <- NA

## Bring it in

Aim2Data <- data.frame(GEOID                = Hospital_con$GEOID,
                       HospitalCongested    = Hospital_con_min,
                       HospitalNonCongested = Hospital_non_min,
                       PrimaryCongested     = Primary_con_min,
                       PrimaryUncogested    = Primary_non_min,
                       MedicareCongested    = Medicare_con_min,
                       MedicareNonCongested = Medicare_non_min,
                       HostpitalDistance    = Hospital_con$Dist_1,
                       MedicareDistance     = Medicare_con$Dist_1,
                       PrimaryDistance      = Primary_con$Dist_1,
                       SafetyDistance       = Safetynet_con$Dist_1,
                       SafetynetCongested   = Safety_con_min,
                       SafetynetUncongested = Safety_non_min)

## Load 500 Citites Data
## Remove lines that are 1) Not in CA 2) city level and not tract level
## Cast remaining as table with tract ID on row, measure on column, value on entry (use mean)

CitiesData <- read.csv("500_Cities__Local_Data_for_Better_Health__2018_release.csv")
CitiesData <- CitiesData[CitiesData$StateAbbr == "CA" & CitiesData$GeographicLevel == "Census Tract",]
CitiesCurate <- dcast(CitiesData, TractFIPS~Short_Question_Text, value.var = "Data_Value", fun.aggregate = mean, na.rm = T)

## Merge the outcomes data with the travel data
Aim2Data <- merge(Aim2Data,CitiesCurate, by.x = "GEOID", by.y = "TractFIPS", all.x = T)

## Pull census data and grab specific columns
Economics <- read.csv("ACS_17_5YR_economic_characteristics.csv")
Economics <- Economics[grep("California", Economics$GEO.display.label), c(2,10,252,478)]
colnames(Economics) <- c("GEO", "Employment", "MHI", "Poverty")

Housing   <- read.csv("ACS_17_5YR_housing_characteristics.csv")
Housing   <- Housing[grep("California", Housing$GEO.display.label), c(2,36)]
colnames(Housing) <- c("GEO", "MHV")

Social    <- read.csv("ACS_17_5YR_social_characteristics.csv")
Social    <- Social[grep("California", Social$GEO.display.label), c(2,266,270,350,370)]
colnames(Social) <- c("GEO",  "HS", "College", "Native", "Foreign")

General   <- read.csv("ACS_17_5YR_general_demographics.csv")
General   <- General[grep("California", General$GEO.display.label), c(2,72,150,154,158,178,210,286)]
colnames(General) <- c("GEO", "Age", "White", "Black", "AIAN", "Asian", "NHPI", "Latino")

CensusData <- merge(Economics,  Housing, by = "GEO")
CensusData <- merge(CensusData, Social,  by = "GEO")
CensusData <- merge(CensusData, General, by = "GEO")
CensusData$GEO <- as.numeric(paste(CensusData$GEO))

## Add Area

shape <- read_sf(dsn = "tl_2017_06_tract", layer = "tl_2017_06_tract")
shape <- data.frame(shape$ALAND, shape$GEOID)
colnames(shape) <- c("ALAND", "GEOID")
shape$GEOID <- as.numeric(paste(shape$GEOID))


## MERGE
Aim2Data <- merge(Aim2Data,CensusData, by.x = "GEOID", by.y = "GEO")
Aim2Data <- mutate_all(Aim2Data, function(x) as.numeric(as.character(x)))
Aim2Data <- merge(Aim2Data, shape, by = "GEOID")
write.csv(Aim2Data, file = "Aim2Data.csv")

