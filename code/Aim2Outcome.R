######################
##  Michael Chavez  ##
######################

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
  Rsq   <- rep(0, length(CitiesParams))
  
  for (k in 1:length(CitiesParams)){
    Formula <- paste(CitiesParams[k], " ~ ", Parameter, " + ", Socioecon)
    Fit <- lm(formula = Formula, data = Data)
    Coeff[k] <- summary(Fit)$coefficients[Parameter,"Estimate"]
    Pvals[k] <- summary(Fit)$coefficients[Parameter,"Pr(>|t|)"]
    Rsq[k]   <- summary(Fit)$adj.r.squared
  }
  
  Out <- data.frame(Coeffs = Coeff, Pvalues = Pvals, Rsq = Rsq, row.names = CitiesParams)
  write.csv(Out, file = paste("Fit_",Parameter, ".csv", sep=""))
  return(Out)
}


## Linear fits

HospitalCongested  <- Fit2Outcome(Aim2Data, "HospitalCongested")
HospitalUncogested <- Fit2Outcome(Aim2Data, "HospitalNonCongested")
HospitalDistance <- Fit2Outcome(Aim2Data, "HostpitalDistance")

PrimaryCongested  <- Fit2Outcome(Aim2Data, "PrimaryCongested")
PrimaryUncogested <- Fit2Outcome(Aim2Data, "PrimaryUncogested")
PrimaryDistance  <- Fit2Outcome(Aim2Data, "PrimaryDistance")

MedicareCongested  <- Fit2Outcome(Aim2Data, "MedicareCongested")
MedicareUncogested <- Fit2Outcome(Aim2Data, "MedicareNonCongested")
MedicareDistance  <- Fit2Outcome(Aim2Data, "MedicareDistance")

SafetyCongested  <- Fit2Outcome(Aim2Data, "SafetynetCongested")
SafetyUncogested <- Fit2Outcome(Aim2Data, "SafetynetUncongested")
SafetyDistance  <- Fit2Outcome(Aim2Data, "SafetyDistance")

## For plotting

Kidney <- c(HospitalCongested["Chronic.Kidney.Disease","Rsq"],
            HospitalDistance["Chronic.Kidney.Disease","Rsq"],
            PrimaryCongested["Chronic.Kidney.Disease","Rsq"],
            PrimaryDistance["Chronic.Kidney.Disease","Rsq"],
            MedicareCongested["Chronic.Kidney.Disease","Rsq"],
            MedicareDistance["Chronic.Kidney.Disease","Rsq"],
            SafetyCongested["Chronic.Kidney.Disease","Rsq"],
            SafetyDistance["Chronic.Kidney.Disease","Rsq"])

Mammography <- c(HospitalCongested["Mammography","Rsq"],
            HospitalDistance["Mammography","Rsq"],
            PrimaryCongested["Mammography","Rsq"],
            PrimaryDistance["Mammography","Rsq"],
            MedicareCongested["Mammography","Rsq"],
            MedicareDistance["Mammography","Rsq"],
            SafetyCongested["Mammography","Rsq"],
            SafetyDistance["Mammography","Rsq"])


