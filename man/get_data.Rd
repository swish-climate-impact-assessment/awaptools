\name{get_data}
\alias{get_data}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
get_data(variable, measure, timestep, startdate, enddate)
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
    url = "http://www.bom.gov.au/web03/ncc/www/awap/{variable}/{measure}/{timestep}/grid/0.05/history/nat/{startdate}{enddate}.grid.Z"
    url = gsub("{variable}", variable, url, fixed = TRUE)
    url = gsub("{measure}", measure, url, fixed = TRUE)
    url = gsub("{timestep}", timestep, url, fixed = TRUE)
    url = gsub("{startdate}", startdate, url, fixed = TRUE)
    url = gsub("{enddate}", enddate, url, fixed = TRUE)
    try(download.file(url, sprintf("\%s_\%s\%s.grid.Z", measure, 
        startdate, enddate), mode = "wb"))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
