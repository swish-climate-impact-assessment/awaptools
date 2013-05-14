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
  #  dat <- as.data.frame(cast(dat, address + date ~ measure, value = "value",
  #                            fun.aggregate= "mean")
  #                       )
  dat <- eval(
    parse(
      text=sprintf(
        "as.data.frame(cast(dat, %s + date ~ measure, value = 'value',
                            fun.aggregate= 'mean')
                       )", zone_label
      )
    )
  )
  
  dat$date <- as.Date(dat$date)
  return(dat)
}