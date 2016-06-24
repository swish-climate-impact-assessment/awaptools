awaptools
=========



[![Travis Build Status](https://travis-ci.org/swish-climate-impact-assessment/awaptools.png?branch=develop)](https://travis-ci.org/swish-climate-impact-assessment/awaptools)
[![AppVeyor Build Status](https://img.shields.io/appveyor/ci/ivanhanigan/awaptools/master.svg?label=Windows)](https://ci.appveyor.com/project/ivanhanigan/awaptools)
[![Coverage Status](https://codecov.io/github/swish-climate-impact-assessment/awaptools/coverage.svg?branch=master)](https://codecov.io/github/swish-climate-impact-assessment/awaptools?branch=master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/awaptools)](http://cran.r-project.org/package=awaptools)

- Author: ivanhanigan, J. Guillaume, F. Markham, G. Williamson, I. Szarka, Jeffrey O. Hanson, Adam H. Sparks
- Maintainer: <ivan.hanigan@gmail.com>
- Depends: raster, sp
- License: GPL (>= 2)
  
# Source data information

- The Bureau of Meteorology has generated a range of gridded meteorological datasets for Australia as a contribution to the Australian Water Availability Project (AWAP). 
- An R package to download and format the AWAP grids.
- Binaries available from [http://swish-climate-impact-assessment.github.com/tools.html](http://swish-climate-impact-assessment.github.com/tools)
- More info is available [http://www.bom.gov.au/jsp/awap/](http://www.bom.gov.au/jsp/awap/)
- The documentation of the data creation is at [http://www.bom.gov.au/amm/docs/2009/jones.pdf](http://www.bom.gov.au/amm/docs/2009/jones.pdf)

# R-Code: A workflow to download and process the public BoM weather grids.

### Step 1 download, unzip and compress grids
```r
# This workflow uses the open source R software with some of our custom written packages:
# aim daily weather for any point location from online BoM weather grids
# depends on some github packages, either use devtools
install.packages("githubinstall")
library(githubinstall)
githubinstall("awaptools")

# OR download and install
# http://swish-climate-impact-assessment.github.io/tools/awaptools/awaptools-downloads.html

# Basic usage
library(awaptools)
library(raster)
# get weather data, beware that each grid is a couple of megabytes
vars <- c("maxave","minave","totals","vprph09","vprph15") #,"solarave") 
# solar only available after 1990
for(measure in vars)
{
  #measure <- vars[1]
  get_awap_data(start = '2016-03-04',end = '2016-03-06', measure)
}
compress_gtifs(indir = getwd())
```
### Step 2: Extract a time series of weather data for my locations
```r
datadir <- "GTif"
library(rgdal)
library(plyr)
library(reshape) 
library(ggmap)
 
# get location
address2 <- c("1 Lineaus way acton canberra", "daintree forest queensland", "hobart",
              "bourke")
locn <- geocode(address2)

# this uses google maps API, better check this
locn

## Treat data frame as spatial points
epsg <- make_EPSG()
shp <- SpatialPointsDataFrame(cbind(locn$lon,locn$lat),data.frame(address = address2, locn),
                              proj4string=CRS(epsg$prj4[epsg$code %in% '4283']))

# TODO make this extraction a function, and optimise with raster package things like stack and brick
# now loop over grids and extract met data
cfiles <-  dir(datadir, pattern=".tif$",  full.names = T)
 
for (i in seq_len(length(cfiles))) {
  #i <- 1 ## for stepping thru
  gridname <- cfiles[[i]]
  r <- raster(gridname)
  #image(r) # plot to look at
  e <- extract(r, shp, df=T)
  #str(e) ## print for debugging
  e1 <- shp
  e1@data$values <- e[,2]
  e1@data$gridname <- gridname
  # write to to target file
  write.table(e1@data,"output.csv",
    col.names = i == 1, append = i>1 , sep = ",", row.names = FALSE)
}
# further work is required to format the column with the gridname to get out the date and weather paramaters.

dat <- read.csv("output.csv", stringsAsFactors = F)
head(dat)
dat$date <- matrix(unlist(strsplit(dat$gridname, "_")), ncol = 3, byrow=TRUE)[,3]
dat$date <- paste(substr(dat$date,1,4), substr(dat$date,5,6), substr(dat$date,7,8), sep = "-")
dat$measure <- matrix(unlist(strsplit(dat$gridname, "_")), ncol = 3, byrow=TRUE)[,2]



dat <- arrange(dat[,c("address", "lon", "lat", "date", "measure", "values")], address, date, measure)
head(dat)

dat2 <- cast(dat, address +    lon     +  lat    +   date ~ measure, value = 'values',
      fun.aggregate= 'mean')
dat2

"
                      address       date maxave minave totals vprph09 vprph15
 1 Lineaus way acton canberra 2016-03-04  32.55  15.10    8.3   17.49   13.92
 1 Lineaus way acton canberra 2016-03-05  35.04  15.24    0.0   16.28   13.18
 1 Lineaus way acton canberra 2016-03-06  33.93  15.36    0.8   16.25    7.74
 1 Lineaus way acton canberra 2016-03-07  35.03  15.27    0.0   16.08   11.77
 1 Lineaus way acton canberra 2016-03-08  32.48  15.88    0.0   16.06   12.39
 1 Lineaus way acton canberra 2016-03-09  33.35  13.66    0.0   18.11   14.55
                       bourke 2016-03-04  39.02  25.97    0.1   14.09   12.43
                       bourke 2016-03-05  38.89  22.16    0.0   15.94   12.02
                       bourke 2016-03-06  38.36  21.83    0.0   12.80   11.31
                       bourke 2016-03-07  38.14  22.08    0.0   14.24   12.92
                       bourke 2016-03-08  38.25  22.30    0.0   14.03   12.76
                       bourke 2016-03-09  37.68  23.05    0.0   17.72   13.04
   daintree forest queensland 2016-03-04  28.72  23.79   86.0   31.21   29.34
   daintree forest queensland 2016-03-05  29.29  24.53   56.1   29.93   30.62
   daintree forest queensland 2016-03-06  31.47  24.98   18.4   31.84   30.43
   daintree forest queensland 2016-03-07  31.74  24.34    5.7   31.25   31.85
   daintree forest queensland 2016-03-08  30.98  24.72   26.7   31.74   32.20
   daintree forest queensland 2016-03-09  31.76  25.54    2.6   32.16   31.35
                       hobart 2016-03-04  24.83  13.95    0.0   14.97   15.15
                       hobart 2016-03-05  25.60  13.47    0.0   13.58   13.27
                       hobart 2016-03-06  23.62  15.34    0.2   15.73   14.63
                       hobart 2016-03-07  22.14  16.05    2.6   15.79   13.68
                       hobart 2016-03-08  24.22  13.69    0.3   12.60   15.18
                       hobart 2016-03-09  26.73  15.16    1.2   19.21   14.87
"

png(sprintf("%s-test.png", gridname))
plot(r)
plot(shp, add = T)
title(gridname)
dev.off()

```

![tests/vprph15_2016030620160306.grid-test.png](tests/vprph15_2016030620160306.grid-test.png)


```r
# most data are available since 1950
vars <- c("maxave","minave","totals","vprph09","vprph15") #,"solarave") 
# solar only available after 1990
for(measure in vars)
{
  #measure <- vars[1]
  get_awap_data(start = '1950-01-01',end = '1950-01-01', measure)
}

# rainfall since 1900
measure <- "totals"
get_awap_data(start = '1900-01-01',end = '1900-01-01', measure)

#...


```
