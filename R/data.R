#' 2018 US State Populations
#'
#' SCPRC-EST2018-18+POP-RES: Estimates of the Total Resident Population and
#' Resident PopulationAge 18 Years and Older for the United States, States, and
#' Puerto Rico: July 1, 2018
#'
#' @format A tibble with 52 rows and 7 variables:
#' \describe{
#'   \item{sumlev}{Geographic summary level}
#'   \item{region}{Census Region code}
#'   \item{division}{Census Division code}
#'   \item{fips}{State FIPS code}
#'   \item{state}{State name}
#'   \item{pop}{Resident population estimate (2018-07-01)}
#'   \item{adult}{Percent of resident population age 18 years and over (2018-07-01)}
#'   ...
#' }
#' @source \url{https://www2.census.gov/programs-surveys/popest/datasets/2010-2018/state/detail/}
"pop"
