
################################################################
# name:load-monthly
# workdir <- getwd()
# outdir <- outdir
# setwd(outdir)
#start_date <- as.POSIXlt(start_date)
#require(devtools)
#install_github("awaptools", "swish-climate-impact-assessment")
load_monthly <- function(start_date)
  {
  variableslist <- variableslist()
  variableslist
  vname <- variableslist[1,1]
  measure_i <- variableslist[1,2]
  end_date <- as.POSIXlt(
                   paste(as.numeric(format(Sys.Date(), "%Y")),
                         as.numeric(format(Sys.Date(), "%m")) -1, 1, sep = "-")
                 )
  dateslist <- as.character(seq(start_date, end_date, by = "month"))
  for(date_i in dateslist)
    {
  #    date_i <- dateslist[1]
      flist <- dir(pattern = measure_i)
      fileExists <- grep(paste(measure_i, gsub("-", "", date_i), sep = "_"), flist)
      if(length(fileExists) > 0)
        {
          next
        }

      sdate <- as.POSIXct(date_i)
      if(as.numeric(format(sdate, "%m")) < 12)
        {
                   edate <- as.POSIXct(paste
                              (format(sdate, "%Y"),
                               as.numeric(format(sdate, "%m")) + 1, 1, sep = "-"
                               )
                              )
         } else {
                   edate <- as.POSIXct(paste
                              (as.numeric(format(sdate, "%Y")) +1,
                               1, 1, sep = "-"
                               )
                              )
         }
      get_data_range(
                     variable = vname,
                     measure = measure_i,
                     timestep = "monthly",
                     startdate = sdate,
                     enddate = edate
                 )
    }
  }
