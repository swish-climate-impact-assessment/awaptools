
################################################################
# name:ProcessFunctions.R

RunProcess = function(executable, arguments)
{
  command = paste(sep="", "\"", executable,  "\" ", arguments);
  
  print (command)
  
  exitCode = system(command, intern = FALSE, ignore.stdout = FALSE, ignore.stderr = FALSE, wait = TRUE, input = NULL
                    , show.output.on.console = TRUE
                    #, minimized = FALSE
                    , invisible = FALSE
  );
  if(exitCode != 0)
  {
    stop("Process returned error");
  }
  return (exitCode)
}


RunViaBat = function(executableFileName, arguments)
{
  command = paste(sep="", "\"", executableFileName,  "\" ", arguments);
  sink("C:\\Users\\u5265691\\Desktop\\ThingToRun.bat")
  cat(command)
  sink()
  
  exitCode = system("C:\\Users\\u5265691\\Desktop\\ThingToRun.bat")
  if(exitCode != 0)
  {
    stop("Process returned error");
  }
  return (exitCode)
}
