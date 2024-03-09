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


# convert date and time data to date and time formats

dateTime <- strptime(paste(powerConsumptionFeb$Date, powerConsumptionFeb$Time, sep=" "), "%d/%m/%Y %H:%M:%S")
powerConsumptionFeb$Date <- as.Date(powerConsumptionFeb$Date, "%d/%m/%Y")

# create a separate column with a Date object containing information from the original Date and Time columns

powerConsumptionFeb <- cbind(dateTime, powerConsumptionFeb)


# set up the layout of the plots

par(mfrow=c(2,2),mar=c(4,4,2,1), oma=c(0, 0, 2, 0))


# Graph Global Active Power based on day/time

with (powerConsumptionFeb, 
      plot(ActivePower ~ dateTime, type="l", ylab="Global Active Power (kilowatts)", xlab="", xaxt = "n"))
with (powerConsumptionFeb,
      axis(1, las=1, at=c(min(dateTime), median(dateTime), max(dateTime)), labels = c("Thu", "Fri", "Sat")))


# Graph Voltage based on day/time

with (powerConsumptionFeb, 
      plot(Voltage ~ dateTime, type="l", xlab="datetime", xaxt = "n"))
with(powerConsumptionFeb, 
     axis(1, las=1, at=c(min(dateTime), median(dateTime), max(dateTime)), labels = c("Thu", "Fri", "Sat")))


# Graph Energy Sub metering based on day/time

with(powerConsumptionFeb, 
     plot(KitchenMetering ~ dateTime, type="l", ylab="Energy sub metering", xlab="", xaxt = "n"))
with(powerConsumptionFeb, 
     points(LaundryMetering ~ dateTime, type="l", col="red"))
with(powerConsumptionFeb, 
     points(HVACMetering ~ dateTime, type="l", col="blue"))
with(powerConsumptionFeb, 
     axis(1, las=1, at=c(min(dateTime), median(dateTime), max(dateTime)), labels = c("Thu", "Fri", "Sat")))

legendLabels = c("Sub_metering_1    ", "Sub_metering_2    ","Sub_metering_3    ")
legend_font_size <- 9
legend("topright", legend=legendLabels, lty = 1, col=c("black","red","blue"))


# Graph Global reactive power based on day/time

with (powerConsumptionFeb, 
      plot(ReactivePower ~ dateTime, ylab="Global_reactive_power", xlab="datetime", type="l", xaxt = "n"))

with(powerConsumptionFeb, 
     axis(1, las=1, at=c(min(dateTime), median(dateTime), max(dateTime)), labels = c("Thu", "Fri", "Sat")))

# save the plot to a png file

dev.copy(png, file="plot4.png", width=480, height=480)
dev.off()



