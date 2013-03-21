\name{get_data_range}
\alias{get_data_range}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Get AWAP data range
}
\description{
Get AWAP data for a range of dates
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
 get_data_range(variable="temperature",
                   measure="maxave",
                   timestep="daily",
                   startdate=as.POSIXct("2013-01-18"),
                   enddate=as.POSIXct("2013-01-18"))
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
