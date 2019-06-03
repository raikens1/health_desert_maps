## My harddrive (Harddrive = Qi Lab scSeq+CyTOF Drive)
setwd("E:/BMI_212/")

## Load Data from curation
Aim2Data <- read.csv("Aim2Data.csv")


## 

Fit2Outcome <- function(Data, Parameter){
  Socioecon <- "Employment + MHI + Poverty + MHV + HS + College + Native + Foreign + Age + White + Black + AIAN + Asian + NHPI + Latino + ALAND"
  CitiesParams <- c("Annual.Checkup", "Arthritis", "Binge.Drinking", "Cancer..except.skin.", "Cholesterol.Screening",
                    "Chronic.Kidney.Disease", "Colorectal.Cancer.Screening", "COPD", "Core.preventive.services.for.older.men",
                    "Core.preventive.services.for.older.women", "Coronary.Heart.Disease", "Current.Asthma", "Current.Smoking",
                    "Dental.Visit", "Diabetes", "Health.Insurance", "High.Blood.Pressure", "High.Cholesterol", "Mammography",
                    "Mental.Health", "Obesity", "Pap.Smear.Test", "Physical.Health", "Physical.Inactivity", "Sleep..7.hours", 
                    "Stroke", "Taking.BP.Medication", "Teeth.Loss")
  
  Coeff <- rep(0, length(CitiesParams))
  Pvals <- rep(0, length(CitiesParams))
  
  for (k in 1:length(CitiesParams)){
    Formula <- paste(CitiesParams[k], " ~ ", Parameter, " + ", Socioecon)
    Fit <- lm(formula = Formula, data = Data)
    Coeff[k] <- summary(Fit)$coefficients[Parameter,"Estimate"]
    Pvals[k] <- summary(Fit)$coefficients[Parameter,"Pr(>|t|)"]
  }
  
  Out <- data.frame(Coeffs = Coeff, Pvalues = Pvals, row.names = CitiesParams)
  write.csv(Out, file = paste("Fit_",Parameter, ".csv", sep=""))
  return(Out)
}


## Linear fits

HospitalCongested  <- Fit2Outcome(Aim2Data, "HospitalCongested")
HospitalUncogested <- Fit2Outcome(Aim2Data, "HospitalNonCongested")

PrimaryCongested  <- Fit2Outcome(Aim2Data, "PrimaryCongested")
PrimaryUncogested <- Fit2Outcome(Aim2Data, "PrimaryUncogested")

MedicareCongested  <- Fit2Outcome(Aim2Data, "MedicareCongested")
MedicareUncogested <- Fit2Outcome(Aim2Data, "MedicareNonCongested")
