
################################################################
# name:ZipFunctions.R
uncompress_linux <- function(filename)
  {
    print(filename)
    system(sprintf('uncompress %s',filename))
  }

# tries to find 7 zip exe
ExecutableFileName7Zip <- function()
{
  executableName <- "C:\\Program Files\\7-Zip\\7z.exe"

  if(file.exists(executableName))
  {
    return (executableName)
  }

  #other executable file names and ideas go here ...
  stop("failed to find 7zip")
}

# simple function to extract 7zip file
# need to have 7zip installed
Decompress7Zip <- function(zipFileName, outputDirectory, delete)
{
  executableName <- ExecutableFileName7Zip()

#   fileName = GetFileName(zipFileName)
#   fileName = PathCombine(outputDirectory, fileName)


#   if(file.exists(fileName))
#   {
#     unlink(zipFileName);
#   }

  arguments <- paste(sep="",
                    "e ",
                    "\"", zipFileName, "\" ",
                    "\"-o", outputDirectory, "\" ",
    "")

  print( arguments)

  RunProcess(executableName, arguments)

  if(delete)
  {
    unlink(zipFileName);
  }
}

#test
# Decompress7Zip("D:\\Development\\Awap Work\\2013010820130108.grid.Z", "D:\\Development\\Awap Work\\", TRUE)
