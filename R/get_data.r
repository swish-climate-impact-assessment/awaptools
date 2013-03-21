
# newnode get_data
# authors: Joseph Guillaume
# downloads from http://www.bom.gov.au/jsp/awap/
get_data<-function(variable,measure,timestep,startdate,enddate){
  url="http://www.bom.gov.au/web03/ncc/www/awap/{variable}/{measure}/{timestep}/grid/0.05/history/nat/{startdate}{enddate}.grid.Z"
  url=gsub("{variable}",variable,url,fixed=TRUE)
  url=gsub("{measure}",measure,url,fixed=TRUE)
  url=gsub("{timestep}",timestep,url,fixed=TRUE)
  url=gsub("{startdate}",startdate,url,fixed=TRUE)
  url=gsub("{enddate}",enddate,url,fixed=TRUE)

  try(download.file(url,sprintf("%s_%s%s.grid.Z",measure,startdate,enddate),mode="wb"))
  }
