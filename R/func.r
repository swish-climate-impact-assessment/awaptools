
# Project: AWAP_GRIDS
# Author: ivanhanigan
# Maintainer: Who to complain to <ivan.hanigan@gmail.com>

# Functions for the project
if (!require(plyr)) install.packages('plyr', repos='http://cran.csiro.au'); require(plyr)
if(!require(swishdbtools)){
if(length(grep('linux',sessionInfo()[[1]]$os)) == 1)
{
  os <- 'linux'

print('Downloading the swishdbtools package and install it.')
 download.file('http://swish-climate-impact-assessment.github.com/tools/swishdbtools/swishdbtools_1.1_R_x86_64-pc-linux-gnu.tar.gz', '~/swishdbtools_1.1_R_x86_64-pc-linux-gnu.tar.gz', mode = 'wb')
# for instance
install.packages("~/swishdbtools_1.1_R_x86_64-pc-linux-gnu.tar.gz", repos = NULL, type = "source");

} else {
    os <- 'windows'

print('Downloading the swishdbtools package and install it.')
 download.file('http://swish-climate-impact-assessment.github.com/tools/swishdbtools/swishdbtools_1.1.zip', '~/swishdbtools_1.1.zip', mode = 'wb')
# for instance
install.packages("~/swishdbtools_1.1.zip", repos = NULL);

}
}
require(swishdbtools)
if(!require(raster)) install.packages('raster', repos='http://cran.csiro.au');require(raster)
if(!require(fgui)) install.packages('fgui', repos='http://cran.csiro.au');require(fgui)
if(!require(rgdal)) install.packages('rgdal', repos='http://cran.csiro.au');require(rgdal)

####
# MAKE SURE YOU HAVE THE CORE LIBS
if (!require(lubridate)) install.packages('lubridate', repos='http://cran.csiro.au'); require(lubridate)
if (!require(reshape)) install.packages('reshape', repos='http://cran.csiro.au'); require(reshape)
if (!require(plyr)) install.packages('plyr', repos='http://cran.csiro.au'); require(plyr)
if (!require(ggplot2)) install.packages('ggplot2', repos='http://cran.csiro.au'); require(ggplot2)
