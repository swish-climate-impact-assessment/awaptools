
################################################################
# name:raster_aggregate
raster_aggregate <- function(filename, aggregationfactor, delete = TRUE)
{
  r <- raster(filename)
  r <- aggregate(r, fact = aggregationfactor, fun = mean)
  writeRaster(r, gsub('.grid','',fname), format="GTiff",
overwrite = TRUE)
  if(delete)
    {
      file.remove(filename)
    }
}
