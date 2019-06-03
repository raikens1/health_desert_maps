## My harddrive (Harddrive = Qi Lab scSeq+CyTOF Drive)
setwd("E:/BMI_212/")

## Load Data from curation
Aim2Data <- read.csv("Aim2Data.csv")


## cor.test requires pairwise associations
## make function to do this easily

corrSocioecon <- function(Data, Parameter, Prefix){
  
  Employment <- cor.test(Data[,Parameter], Data$Employment, method = "pearson")
  MHI        <- cor.test(Data[,Parameter], Data$MHI       , method = "pearson")
  Poverty    <- cor.test(Data[,Parameter], Data$Poverty   , method = "pearson")
  MHV        <- cor.test(Data[,Parameter], Data$MHV       , method = "pearson")
  HS         <- cor.test(Data[,Parameter], Data$HS        , method = "pearson")
  College    <- cor.test(Data[,Parameter], Data$College   , method = "pearson")
  Native     <- cor.test(Data[,Parameter], Data$Native    , method = "pearson")
  Foreign    <- cor.test(Data[,Parameter], Data$Foreign   , method = "pearson")
  Age        <- cor.test(Data[,Parameter], Data$Age       , method = "pearson")
  White      <- cor.test(Data[,Parameter], Data$White     , method = "pearson")
  Black      <- cor.test(Data[,Parameter], Data$Black     , method = "pearson")
  AIAN       <- cor.test(Data[,Parameter], Data$AIAN      , method = "pearson")
  Asian      <- cor.test(Data[,Parameter], Data$Asian     , method = "pearson")
  NHPI       <- cor.test(Data[,Parameter], Data$NHPI      , method = "pearson")
  Latino     <- cor.test(Data[,Parameter], Data$Latino    , method = "pearson")
  ALAND      <- cor.test(Data[,Parameter], Data$ALAND     , method = "pearson")
  
  
  C <- c(Employment$estimate, MHI$estimate, Poverty$estimate, MHV$estimate, HS$estimate, College$estimate, 
         Native$estimate, Foreign$estimate, Age$estimate, White$estimate, Black$estimate, AIAN$estimate, Asian$estimate, NHPI$estimate, Latino$estimate, ALAND$estimate)
  
  P <- c(Employment$p.value, MHI$p.value, Poverty$p.value, MHV$p.value, HS$p.value, College$p.value, 
         Native$p.value, Foreign$p.value, Age$p.value, White$p.value, Black$p.value, AIAN$p.value, Asian$p.value, NHPI$p.value, Latino$p.value, ALAND$p.value)
  
  
  B <- C
  B[P>0.05/length(C)] <- 0
  
  Out <- data.frame(Correlation = C, Pval = P, BonferroniCorrected = B,
                    row.names = c("Employment", "MHI", "Poverty", "MHV", "HS", "College", 
                                  "Native", "Foreign", "Age", "White", "Black", "AIAN", "Asian", "NHPI", "Latino", "ALAND"))
  
  write.csv(Out, file = paste(Prefix, Parameter, ".csv", sep = ""))
  return(Out)
  
}


## Correlations

HospitalCongested  <- corrSocioecon(Aim2Data, "HospitalCongested", "Correlations_")
HospitalUncogested <- corrSocioecon(Aim2Data, "HospitalNonCongested", "Correlations_")

PrimaryCongested  <- corrSocioecon(Aim2Data, "PrimaryCongested", "Correlations_")
PrimaryUncogested <- corrSocioecon(Aim2Data, "PrimaryUncogested", "Correlations_")

MedicareCongested  <- corrSocioecon(Aim2Data, "MedicareCongested", "Correlations_")
MedicareUncogested <- corrSocioecon(Aim2Data, "MedicareNonCongested", "Correlations_")

## Split data by rural/urban by size of census tract
## tracts in top 80% are rural

Fifths <- quantile(Aim2Data$ALAND, c(0.2, 0.4, 0.6, 0.8))
Urban  <- Aim2Data[Aim2Data$ALAND <= Fifths[4],]
Rural  <- Aim2Data[Aim2Data$ALAND >  Fifths[4],]

## Redo analysis for urban

Urban_HospitalCongested  <- corrSocioecon(Urban, "HospitalCongested", "Correlations_Urban_")
Urban_HospitalUncogested <- corrSocioecon(Urban, "HospitalNonCongested", "Correlations_Urban_")

Urban_PrimaryCongested  <- corrSocioecon(Urban, "PrimaryCongested", "Correlations_Urban_")
Urban_PrimaryUncogested <- corrSocioecon(Urban, "PrimaryUncogested", "Correlations_Urban_")

Urban_MedicareCongested  <- corrSocioecon(Urban, "MedicareCongested", "Correlations_Urban_")
Urban_MedicareUncogested <- corrSocioecon(Urban, "MedicareNonCongested", "Correlations_Urban_")

## Redo analysis for rural

Rural_HospitalCongested  <- corrSocioecon(Rural, "HospitalCongested", "Correlations_Rural_")
Rural_HospitalUncogested <- corrSocioecon(Rural, "HospitalNonCongested", "Correlations_Rural_")

Rural_PrimaryCongested  <- corrSocioecon(Rural, "PrimaryCongested", "Correlations_Rural_")
Rural_PrimaryUncogested <- corrSocioecon(Rural, "PrimaryUncogested", "Correlations_Rural_")

Rural_MedicareCongested  <- corrSocioecon(Rural, "MedicareCongested", "Correlations_Rural_")
Rural_MedicareUncogested <- corrSocioecon(Rural, "MedicareNonCongested", "Correlations_Rural_")






