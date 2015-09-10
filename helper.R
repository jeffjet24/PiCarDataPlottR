library(dplyr)

retrieveCarData <- function(csvPath){
  # this function reads the csv file from a given path that is passed into the
  # function. it then filters and returns the dataTable
  
  
  # loading in my car data from the output.csv file
  carData <- read.csv("output.csv", TRUE, stringsAsFactors = FALSE)
  # filtering the data set of the headers
  carData <- filter(carData, time !="time") 
  carData <- removeAllBadData(carData)
  return(carData)
}

removeAllBadData <- function(dataTable){

  for(i in 1:NCOL(dataTable)){
    for(j in 1:NROW(dataTable)){
      if(dataTable[[i]][[j]] == "BADDATA" || dataTable[[i]][[j]] == "NODATA"){
        if(j != 1 && j != NROW(dataTable)){
          dataTable[[i]][[j]] <- mean(c(as.numeric(dataTable[[i]][[j-1]]), 
                                        as.numeric(dataTable[[i]][[j+1]])))
        }else{
          if(j == 1){
            dataTable[[i]][[j]] <- as.numeric(dataTable[[i]][[j+1]])
          }else{
            dataTable[[i]][[j]] <- as.numeric(dataTable[[i]][[j-1]])
          }
        }
        
      } 
    }
  }
  return(dataTable)
}

