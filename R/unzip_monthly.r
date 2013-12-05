
################################################################
# name:unzip
## load(".RData")
## setwd(outdir)
## require(devtools)
## install_github("awaptools", "swish-climate-impact-assessment")
## require(awaptools)
## require(swishdbtools)
unzip_monthly <- function(filename, aggregation_factor = 1)
  {
    if(file.exists(filename))
      {
        fname <- filename
      } else {
        stop("file doesn't exist")
      }
  require(raster)
  require(swishdbtools)
  os <- LinuxOperatingSystem()



   if(os)
     {
       uncompress_linux(filename = fname)
     } else {
       Decompress7Zip(zipFileName= fname, outputDirectory=getwd(), TRUE)
     }

     #raster_aggregate(filename = gsub('.Z$','',fname),
     #  aggregationfactor = aggregation_factor, delete = TRUE)
     

  }
