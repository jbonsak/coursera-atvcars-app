#### Prerequisites ####
library(dplyr) # filter(), select()
library(tidyr) # separate()


#### Download data ####

#setwd("H:/My Documents/RStudio work directory/coursera-atvcars-app")

if (!file.exists("./data")) { # Create data folder if not already done
        dir.create("./data") 
        } 

url = "https://www.fueleconomy.gov/feg/epadata/vehicles.csv.zip?accessType=DOWNLOAD"

destfile = file.path( "./data" , "vehicles.csv.zip" )

if (!file.exists(destfile)) { # Download zipped file if it is not already done
        download.file( url = url, 
                       destfile = destfile, 
                       mode = "wb") # Windows. Other OS may use method=curl
} 

unpackedfile <- file.path("./data" , "vehicles.csv")

if (!file.exists(unpackedfile)) { # Unzip it if is not already done
        unzip(destfile, exdir='./data')  
}


#### Read data into R and subset ####

vehicles <- read.csv(unpackedfile)  # 36910 obs of 83 variables

# Subset rows: Just look at newer advanced technology cars with electric motors 
elcars.rows <- filter(vehicles, year >= 2010 & 
                              !is.na(evMotor) & 
                              evMotor != '' &
                              atvType %in% c('EV', 'Hybrid', 'Plug-in Hybrid'))

# Subset cols: Limit to some columns relevant for these car types
elcars <- select(elcars.rows, one_of(c('id', 'youSaveSpend', 'fuelCost08', 'year','make', 'model','atvType',
                                       'drive','VClass','evMotor')))


#### Prepare columns

# Merge 4-wheel and All-wheel to just All-wheel in drive
elcars$drive[elcars$drive =='4-Wheel Drive'] <- 'All-Wheel Drive' 

# VClass contains 2wd and 4wd which duplicates the information found in drive
elcars$VClass <- gsub(" - 2WD", "", elcars$VClass)
elcars$VClass <- gsub(" - 4WD", "", elcars$VClass)
elcars$VClass <- gsub(" 2WD", "", elcars$VClass)
elcars$VClass <- gsub(" 4WD", "", elcars$VClass)

# Attempt to extract numeric power indicator from $evMotor
# Split voltage and battery types for hybrid cars
elcars <- separate(data=elcars, col=evMotor, sep="V", into=c("evMotor1","evMotor2"), remove=FALSE,extra="merge")
elcars$evMotorBatterySize <- as.numeric(elcars$evMotor1) # Ignoring the warning NAs introduced by coercion
elcars$evMotorBatteryType <- gsub(" ","",elcars$evMotor2) # Lithium-ion or Nickel Metal Hybrid batteries
elcars$evMotorBatterySize[elcars$id == 35841] <- 480 # LaFerrari Hybrid...
elcars$evMotor1[elcars$evMotorBatterySize > 0] <- NA
elcars$evMotor2 <- NA

# Split kilowattage and other text for electric cars
elcars$evMotor1 <- gsub("kW"," kW", elcars$evMotor1)
elcars <- separate(data=elcars, col=evMotor1, sep=" ", into=c("evMotor3","evMotor4"), remove=FALSE,extra="merge")
elcars$evMotorElKW <- as.numeric(elcars$evMotor3)
elcars <- select(elcars, -c(evMotor1, evMotor2, evMotor3, evMotor4))

# Try to fix the number manually for some of the identified vehicles with front and rear motors
# This is far from accurate science - it's just for demo purposes!
elcars$evMotorElKW[elcars$id == 32516] <- 300 # Fisker Karma...
elcars$evMotorElKW[elcars$id == 37224] <- 34+65 # Volvo XC90 PHEV
elcars$evMotorElKW[elcars$id == 36863] <- 87 # Chevy Volt 
elcars$evMotorElKW[elcars$id %in% c(36862, 37131)] <- 135 # Caddilac EVR
elcars$evMotorElKW[elcars$id == 36980] <- 375 # Tesla X
elcars$evMotorElKW[elcars$id %in% c(36008, 36787, 35994)] <- 350 # Tesla S

# Save as comma separated text file
write.csv(elcars, file = "./data/elcars.csv",row.names=FALSE)








