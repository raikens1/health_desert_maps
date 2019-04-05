# Health Desert Maps

**Authors:** Rachael C. "Rocky" Aikens, Benjamin Huynh, Elizabeth Chin, ksamuelg (full name?) and mgchavez(full name?)

## Purpose

A _healthcare dessert_ is a region where individuals have poor access to care.  Sometimes, it's defined as a populated region more than 60 minutes from an acute care hospital.  Realistically, every individual has their own level of difficulty reaching different types of care that they may need based.  This may be a result of their living situation, their insurance, their personal transportation, and other factors.  Our goal is to use a combination a data sources, together with time-to-destination estimates from Google Maps to vizualize how dificult it is for Americans to reach a care center they need, and understand the correllates of this distance-to-care.

## Project Breakdown

We can start with the following two aims, which will probably overlap in many places:

### 1.  Design a Pipeline to Generate Heat Maps of Travel time to Hospital
The maps [here](https://medium.com/@sohanmurthy/visualizing-americas-health-care-deserts-675f4502c4e1) are a basic start for a visualization like this, but we can take this to the next level by using true travel times from Google Maps, correcting for population density, and tinkering with other parameters like traffic and public transit.

### 2. Understand the Factors Correllated with Time-to-Hospital
We would like to understand how demographic and socioeconomic factors are associated with travel time to hospital, to better understand the populations affected by healthcare deserts.  If possible, we would also like to understand the association between time-to-hospital and health outcomes.
