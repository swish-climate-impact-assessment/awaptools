
################################################################
# name:raster_extract_by_day
require(swishdbtools)
conn <- connect2postgres2("ewedb")
raster_extract_by_day(
  ch = conn
  , 
  startdate = '2013-04-18'
  , 
  enddate = '2013-04-20'
  , 
  measures = c("maxave", "minave", "vprph09", "vprph15")
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
