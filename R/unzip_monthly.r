
################################################################
# name:unzip
## load(".RData")
## setwd(outdir)
## require(devtools)
## install_github("awaptools", "swish-climate-impact-assessment")
## require(awaptools)
## require(swishdbtools)
unzip_monthly <- function(aggregation_factor = 1)
  {
  require(raster)
  require(swishdbtools)
  os <- LinuxOperatingSystem()


  filelist <- dir(pattern = "grid.Z$")
  for(fname in filelist)
    {
        if(os)
          {
            uncompress_linux(filename = fname)
          } else {
            Decompress7Zip(zipFileName= fname, outputDirectory=getwd(), TRUE)
          }

        raster_aggregate(filename = gsub('.Z$','',fname),
          aggregationfactor = aggregation_factor, delete = TRUE)
     }
  }
