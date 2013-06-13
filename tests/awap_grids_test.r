# script to download awap grids
# 2013-06-13 ivanhanigan
# assumptions:
## linux has gzip and windoze has 7zip in default locations
## devtools is installed and can access Rtools, otherwise please download swish R packages from 
## http://swish-climate-impact-assessment.github.io/tools/swishdbtools/swishdbtools-downloads.html
## http://swish-climate-impact-assessment.github.io/tools/awaptools/awaptools-downloads.html

# functions
require(devtools)
install_github('awaptools','swish-climate-impact-assessment')
require(awaptools)
install_github('swishdbtools','swish-climate-impact-assessment')
require(swishdbtools)
variableslist <- variableslist()  
vars <- c("maxave","minave","totals","vprph09","vprph15","solarave")
# define awap function
get_awap_data <- function(start, end, measure_i)
{
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

# test
for(measure in vars)
{
  get_awap_data(start = '1990-01-01',end = '1990-01-01', measure)
}
fileslist <- dir(pattern="grid$")
r <- readGDAL(fname=fileslist[5])
image(r)
