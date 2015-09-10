library(shiny)
library(dplyr)
library(dygraphs)
library(xts)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # loading in my car data from the output.csv file
  carData <- read.csv("output.csv", TRUE, stringsAsFactors = FALSE)
  # filtering the data set
  carData <- filter(carData, time !="time", 
                    rpm != "BADDATA", 
                    load != "BADDATA",
                    temp != "BADDATA", 
                    short_term_fuel_trim_1 != "BADDATA", 
                    long_term_fuel_trim_1 != "BADDATA", 
                    short_term_fuel_trim_2 != "BADDATA", 
                    long_term_fuel_trim_2 != "BADDATA", 
                    speed != "BADDATA", 
                    timing_advance != "BADDATA", 
                    intake_air_temp != "BADDATA", 
                    maf != "BADDATA", 
                    rpm != "NODATA", 
                    load != "NODATA",
                    temp != "NODATA", 
                    short_term_fuel_trim_1 != "NODATA", 
                    long_term_fuel_trim_1 != "NODATA", 
                    short_term_fuel_trim_2 != "NODATA", 
                    long_term_fuel_trim_2 != "NODATA", 
                    speed != "NODATA", 
                    timing_advance != "NODATA", 
                    intake_air_temp != "NODATA", 
                    maf != "NODATA" 
                    )
  mafLoadSet <- select(carData, time = time, MAF = maf, Load = load)
  fuelTrimSet <- select(carData, time = time,
                                 ShortTrim1 = short_term_fuel_trim_1,
                                 LongTrim1 = long_term_fuel_trim_1,
                                 ShortTrim2 = short_term_fuel_trim_2,
                                 LongTrim2 = long_term_fuel_trim_2)  
  speedSet <- select(carData, time = time, Speed = speed)
  speedSet <- slice(speedSet, 9:NROW(speedSet))
  speedData <- xts(x = speedSet$Speed, 
                   order.by = as.POSIXct(as.integer(speedSet$time), origin = "1960-01-01"))
  observe({
    input$dateRange
    browser()
    output$speedPlot <- renderDygraph({
      plot <- dygraph(speedData, "Speed in Km/h", xlab = "Time", 
                      ylab = "Speed in Km/h")
      return(plot)
    })
    
  })
  
})