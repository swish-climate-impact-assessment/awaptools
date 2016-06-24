
compress_gtifs <- function(indir = getwd()){

# load some, plot to check, and demonstrate conversion to GeoTIF
cfiles <- stack(dir(pattern = "grid$"))

plot(cfiles, nc = 2) # plot to look at

# Check if GTif/AWAP directory exists, it not, create it (taken from http://stackoverflow.com/questions/4216753/check-existence-of-directory-and-create-if-doesnt-exist)

subDir <- "GTif"

if (file.exists(file.path(indir, subDir))){
    setwd(file.path(indir, subDir))
} else {
    dir.create(file.path(indir, subDir))
    setwd(file.path(indir, subDir))

}

# write grid files as GeoTif files to disk with compression
# to save space
writeRaster(cfiles, filename = "GTif", format = "GTiff",
            bylayer = TRUE, overwrite = TRUE, suffix = "names",
            dataType = "INT2S", options = c("COMPRESS=LZW"))
print("done")

}
