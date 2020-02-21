
compress_gtifs <- function (indir = getwd(), subDir = "GTif", filelist = NULL){
  if(is.null(filelist)) stop("no list of grids provided")
  cfiles <- stack(filelist)
  
  if (file.exists(file.path(indir, subDir))) {
    setwd(file.path(indir, subDir))
  }
  else {
    dir.create(file.path(indir, subDir))
    setwd(file.path(indir, subDir))
  }
  writeRaster(cfiles, filename = "GTif", format = "GTiff", 
              bylayer = TRUE, overwrite = TRUE, suffix = "names", datatype = "INT2S", 
              options = c("COMPRESS=LZW"))
  setwd(indir)
  print("done")
}
