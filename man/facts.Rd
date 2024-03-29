% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{facts}
\alias{facts}
\title{US State Facts}
\format{
A tibble with 52 rows and 9 variables:
\describe{
\item{name}{Full state name}
\item{population}{Population estimate (September 26, 2019)}
\item{votes}{Votes in the Electoral College (following the 2010 Census)}
\item{admission}{The data which the state was admitted to the union}
\item{income}{Per capita income (2018)}
\item{life_exp}{Life expectancy in years (2017-18)}
\item{murder}{Murder rate per 100,000 population (2018)}
\item{college}{Percent adult population with at least a bachelor's degree or greater (2019)}
\item{heat}{Mean number of degree days (temperature requires heating) per year from 1981-2010}
}
}
\source{
\itemize{
\item Population: \url{https://www2.census.gov/programs-surveys/popest/datasets/2010-2018/state/detail/SCPRC-EST2018-18+POP-RES.csv}
\item Electoral College: \url{https://www.archives.gov/electoral-college/allocation}
\item Income: \url{https://data.census.gov/cedsci/table?tid=ACSST1Y2018.S1903}
\item GDP: \url{https://www.bea.gov/system/files/2019-11/qgdpstate1119.xlsx}
\item Literacy: \url{https://nces.ed.gov/naal/estimates/StateEstimates.aspx}
\item Life Expectancy: \url{https://web.archive.org/web/20231129160338/https://usa.mortality.org/}
\item Murder: \url{https://ucr.fbi.gov/crime-in-the-u.s/2018/crime-in-the-u.s.-2018/tables/table-4/table-4.xls/output.xls}
\item Education: \url{https://data.census.gov/cedsci/table?q=S1501}
\item Temperature: \url{ftp://ftp.ncdc.noaa.gov/pub/data/normals/1981-2010/products/temperature/ann-cldd-normal.txt}
}
}
\usage{
facts
}
\description{
Updated version of the \link[datasets:state]{datasets::state.x77} matrix, which provides eights
statistics from the 1970's. This version is a modern data frame format
with updated (and alternative) statistics.
}
\keyword{datasets}
