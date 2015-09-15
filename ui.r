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
                     look at!", start = Sys.Date() - 30 , end = Sys.Date())
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      fluidRow(
        column(6, dygraphOutput("speedPlot")),
        column(6, dygraphOutput("rpmPlot"))
      ),
      fluidRow(
        column(6, dygraphOutput("tempPlot")),
        column(6, dygraphOutput("fuelTrimPlot"))
      ),
      dygraphOutput("mafLoadPlot")
    )
  )
))
