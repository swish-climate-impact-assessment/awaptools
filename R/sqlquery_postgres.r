
################################################################
# name:aggregate_postgres
  
sqlquery_postgres <- function(channel, dimensions, operation,
                     variable, variablename=NA, into_schema = 'public',
                     into_table, append = FALSE,
                     from_schema = 'public', from_table, where=NA,
                     group_by_dimensions=NA,
                     having=NA,
                     grant = NA, force = FALSE,
                     print = FALSE)
{
  # assume ch exists
  exists <- pgListTables(channel, into_schema, into_table)
  if(!force & nrow(exists) > 0 & append == FALSE)
    {
      stop("Table exists. Force Drop or Insert Into?")
    }
  
  if(force & nrow(exists) > 0)
    {
      dbGetQuery(channel, paste("drop table ",into_schema,".",into_table,sep=""))
    }
  
  if(!force & nrow(exists) >0)
    {
      existing_table <- dbGetQuery(channel,
                                   paste('select * from ',
                                         into_schema,'.',
                                         into_table,' limit 1',sep=''
                                         )
                                   )
    }
  
  if(nrow(exists) > 0 & append == TRUE)
    {
      sqlquery <- paste("INSERT INTO ",into_schema,".",into_table," (",
                           paste(names(existing_table), collapse=',', sep='') ,")\n",
                        "select ", dimensions,
                        sep = ""
                        )
    } else {
      sqlquery <- paste("select ", dimensions, "", sep = "")
    }
  
  if(!is.na(operation))
    {
      sqlquery <- paste(sqlquery, ", ", operation, "(",variable,") as ",
        ifelse(is.na(variablename), variable,
        variablename), '\n', sep = "")
    } else {
      sqlquery <- paste(sqlquery, ", ",variable," as ",
                        ifelse(is.na(variablename),variable,variablename),
                        "\n", sep="")
    }
  
  # this is when append is true but the table doesnt exist yet
  if(nrow(exists) == 0 & append == TRUE)
    {
      sqlquery <- paste(sqlquery, "into ",
                        into_schema,".",into_table,"\n", sep = ""
                        )
    }
  
  # otherwise append is false and the table just needs to be created
  if(append == FALSE)
    {
      sqlquery <- paste(sqlquery, "into ",
                        into_schema,".",into_table,"\n", sep = ""
                        )
    }
  
  sqlquery <- paste(sqlquery, "from ", from_schema,".",from_table ,"\n", sep = "")
  
  if(!is.na(where))
    {
      sqlquery <- paste(sqlquery, "where ", where, "\n", sep = "")
    }
  
  if(group_by_dimensions == TRUE)
    {
      sqlquery <- paste(sqlquery, "group by ",
                        dimensions, "\n",
                        sep = ""
                        )
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
