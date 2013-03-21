
################################################################
# name:check_duplicates
check_duplicates <- function(conn, measures = c("vprph09","vprph15"), dates)
    {
  #suspicious_dates <- list()
  #measures <- c("maxave","minave", "solarave","totals",

  for(j in 1:length(dates))
    {
      #date_j <- dates[2]
      date_j <- dates[j]
      date_i <- gsub("-","",date_j)
      print(date_i)
      rasters <- list()

  #      print(measure)
        rastername1 <- paste(measures[1], "_", date_i, sep ="")
        rastername2 <- paste(measures[2], "_", date_i, sep ="")
        tableExists <- pgListTables(ch, schema="awap_grids",
    pattern=rastername1)
        tableExists2 <- pgListTables(ch, schema="awap_grids", pattern=rastername2)
        if(nrow(tableExists) == 0 | nrow(tableExists2) == 0)
        {
          next
        }
      for(i in 1:length(measures))
      {
  #      i = 2
        measure <- measures[i]
        rastername <- paste(measures[i], "_", date_i, sep ="")
          r1 <- readGDAL2("115.146.84.135", "gislibrary", "ewedb",
                          "awap_grids", rastername, p = pwd)
  #        image(r1)
          rasters[[i]] <- r1

      }
        ## str(rasters)
      ##   par(mfrow = c(1,2))
      ##   image(rasters[[1]])
      ##   image(rasters[[2]])
      suspect <- identical(rasters[[1]]@data, rasters[[2]]@data)
      #all.equal(head(rasters[[1]]@data), head(rasters[[2]]@data))
      if(suspect)
        {
          #counter <- length(suspicious_dates)
          #suspicious_dates[[counter + 1]] <- rastername
          sink('sus_dates.csv', append = T)
          cat(rastername)
          cat('\n')
          sink()
        }
      rm(suspect)

    }

  #return(suspicious_dates)
  }
