
# newnode get_data_range
# authors: Joseph Guillaume and Francis Markham
# downloads from http://www.bom.gov.au/jsp/awap/
  
get_data_range<-function(variable,measure,timestep,startdate,enddate){
  if (timestep == "daily"){
    thisdate<-startdate
    while (thisdate<=enddate){
      get_data(variable,measure,timestep,format(as.POSIXct(thisdate),"%Y%m%d"),format(as.POSIXct(thisdate),"%Y%m%d"))
      thisdate<-thisdate+as.double(as.difftime(1,units="days"),units="secs")
    }
  } else if (timestep == "month"){
    # Make sure that we go from begin of the month
    startdate <- as.POSIXlt(startdate)
    startdate$mday <- 1
    # Find the first and last day of each month overlapping our range
    data.period.start <- seq(as.Date(startdate), as.Date(enddate), by = 'month')
    data.period.end <- as.Date(sapply(data.period.start, FUN=function(x){as.character(seq(x, x + 40, by = 'month')[2] - 1)}))
    # Download them
    for (i in 1:length(data.period.start)){
      get_data(variable,measure,timestep,format(as.POSIXct(data.period.start[i]),"%Y%m%d"),format(as.POSIXct(data.period.end[i]),"%Y%m%d"))
    }
   
} else {
    stop("Unsupported timestep, only 'daily' and 'month' are currently supported")
  }
}
