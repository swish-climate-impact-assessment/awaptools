
################################################################
# name:raster_extract_by_day
require(swishdbtools)
require(awaptools)
startdate <- "2013-04-01" #StartDate
enddate <- "2013-04-02" #EndDate

ch<-connect2postgres2("ewedb")


# get locations
stn  <- sql_subset(ch, "weather_bom.combstats", eval = T)
head(stn)  

# clean
names(stn) <- gsub("lon", "long", names(stn))
names(stn) <- gsub("gid", "gid2", names(stn))
nrow(stn)

# sample
percentSample <- 0.01
sampled  <- sample(stn$stnum, percentSample * nrow(stn))
length(sampled)
locations  <- stn[which(stn$stnum %in% sampled),]
head(locations)

# send to postgis
tempTableName <- swish_temptable()
sch <- tempTableName$schema
tbl <- tempTableName$table

tempTableName <- tempTableName$fullname

exists <- pgListTables(ch, sch, tbl)
if(nrow(exists) > 0){
  dbSendQuery(ch, 
              sprintf("drop table %s.%s", sch, tbl)
  )
}
dbWriteTable(ch, tbl, locations, row.names = F)
tested <- sql_subset(ch, tempTableName, eval = T)
# head(tested)

tempTableName

# points2geom

sql <- points2geom(
  schema=sch,
  tablename=tbl,
  col_lat= "lat",col_long="long", srid="4283"
)
# cat(sql)
dbSendQuery(ch, sql)
tbl


raster_extract_by_day(ch, startdate, enddate,
                                   schemaName = sch
                      ,
                                   tableName = "output_one"
                      ,
                                   pointsLayer = tempTableName
                      ,
                                   measures = c("maxave", "minave")
                      ,
                      zone_label = "stnum"
)

schemaTableName <- paste(sep=".", "public", tempTableName)

data <- reformat_awap_data(
  tableName = schemaTableName
)

tempFileName <- tempfile("foo", tmpdir = Sys.getenv("TEMP"), fileext = "")
write.dta(data, tempFileName)
tempFileName


################################################################
# name: tidy up
require(swishdbtools)
ch<-connect2postgres2("ewedb")
sch <- swish_temptable("ewedb")
sch <- sch$schema
tbls <- pgListTables(ch, sch, table="foo", match = FALSE)
tbls
for(tab in tbls[,1])
{
  #tab <- tbls[1,1]
  dbSendQuery(ch, 
              sprintf("drop table %s.\"%s\"", sch, tab)
  )
}
