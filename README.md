awaptools
=========

- The Bureau of Meteorology has generated a range of gridded meteorological datasets for Australia as a contribution to the Australian Water Availability Project (AWAP). 
- An R package to download and format the AWAP grids.
- Binaries available from [http://swish-climate-impact-assessment.github.com/tools.html](http://swish-climate-impact-assessment.github.com/tools.html)
- More info is available [http://www.bom.gov.au/jsp/awap/](http://www.bom.gov.au/jsp/awap/)
- The documentation of the data creation is at [http://www.bom.gov.au/amm/docs/2009/jones.pdf](http://www.bom.gov.au/amm/docs/2009/jones.pdf)

#### R-Code: A workflow to download and process the public BoM weather grids.
    # depends
    install.packages(c('raster', 'rgdal', 'plyr', 'RODBC', 'RCurl', 'XML', 'ggmap', 'maptools', 'spdep'))

    # This workflow uses the open source R software with some of our custom written packages:
    # aim daily weather for any point location from online BoM weather grids
    # depends on some github packages, either use devtools
    install.packages("devtools")
    require(devtools)
    install_github("awaptools", "swish-climate-impact-assessment")
    install_github("swishdbtools", "swish-climate-impact-assessment")
    install_github("gisviz", "ivanhanigan")

    # OR download and install
    # http://swish-climate-impact-assessment.github.io/tools/awaptools/awaptools-downloads.html
    # http://swish-climate-impact-assessment.github.io/tools/swishdbtools/swishdbtools-downloads.html
    # http://ivanhanigan.github.io/gisviz/
    
    require(awaptools)
    require(swishdbtools)
    require(gisviz)   
     
    # get weather data, beware that each grid is a couple of megabytes
    vars <- c("maxave","minave","totals","vprph09","vprph15") #,"solarave") 
    # solar only available after 1990
    for(measure in vars)
    {
      #measure <- vars[1]
      get_awap_data(start = '1960-01-01',end = '1960-01-02', measure)
    }
     
    # get location
    locn <- geocode("daintree rainforest")
    # this uses google maps API, better check this
    # lon       lat
    # 1 145.4185 -16.17003
    ## Treat data frame as spatial points
    epsg <- make_EPSG()
    shp <- SpatialPointsDataFrame(cbind(locn$lon,locn$lat),locn,
                                  proj4string=CRS(epsg$prj4[epsg$code %in% '4283']))
    # now loop over grids and extract met data
    cfiles <-  dir(pattern="grid$")
     
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
