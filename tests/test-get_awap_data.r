
################################################################
# name:get_awap_data
# test

# functions
require(devtools)
install_github('awaptools','swish-climate-impact-assessment')
require(awaptools)
install_github('swishdbtools','swish-climate-impact-assessment')
require(swishdbtools)
variableslist <- variableslist()  
vars <- c("maxave","minave","totals","vprph09","vprph15","solarave")
for(measure in vars)
{
  get_awap_data(start = '1990-01-01',end = '1990-01-01', measure)
}
fileslist <- dir(pattern="grid$")
r <- readGDAL(fname=fileslist[5])
image(r)
