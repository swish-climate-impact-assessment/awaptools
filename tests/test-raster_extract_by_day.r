
################################################################
# name:raster_extract_by_day
# test raster extract
require(swishdbtools)
conn <- connect2postgres2("ewedb")
raster_extract_by_day(
  ch = conn
  , 
  startdate = '2013-04-19'
  , 
  enddate = '2013-04-20'
  , 
  measures = c("maxave", "minave")
  ,
  schemaName = "weather_sla"
  ,
  tableName = "weather_nswsla06"
  ,
  pointsLayer = "abs_sla.nswsla06_points"
)

dat <- reformat_awap_data(
  tableName = "weather_sla.weather_nswsla06"
)
head(dat)
