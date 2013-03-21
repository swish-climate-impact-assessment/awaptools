
################################################################
# name:aggregate_postgres
sqlquery <- function(channel, dimensions, operation,
                     variable, variablename=NA, into, append = FALSE,
                     tablename, where, group_by_dimensions=NA,
                     having=NA,
                     grant = NA, force = FALSE,
                     print = FALSE)
{

  exists <- try(dbGetQuery(channel,
                           paste("select * from",into,"limit 1")))
  if(!force & length(exists) > 0 & append == FALSE)
                           stop("Table exists. Force Drop or Insert Into?")
  if(force & length(exists) > 0) dbGetQuery(channel,
                           paste("drop table ",into))
  if(length(exists) > 0 & append == TRUE)
    {
      sqlquery <- paste("INSERT INTO ",into," (",
                           paste(names(exists), collapse=',', sep='') ,")\n",
                        "select ", dimensions,
                        sep = ""
                        )
    } else {
      sqlquery <- paste("select ", dimensions, sep = "")
    }
  if(!is.na(operation))
  {
  sqlquery <- paste(sqlquery, ", ", operation, "(",variable,") as ",
    ifelse(is.na(variablename), variable,
    variablename), '\n', sep = "")
  }
  if(append == FALSE){
    sqlquery <- paste(sqlquery, "into ", into ,"\n", sep = "")
  }
  sqlquery <- paste(sqlquery, "from ", tablename ,"\n", sep = "")
  if(!is.na(where))
  {
  sqlquery <- paste(sqlquery, "where ", where, "\n", sep = "")
  }
  if(group_by_dimensions == TRUE)
  {
  sqlquery <- paste(sqlquery, "group by ",dimensions, "\n", sep = "")
  }
#  cat(sqlquery)



  ## sqlquery <-  paste("select ", dimensions,
  ##                ", ",operation,"(",variables,") as ",variables,
  ##                operation, "
  ##                into ", into ,"
  ##                from ",tablename," t1
  ##                group by ",dimensions,
  ##                sep="")
  if(print) {
    cat(sqlquery)
  } else {
    dbSendQuery(channel, sqlquery)
  }

}
