
################################################################
# name:LinuxOperatingSystem
LinuxOperatingSystem <- function()
{
  if(length(grep('linux',sessionInfo()[[1]]$os)) == 1)
  {
    #print('Linux')
    os <- 'linux' 
    OsLinux <- TRUE
  }else if (length(grep('ming',sessionInfo()[[1]]$os)) == 1)
  {
    #print('Windows')
    os <- 'windows'
    OsLinux <- FALSE
  }else
  {
    # don't know, do more tests
    print('Non linux or windows os detected. Assume linux-alike.')
    os <- 'linux?'
    OsLinux <- TRUE
  }
 
  return (OsLinux)
}
