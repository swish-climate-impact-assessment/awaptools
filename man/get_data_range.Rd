\name{get_data_range}
\alias{get_data_range}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
get_data_range(variable, measure, timestep, startdate, enddate)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{variable}{
%%     ~~Describe \code{variable} here~~
}
  \item{measure}{
%%     ~~Describe \code{measure} here~~
}
  \item{timestep}{
%%     ~~Describe \code{timestep} here~~
}
  \item{startdate}{
%%     ~~Describe \code{startdate} here~~
}
  \item{enddate}{
%%     ~~Describe \code{enddate} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (variable, measure, timestep, startdate, enddate) 
{
    if (timestep == "daily") {
        thisdate <- startdate
        while (thisdate <= enddate) {
            get_data(variable, measure, timestep, format(as.POSIXct(thisdate), 
                "\%Y\%m\%d"), format(as.POSIXct(thisdate), "\%Y\%m\%d"))
            thisdate <- thisdate + as.double(as.difftime(1, units = "days"), 
                units = "secs")
        }
    }
    else if (timestep == "month") {
        startdate <- as.POSIXlt(startdate)
        startdate$mday <- 1
        data.period.start <- seq(as.Date(startdate), as.Date(enddate), 
            by = "month")
        data.period.end <- as.Date(sapply(data.period.start, 
            FUN = function(x) {
                as.character(seq(x, x + 40, by = "month")[2] - 
                  1)
            }))
        for (i in 1:length(data.period.start)) {
            get_data(variable, measure, timestep, format(as.POSIXct(data.period.start[i]), 
                "\%Y\%m\%d"), format(as.POSIXct(data.period.end[i]), 
                "\%Y\%m\%d"))
        }
    }
    else {
        stop("Unsupported timestep, only 'daily' and 'month' are currently supported")
    }
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
