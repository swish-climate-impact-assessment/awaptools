

# source("D:\\Development\\Awap Work\\StringFunctions.R")
# source("D:\\Development\\Awap Work\\FileFunctions.R")
# source("D:\\Development\\Awap Work\\ProcessFunctions.R")

GridToSql<-function(inputFileName, outputFileName)
{
  executableFileName = "C:\\Program Files\\PostgreSQL\\9.2\\bin\\raster2pgsql.exe"
  tableName = GetFileNameWithoutExtension(inputFileName)
  
  arguments = paste(sep="", 
    " -s 4283 -I -C -M ",
                    
                    "\"", inputFileName  , "\"", " ",
                    " -F ",
                    "\"", tableName  , "\"",
                    " > " , "\"", outputFileName , "\"" 
  )
  print(executableFileName)
  print(arguments)
  
  RunViaBat(executableFileName, arguments)
}


#test 
#GridToSql("C:\\Users\\u5265691\\Desktop\\2013010820130108.grid", "C:\\Users\\u5265691\\Desktop\\Output.sql")

