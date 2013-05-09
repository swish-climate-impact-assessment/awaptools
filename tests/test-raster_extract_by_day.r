
################################################################
# name:raster_extract_by_day
require(swishdbtools)
require(awaptools)
startdate <- "2013-04-01" #StartDate
enddate <- "2013-04-02" #EndDate

#source("D:\\Development\\SydneyThing\\raster_extract_by_day.R")

ch<-connect2postgres2("ewedb")

tempTableName <- tempfile("foo", tmpdir = Sys.getenv("TEMP"), fileext = "")

tempTableName <- gsub("\\.", "", tempTableName)
tempTableName <- gsub(":", "", tempTableName)
tempTableName <- gsub("\\\\", "", tempTableName)
tempTableName <- gsub("/", "", tempTableName)

raster_extract_by_day(ch, startdate, enddate,
                                   schemaName = "public",
                                   tableName = tempTableName,
                                   pointsLayer = "locations",
                                   measures = c("maxave", "minave")
)

schemaTableName <- paste(sep=".", "public", tempTableName)

data <- reformat_awap_data(
  tableName = schemaTableName
)

tempFileName <- tempfile("foo", tmpdir = Sys.getenv("TEMP"), fileext = "")
write.dta(data, tempFileName)
tempFileName
