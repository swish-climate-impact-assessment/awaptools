
################################################################
# name:get_awap_data
get_awap_data <- function(start, end, measure_i)
{
  variableslist <- variableslist()  
  variable <- variableslist[which(variableslist$measure == measure_i),]
  vname <- as.character(variable[,1])
  datelist <- seq(as.Date(start), as.Date(end), 1)
  
  for(date_i in datelist)
  {
    # date_i <- datelist[1]
    date_i <- as.Date(date_i, origin = '1970-01-01')
    sdate <- as.character(date_i)
    edate <- date_i
    
    if(!file.exists(sprintf("%s_%s%s.grid",measure_i,gsub("-","",sdate),gsub("-","",edate))))
    {
      get_data_range(variable=as.character(variable[,1]),
                     measure=as.character(variable[,2]),
                     timestep=as.character(variable[,3]),
                     startdate=as.POSIXct(sdate),
                     enddate=as.POSIXct(edate))
      
      fname <- sprintf("%s_%s%s.grid.Z",measure_i,gsub("-","",sdate),gsub("-","",edate))
      if(file.info(fname)$size == 0)
      {
        file.remove(fname)
        next
      }
      os <- LinuxOperatingSystem()
      if(os)
      {
        uncompress_linux(filename = fname)
      } else {
        Decompress7Zip(zipFileName= fname, outputDirectory=getwd(), TRUE)
      }
    }
  }
  
}
