library(shiny)
library(dygraphs)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Car Data Logger"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      dateRangeInput('dateRange', "Pick the Range of Dates you would like to 
                     look at!", start = "1999-12-28", end = "2000-01-28")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      dygraphOutput("speedPlot"),
      dygraphOutput("rpmPlot"),
      dygraphOutput("tempPlot"),
      dygraphOutput("fuelTrimPlot"),
      dygraphOutput("mafLoadPlot")
    )
  )
))
