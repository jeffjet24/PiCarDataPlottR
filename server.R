library(shiny)
library(dplyr)
library(dygraphs)
library(xts)
source("helper.R")
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # getting the car Data
  carData <- retrieveCarData("output.csv")
  mafLoadSet <- select(carData, time = time, MAF = maf, Load = load)
  fuelTrimSet <- select(carData, time = time,
                                 ShortTrim1 = short_term_fuel_trim_1,
                                 LongTrim1 = long_term_fuel_trim_1,
                                 ShortTrim2 = short_term_fuel_trim_2,
                                 LongTrim2 = long_term_fuel_trim_2)  
  speedSet <- select(carData, time = time, Speed = speed)
  speedData <- xts(x = speedSet$Speed, 
                   order.by = as.POSIXct(as.integer(speedSet$time), origin = "1970-01-01")) 
  mafLoadData <- cbind(xts(x = mafLoadSet$MAF, 
                    order.by = as.POSIXct(as.integer(mafLoadSet$time), origin = "1970-01-01")),
                 xts(x = mafLoadSet$Load, 
                     order.by = as.POSIXct(as.integer(mafLoadSet$time), origin = "1970-01-01")))
  
#   fuelTrimData <- cbind(
#                   xts(x = fuelTrimSet$ShortTrim1, 
#                    order.by = as.POSIXct(as.integer(fuelTrimSet$time), origin = "1970-01-01")), 
#                   xts(x = fuelTrimSet$LongTrim1, 
#                       order.by = as.POSIXct(as.integer(fuelTrimSet$time), origin = "1970-01-01")),
#                   xts(x = fuelTrimSet$ShortTrim2, 
#                       order.by = as.POSIXct(as.integer(fuelTrimSet$time), origin = "1970-01-01")), 
#                   xts(x = fuelTrimSet$LongTrim2, 
#                       order.by = as.POSIXct(as.integer(fuelTrimSet$time), origin = "1970-01-01"))
#   )
  observe({
    input$dateRange
    output$speedPlot <- renderDygraph({
      plot <- dygraph(speedData, "Speed in Km/h", xlab = "Time", 
                      ylab = "Speed in Km/h") %>%
              dyAxis("y", valueRange = c(0, 200))
      return(plot)
    })
    output$mafLoadPlot <- renderDygraph({
      plot <- dygraph(mafLoadData, "MAF and Load", xlab = "Time", 
                      ylab = "MAF and Load")
      return(plot)
    })
    output$fuelTrimPlot <- renderDygraph({
      plot <- dygraph(fuelTrimData, "Fuel Trim Levels", xlab = "Time", 
                      ylab = "Fuel Trim Units")
      return(plot)
    })
  })
  
})