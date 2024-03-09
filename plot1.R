# Check for the raw_data directory and the existence of the file to work with
# if absent, create/download what's needed


if (!file.exists("raw_data/household_power_consumption.txt")) {
        originalDirectory = getwd()
        if (!grepl(pattern = "raw_data", getwd())){
                if (!dir.exists("raw_data")) {
                        dir.create("raw_data")
                }
                setwd("raw_data")            
                if (!file.exists("raw_data/household_power_consumption.zip")) {
                        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                        destfile = "household_power_consumption.zip", method = "auto", quiet = FALSE)
                }
        }
        unzip("household_power_consumption.zip") 
        setwd(originalDirectory)
}

# read in data, change the column headings to be easier to read/understand, and assign classes to the columns

powerConsumption <- 
        read.table("raw_data/household_power_consumption.txt", 
                   sep=";", 
                   header=TRUE, 
                   na.strings = "?",
                   col.names = c("Date", "Time", "ActivePower", "ReactivePower", "Voltage", "Intensity", "KitchenMetering", "LaundryMetering", "HVACMetering"),
                   colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric")
        )



# select only rows for Feb 1 or 2nd of 2007

powerConsumptionFeb <- powerConsumption[grepl("^(1|2).2.2007$", powerConsumption$Date), ]


# Graph Global Active Power and save it to a png file

hist(powerConsumptionFeb$ActivePower, main = "Global Active Power", xlab = "Global Active Power (kilowatts)", col="red")
dev.copy(png, file="plot1.png", width=480, height=480)
dev.off()

