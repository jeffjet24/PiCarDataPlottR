library(dplyr)
library(parallel)
retrieveCarData <- function(csvPath){
  # this function reads the csv file from a given path that is passed into the
  # function. it then filters and returns the dataTable
  
  
  # loading in my car data from the output.csv file
  carData <- read.csv(csvPath, TRUE, stringsAsFactors = FALSE)
  # filtering the data set of the headers
  carData <- filter(carData, time !="time", rpm != "rpm", temp !="temp") 
  #browser()
  tempDataList <- as.list(carData)

  tempDataList <- mclapply(tempDataList, removeAllBadData, mc.cores = 8)
  carData <- as.data.frame(tempDataList, stringsAsFactors = FALSE)
  carData$speed <- carData$speed * 0.621371
  return(carData)
}

removeAllBadData <- function(dataTable){

  #for(i in 1:NCOL(dataTable)){
    for(j in 1:NROW(dataTable)){
      if(dataTable[[j]] == "BADDATA" || dataTable[[j]] == "NODATA"){
        if(j != 1 && j != NROW(dataTable)){
          # need to add a control process here to check if j-1 or j+1 is also baddata.
          dataTable[[j]] <- suppressWarnings(mean(c(as.numeric(dataTable[[j-1]]), 
                                        as.numeric(dataTable[[j+1]]))))
        }else{
          if(j == 1){
            dataTable[[j]] <- as.numeric(dataTable[[j+1]])
          }else{
            dataTable[[j]] <- as.numeric(dataTable[[j-1]])
          }
        }
      } 
    }
  #}
  dataTable[is.na(dataTable)] <- "0"
  #dataTable$speed <- as.numeric(dataTable$speed) * 0.621371 # converting km/h to mph
  dataTable <- as.numeric(dataTable)
  return(dataTable)
}


combineDataToXts <- function(dataSet){
  #browser()
  xtsData <- xts(x = dataSet[[2]], order.by = as.POSIXct(as.integer(dataSet$time), 
                                       origin = "1970-01-01"))
  #browser()
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
  xtsData <- xtsData[-(1:71),]
  #browser()
  return(xtsData)
}



