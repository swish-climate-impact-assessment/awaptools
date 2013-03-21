
###########################################################################
# newnode: DatesUnavailable

# get the list of dates between the start and end dates that is not found in the database 
DatesUnavaliable <- function (dataBaseConnection, variableName, startDate, endDate) 
{
  ch <- dataBaseConnection
  measure_i <- variableName
  start_at <- startDate
  end_at <- endDate
  
  datelist_full <- as.data.frame(seq(as.Date(start_at),
                                     as.Date(end_at), 1))
  names(datelist_full) <- 'date'
  
  
  tbls <- pgListTables(conn=ch, schema='awap_grids', pattern = measure_i)
  #     pattern=paste(measure_i,"_", gsub("-","",sdate), sep=""))
  pattern_x <- paste(measure_i,"_",sep="")
  tbls$date <- paste(
    substr(gsub(pattern_x,"",tbls[,1]),1,4),
    substr(gsub(pattern_x,"",tbls[,1]),5,6),
    substr(gsub(pattern_x,"",tbls[,1]),7,8),
    sep="-")
  tbls$date <- as.Date(tbls$date)
  datelist <-  which(datelist_full$date %in% tbls$date)
  
  
  if(length(datelist) == 0)
  {
    datelist <- datelist_full[,]
  } else {
    datelist <- datelist_full[-datelist,]
  }
  
  
}
