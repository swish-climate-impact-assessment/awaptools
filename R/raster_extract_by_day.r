
################################################################
# name:raster_extract_by_day
raster_extract_by_day  <- function(ch = NA, startdate = NA, enddate = NA,
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
    #date_j = dates[1]
    ################################################
    # ad hoc table "public", "tempfoobar"
    temporary_table <- swish_temptable()
    tblExists <- pgListTables(conn = ch, temporary_table$schema, 
                              temporary_table$table
                              )
    if(nrow(tblExists) >0)
    {
      dbSendQuery(conn = ch, sprintf("drop table %s", temporary_table$fullname))
    }
    #date_j <- dates[2]
    ################################################
    # the output table to append into, if exists on day one then remove
    if(date_j == dates[1])
    {
      tblExists <- pgListTables(conn = ch,schemaName,tableName)
      if(nrow(tblExists) >0)
      {
      dbSendQuery(conn = ch, sprintf("drop table  %s.%s", schemaName, tableName))
      }
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
      sql <- postgis_raster_extract(conn = ch, x=rastername, 
                                    y=pointsLayer, 
                                    zone_label = zone_label, 
                                    value_label = "value"
                                    )
      sql <- gsub("FROM", 
                  sprintf("INTO %s.%s\nFROM", temporary_table$schema, 
                          temporary_table$table)
                  ,
                  sql)
      #cat(sql)  
      
      dbSendQuery(conn = ch, statement = sql) 
      
      tblExists <- pgListTables(conn = ch, schemaName, tableName)
      if(nrow(tblExists) == 0)
      {
        sql <- sql_subset_into(conn = ch, x=temporary_table$fullname, 
                               into_schema=schemaName,
                               into_table=tableName,eval=F, drop=F
        )
        # cat(sql)
        dbSendQuery(conn = ch, sql)      
      } else {
        sql <- sql_subset(conn = ch, x=temporary_table$fullname, eval=F)
        sql <- paste("INSERT INTO ",schemaName,".",tableName," (
          ", zone_label, ", raster_layer, value)
          ",sql,sep ="")
        #cat(sql)
        dbSendQuery(conn = ch, sql)
      }
      dbSendQuery(conn = ch, sprintf("drop table %s", temporary_table$fullname))
      #}
    }
  }
}
