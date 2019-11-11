#' 2018 US state informations
#'
#' Various official identifying codes for the fifty US states as well as the
#' District of Columbia and Puerto Rico, and other territories.
#'
#' @format A tibble with 57 rows and 6 variables:
#' \describe{
#'   \item{fips}{United States Census Bureau state FIPS code}
#'   \item{name}{State name}
#'   \item{abb}{United States Postal Service two-letter abbreviation}
#'   \item{ansi}{American National Standards Institute 8-digit code}
#'   \item{region}{United States Census Bureau [state_divisions]}
#'   \item{division}{United States Census Bureau [state_regions]}
#'   ...
#' }
#' @source \url{https://www2.census.gov/geo/docs/reference/state.txt}
"states"

#' 2018 US state names
#'
#' The full name for each of the US states and territories.
#'
#' @format A tibble with 57 rows and 2 variables:
#' \describe{
#'   \item{fips}{United States Census Bureau state FIPS code}
#'   \item{name}{Full legal name}
#'   ...
#' }
#' @source \url{https://www2.census.gov/geo/docs/reference/state.txt}
"state_names"

#' 2018 US state abbreviations
#'
#' The USPS two-letter abbreviations for each of the US states and territories.
#'
#' @format A tibble with 57 rows and 2 variables:
#' \describe{
#'   \item{fips}{United States Census Bureau state FIPS code}
#'   \item{abb}{United States Postal Service two-letter abbreviation}
#'   ...
#' }
#' @source \url{https://www2.census.gov/geo/docs/reference/state.txt}
"state_abbs"

#' 2018 US state abbreviations
#'
#' The ANSI 8-digit codes for each of the US states and territories.
#'
#' @format A tibble with 57 rows and 2 variables:
#' \describe{
#'   \item{fips}{United States Census Bureau state FIPS code}
#'   \item{ansi}{United States Postal Service two-letter abbreviation}
#'   ...
#' }
#' @source \url{https://www2.census.gov/geo/docs/reference/state.txt}
"state_ansi"

#' 2018 US Census Bureau regions
#'
#' The United States Census Bureau defines four statistical [state_regions],
#' with nine [state_divisions].
#'
#' @format A tibble with 4 rows and 2 variables:
#' \describe{
#'   \item{reg_id}{United States Census Bureau region ID}
#'   \item{region}{Statistical region}
#'   ...
#' }
#' @source \url{https://www2.census.gov/programs-surveys/popest/geographies/2018/}
"state_regions"

#' 2018 US Census Bureau divisions
#'
#' The United States Census Bureau defines four statistical [state_regions],
#' with nine [state_divisions].
#'
#' @format A tibble with 4 rows and 2 variables:
#' \describe{
#'   \item{div_id}{United States Census Bureau division ID}
#'   \item{region}{Statistical division}
#'   ...
#' }
#' @source \url{https://www2.census.gov/programs-surveys/popest/geographies/2018/}
"state_divisions"

#' 2018 US state centers
#'
#' Updated list of USGS state geographic centroids.
#'
#' @format A tibble with 56 rows and 3 variables:
#' \describe{
#'   \item{fips}{United States Census Bureau state FIPS code}
#'   \item{x}{Longitude}
#'   \item{y}{Latitude}
#'   ...
#' }
#' @source \url{https://en.wikipedia.org/wiki/List_of_geographic_centers_of_the_United_States}
"state_centers"

#' US state and territory abbreviations
#'
#' Character vector of 2-letter abbreviations for the state and territory names.
#'
#' @format A character vector of length 57.
#'
#' @source \url{https://www2.census.gov/geo/docs/reference/state.txt}
"state.abb"

#' US state and territory names
#'
#' Character vector giving the full state and territory names.
#'
#' @format A character vector of length 57.
#'
#' @source \url{https://www2.census.gov/geo/docs/reference/state.txt}
"state.name"

#' US state Census regions
#'
#' Factor giving the region (Northeast, South, North Central, West) that each
#' state (and the District of Columbia) belongs to.
#'
#' @format A character vector of length 51.
#'
#' @source \url{https://www2.census.gov/programs-surveys/popest/geographies/2018/}
"state.region"

#' US state Census divisions
#'
#' Factor giving state divisions (New England, Middle Atlantic, South Atlantic,
#' East South Central, West South Central, East North Central, West North
#' Central, Mountain, and Pacific).
#'
#' @format A character vector of length 51.
#'
#' @source \url{https://www2.census.gov/programs-surveys/popest/geographies/2018/}
"state.division"

#' US state geographic centers
#'
#' List with components named x and y giving the approximate geographic center
#' of each state in negative longitude and latitude.
#'
#' @format A character vector of length 51.
#'
#' @source \url{https://www2.census.gov/programs-surveys/popest/geographies/2018/}
"state.center"
