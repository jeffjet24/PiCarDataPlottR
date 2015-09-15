library(dplyr)

retrieveCarData <- function(csvPath){
  # this function reads the csv file from a given path that is passed into the
  # function. it then filters and returns the dataTable
  
  
  # loading in my car data from the output.csv file
  carData <- read.csv(csvPath, TRUE, stringsAsFactors = FALSE)
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
  dataTable[is.na(dataTable)] <- "0"
  return(dataTable)
}


combineDataToXts <- function(dataSet){
  
  xtsData <- xts(x = dataSet[[2]], order.by = as.POSIXct(as.integer(dataSet$time), 
                                       origin = "1970-01-01"))

  if(NCOL(dataSet) == 2){
    colnames(xtsData) <- colnames(dataSet)[2]
  }else{
    for(i in 3:NCOL(dataSet)){
      xtsData <- cbind(xtsData, 
                       xts(x = dataSet[[i]], 
                           order.by = as.POSIXct(as.integer(dataSet$time), 
                                                 origin = "1970-01-01")))
    }
      colnames(xtsData) <- colnames(dataSet)[2:NCOL(dataSet)]
  }

  return(xtsData)
}
