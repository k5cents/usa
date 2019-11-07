#' 2018 US Census Regions
#'
#' The United States Census Bureau defines four statistical [regions], with nine
#' [divisions].
#'
#' @format A tibble with 4 rows and 2 variables:
#' \describe{
#'   \item{reg_id}{United States Census Bureau region ID}
#'   \item{region}{Statistical region}
#'   ...
#' }
#' @source \url{https://www2.census.gov/programs-surveys/popest/geographies/2018/}
"regions"

#' 2018 US Census Regions
#'
#' The United States Census Bureau defines four statistical [regions], with nine
#' [divisions].
#'
#' @format A tibble with 4 rows and 2 variables:
#' \describe{
#'   \item{div_id}{United States Census Bureau division ID}
#'   \item{region}{Statistical division}
#'   ...
#' }
#' @source \url{https://www2.census.gov/programs-surveys/popest/geographies/2018/}
"divisions"

#' 2018 US Census FIPS state codes
#'
#' FIPS state codes were numeric and two-letter alphabetic codes defined in U.S.
#' Federal Information Processing Standard Publication ("FIPS PUB") 5-2 to
#' identify U.S. states and certain other associated areas.
#'
#' @format A tibble with 52 rows and 4 variables:
#' \describe{
#'   \item{reg_id}{United States Census Bureau [divisions] ID}
#'   \item{div_id}{United States Census Bureau [regions] ID}
#'   \item{fips}{United States Census Bureau state FIPS code}
#'   \item{state}{State name}
#'   ...
#' }
#' @source \url{https://www2.census.gov/programs-surveys/popest/geographies/2018/}
"fips"
