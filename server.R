library(shiny)
library(dplyr)
library(dygraphs)
library(xts)
source("helper.R")
# Define server logic for the shiny application
shinyServer(function(input, output) {
  
  # getting the car Data
  carData <- retrieveCarData("/var/dataLogging/output.csv")
  # carData <- retrieveCarData("output.csv") # for local programming
  #browser()
  mafLoadSet <- select(carData, time = time, MAF = maf, Load = load)
  fuelTrimSet <- select(carData, time = time,
                                 ShortTrim1 = short_term_fuel_trim_1,
                                 LongTrim1 = long_term_fuel_trim_1,
                                 ShortTrim2 = short_term_fuel_trim_2,
                                 LongTrim2 = long_term_fuel_trim_2)  
  speedSet <- select(carData, time = time, Speed = speed)
  tempSet <- select(carData, time = time, Temp = temp, IntakeTemp = intake_air_temp)
  rpmSet <- select(carData, time = time, RPM = rpm)
  
  
  speedData <- combineDataToXts(speedSet)
  rpmData <- combineDataToXts(rpmSet)
  tempData <- combineDataToXts(tempSet)
  fuelTrimData <- combineDataToXts(fuelTrimSet)
  mafLoadData <- combineDataToXts(mafLoadSet)
  
  observe({
    input$dateRange
    # plotting all the speed plots
    output$speedPlot <- renderDygraph({
      plot <- dygraph(speedData, "Speed in Km/h", xlab = "Time", 
                      ylab = "Speed in Km/h", group = "engineData") %>%
              dyAxis("y", valueRange = c(0, 200)) %>%
              dyOptions(fillGraph = TRUE)
      return(plot)
    })
    # plotting the rpm plot
    output$rpmPlot <- renderDygraph({
      plot <- dygraph(rpmData, "Rotations Per Minute", xlab = "Time", 
                      ylab = "Rotations Per Minute", group = "engineData") %>%
              dyAxis("y", valueRange = c(0, 5000))
      return(plot)
    })
    # plotting the temperature plot
    output$tempPlot <- renderDygraph({
      plot <- dygraph(tempData, "Temperature in Celsius", xlab = "Time", 
                      ylab = "Temperature in Celsius", group = "engineData")
      return(plot)
    })
    # plotting the plot for all the fuel trims
    output$fuelTrimPlot <- renderDygraph({
      plot <- dygraph(fuelTrimData, "Fuel Trim Levels", xlab = "Time", 
                      ylab = "Fuel Trim Units", group = "engineData")
      return(plot)
    })
    # plotting the maf/load plot
    output$mafLoadPlot <- renderDygraph({
      plot <- dygraph(mafLoadData, "MAF and Load", xlab = "Time", 
                      ylab = "MAF and Load", group = "engineData")
      return(plot)
    })
  })
  
})