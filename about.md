---
title: "ATV Cars Application"
author: "jbonsak"
date: "23. January 2016"
output: html_document
---
**Context**   
I made this Shiny Application as the course project in the course "Developing Data Products" delivered through [coursera](https://www.coursera.org/) by Johns Hopkins University.
   
   
**Scope**   
While we're [waiting for hydrogen/fuel cell cars](http://www.hyfive.eu/), I thought a closer look at electric, hybrid and plug-in hybrid cars was about time. Here you can play with some data for such vehicle models from 2010 through 2016.
  
  
**Source data**  
The data was kindly provided by [fueleconomy.gov](http://www.fueleconomy.gov) in the file [vehicles.csv](https://www.fueleconomy.gov/feg/epadata/vehicles.csv.zip). I filtered it to only show electric cars [EV's](https://en.wikipedia.org/wiki/Electric_vehicle), plug-in hybrid cars and hybrid cars. A few of the available columns were chosen. Lastly, from the variable `evMotor` I made a simple attempt at extracting battery size and type for hybrid cars, plus motor kilo wattage from EVs. Some [cars' power may be misrepresented](http://www.hybridcars.com/what-is-the-actual-overall-horsepower-rating-for-the-tesla-p85d/) by this, eg. when they have more than one electric motor. You can find my code for downloading and preparing the data at [github/jbonsak/coursera-atvcars-app](https://github.com/jbonsak/coursera-atvcars-app).

The `youSaveSpend` variable is directy from fueleconomy.gov, and is their representation of how much you save or spend extra on a given car over a 5 year period, compaired against an average car. 
  
  
**Instructions**  
Just change the selection boxes, sliders and check boxes, and the plots, images and prediction outputs should react to every change. The `Data` tab provides the standard `dataTableOutput()` user interface for you to play with the data excerpt.

What happens in the prediction? Just a basic linear regression between `youSaveSpend` and `year + evMotorBatterySize + evMotorBatteryType`for hybrids. And between `youSaveSpend` and `atvType + year + evMotorElKW`for EVs and plug-in hybrids. The images shown are just three random cars for each of the two prediction models, but related to the kW or battery size you select.
  
  
**Ideas**  
Ideas for further investigation in car development: More comparable measures, maybe linked to capacitance-voltage, and ultimately the cars' lifetime environmental footprint. 

BTW: If a peer evaluating this has any idea how to simply reset Shiny action buttons once pressed, apart from pressing the other button, I would appreciate a hint very much. I couldn't figure that out without writing way too much code. Any other tips for better coding are of course also very welcome. Thanks!

/John Bonsak, January 2016

