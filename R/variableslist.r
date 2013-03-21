
###########################################################################
# newnode: variableslist
variableslist<-"variable,measure,timestep
rainfall,totals,daily
temperature,maxave,daily
temperature,minave,daily
vprp,vprph09,daily
vprp,vprph15,daily
solar,solarave,daily
ndvi,ndviave,month
"
variableslist <- read.csv(textConnection(variableslist))
