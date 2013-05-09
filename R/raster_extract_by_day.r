
################################################################
# name:raster_extract_by_day
raster_extract_by_day  <- function(ch, startdate, enddate,
                                   schemaName = "weather_sla",
                                   tableName = "weather_nswsla06",
                                   pointsLayer = "abs_sla.nswsla06_points",
                                   measures = c("maxave", "minave"),
                                   zone_label = "address"
)
{
  
  dates <- as.character(
    seq(
      as.Date(startdate),
      as.Date(enddate), 1
    )
  )
  
  for(date_j in dates)
  {
    tblExists <- pgListTables(ch,"public", "tempfoobar")
    if(nrow(tblExists) >0)
    {
      dbSendQuery(ch, "drop table public.tempfoobar")
    }
    #date_j <- dates[2]
    if(date_j == dates[1])
    {
      try(dbSendQuery(ch, sprintf("drop table  %s.%s", schemaName, tableName)))
    }
    
    date_i <- gsub("-","",date_j)
    #print(date_i)
    for(i in 1:length(measures))
    { # i = 1
      measure <- measures[i]
      #print(measure)
      rastername <- paste("awap_grids.", measure, "_", date_i, sep ="")
      #tableExists <- pgListTables(ch, schema="awap_grids", table=paste(measure, "_", date_i, sep =""))
      #if(nrow(tableExists) > 0)
      #{
      sql <- postgis_raster_extract(ch, x=rastername, y=pointsLayer, zone_label = zone_label, value_label = "value")
      sql <- gsub("FROM", "INTO public.tempfoobar\nFROM", sql)
      #cat(sql)  
      
      dbSendQuery(ch, sql) 
      
      tblExists <- pgListTables(ch, schemaName, tableName)
      if(nrow(tblExists) == 0)
      {
        sql <- sql_subset_into(ch, x="public.tempfoobar", into_schema=schemaName,
                               into_table=tableName,eval=F, drop=F
        )
        #cat(sql)
        dbSendQuery(ch, sql)      
      } else {
        sql <- sql_subset(ch, x="public.tempfoobar", eval=F)
        sql <- paste("INSERT INTO ",schemaName,".",tableName," (
          ", zone_label, ", raster_layer, value)
          ",sql,sep ="")
        #cat(sql)
        dbSendQuery(ch, sql)
      }
      dbSendQuery(ch, "drop table public.tempfoobar")
      #}
    }
  }
}





reformat_awap_data  <- function(
  tableName = "weather_sla.weather_nswsla06",
  zone_label = "address"
)
{
  dat <- sql_subset(ch, tableName, eval = T)
  dat$date <- matrix(unlist(strsplit(dat$raster_layer, "_")), ncol = 3, byrow=TRUE)[,3]
  dat$date <- paste(substr(dat$date,1,4), substr(dat$date,5,6), substr(dat$date,7,8), sep = "-")
  dat$measure <- matrix(unlist(strsplit(dat$raster_layer, "_")), ncol = 3, byrow=TRUE)[,2]
  dat$measure <- gsub("grids.","",dat$measure)
  
  dat <- arrange(dat,  date, measure)
  dat <- as.data.frame(cast(dat, address + date ~ measure, value = "value",
                            fun.aggregate= "mean")
                       )
  dat$date <- as.Date(dat$date)
  return(dat)
}
