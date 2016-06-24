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

#### R-Code: A workflow to download and process the public BoM weather grids.

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


# Extract a time series of weather data
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
