# Health Desert Maps

**Authors:** Rachael C. "Rocky" Aikens, Michael Chavez, Elizabeth Chin, Benjamin Huynh, Karina Samuel-Gama

## Author Contributions

The `code` directory contains all of the scripts that were used to generate the data, figures, and vizualization tool for this project.  Attributions are as follows:

- Aim1_analyses.Rmd - RA
- Aim2Outcome.R - MC
- Aim2_Curate.R - MC
- Aim2_Socioecon.R - MC
- Heatmap_gallery.Rmd - RA and EC
- build_heatmaps.R - RA
- build_interactive.R - EC
- ca_medicaid_hospital_information_clean.R - KSG
- economic_characteristics.R - KSG
- general_demographics.R - KSG
- medicareDataClean.R - BH
- hospitalDataClean.R - BH
- primaryCareDataClean.R - BH
- query_maps.py - LC
- safetynetDataClean - BH

Broadly, RA wrote on the code for producing basic heatmaps and produced the Aim 1 results; MC completed Aim 2 and also prepared outcome data; EC built the interactive heatmaps and wrote the script to query gooogle maps; BH prepared the hospital and census tract geolocation data; and KSG prepared demographic and socioeconomic data for Aim 2 and cleaned the medicare hospitals data.

Querying Google Maps was the joint effort of all team members.  All group members were full contibutors and their work was essential to making this project a success.  We would also like to give a special thanks to the friends and family who contributed their Google Cloud Project credits to make this project possible.

## Purpose

A _healthcare dessert_ is a region where individuals have poor access to care.  Sometimes, it's defined as a populated region more than 60 minutes from an acute care hospital.  Realistically, every individual has their own level of difficulty reaching different types of care that they may need based.  This may be a result of their living situation, their insurance, their personal transportation, and other factors.  Our goal is to use a combination a data sources, together with time-to-destination estimates from Google Maps to vizualize how dificult it is for Americans to reach a care center they need, and understand the correllates of this distance-to-care.

## Project Breakdown

We will complete the following aims, which will probably overlap in many places. 

_Each of these aims has an associated Project Board, where we can track goals and progress_

### 1.  Design a Pipeline to Generate Heat Maps of Travel Time to Hospital
The maps [here](https://medium.com/@sohanmurthy/visualizing-americas-health-care-deserts-675f4502c4e1) are a basic start for a visualization like this, but we can take this to the next level by using true travel times from Google Maps, correcting for population density, and tinkering with other parameters like traffic and public transit.

### 2. Understand the Factors Correlated with Time-to-Hospital
 - **2a** We would like to understand how demographic and socioeconomic factors are associated with travel time to hospital, to better understand the populations affected by healthcare deserts.  
 - **2b** We would also like to understand the association between time-to-hospital and health outcomes.

### 3. Predict the Effects of Hospital Closures
Using the pipeline from aim 1, we can model the potential effects of hospital openings and closures.  This can help us to model the short-term effects of the temporary closures which occur when hospitals reach capacity, or the long-term effects of closures of specific care centers, such as Safety Net Hospitals.

