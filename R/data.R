# objects from states.R ---------------------------------------------------

#' US State and Territories
#'
#' Information on the 50 states, 1 federal district, and 6 territories of the
#' United States of America.
#'
#' @format A tibble with 57 rows and 9 variables:
#' \describe{
#'   \item{abb}{2-letter abbreviation}
#'   \item{name}{Full legal name}
#'   \item{fips}{Federal Information Processing Standard Publication 5-2 code}
#'   \item{ansi}{American National Standards Institute 7-digit code}
#'   \item{region}{Census Bureau region}
#'   \item{division}{Census Bureau division}
#'   \item{area}{Area in square miles}
#'   \item{lat}{Center latitudinal coordinate}
#'   \item{long}{Center longitudinal coordinate}
#' }
"states"

#' US State Abbreviations
#'
#' The 2-letter abbreviations for the US state and territory names.
#'
#' @format A character vector of length 57.
#' @source \url{https://www2.census.gov/geo/docs/reference/state.txt}
"state.abb"

#' US State Areas
#'
#' The area in square miles (converted from square meters) of the US states and territories.
#'
#' @format A numeric vector of length 57.
#' @source \url{https://tigerweb.geo.census.gov/tigerwebmain/Files/acs19/tigerweb_acs19_state_us.html}
"state.area"

#' US State Centers
#'
#' A list with components named `x` and `y` giving the approximate geographic
#' center of each state in negative longitude and latitude.
#'
#' @format A list of length two, each element a numeric vector of length 57.
#' \describe{
#'   \item{x}{Center longitudinal coordinate}
#'   \item{y}{Center latitudinal coordinate}
#' }
#' @source \url{https://tigerweb.geo.census.gov/tigerwebmain/Files/acs19/tigerweb_acs19_state_us.html}
"state.center"

#' US State Divisions
#'
#' The Census division to which each state belongs, one of nine:
#' 1. New England
#' 2. Middle Atlantic
#' 3. East North Central
#' 4. West North Central
#' 5. South Atlantic
#' 6. East South Central
#' 7. West South Central
#' 8. Mountain
#' 9. Pacific
#'
#' @format A factor vector of length 57.
#' @source \url{https://www2.census.gov/programs-surveys/popest/geographies/2018/state-geocodes-v2018.xlsx}
"state.division"

#' US State Names
#'
#' The full names for the US states and territories.
#'
#' @format A numeric vector of length 57.
#' @source \url{https://tigerweb.geo.census.gov/tigerwebmain/Files/acs19/tigerweb_acs19_state_us.html}
"state.name"

#' US State Regions
#'
#' The Census region to which each state belongs, one of four:
#' 1. Northeast
#' 2. Midwest
#' 3. South
#' 4. West
#'
#' @format A factor vector of length 57.
#' @source \url{https://www2.census.gov/programs-surveys/popest/geographies/2018/state-geocodes-v2018.xlsx}
"state.region"

# objects from info.R -----------------------------------------------------

#' US State and Territory Statistics
#'
#' Updated version of the [datasets::state.x77] matrix, which provides eight
#' statistics from the 1970's. This version is a modern data frame format
#' with updated (and alternative) statistics.
#'
#' @format A tibble with 57 rows and 9 variables:
#' \describe{
#'   \item{abb}{2-letter abbreviation}
#'   \item{population}{Population estimate as of September 26, 2019}
#'   \item{income}{Per capita income (2017)}
#'   \item{life_exp}{Life expectancy in years (2017-18)}
#'   \item{murder}{Murder rate per 100,000 population (2018)}
#'   \item{high}{Percent adult population with at least a high school degree (2019)}
#'   \item{bach}{Percent adult population with at least a bachelor's degree or greater (2019)}
#'   \item{heat}{Mean number of degree days (temperature requires heating) per year from 1981-2010}
#' }
"info"

#' US State and Territory Statistics
#'
#' A matrix version of the [info] tibble, used to more closely align with the
#' [datasets::state.x77] matrix included with R.
#'
#' @format A tibble with 57 rows and 9 variables:
#' \describe{
#'   \item{abb}{2-letter abbreviation}
#'   \item{population}{Population estimate as of September 26, 2019}
#'   \item{income}{Per capita income (2017)}
#'   \item{life_exp}{Life expectancy in years (2017-18)}
#'   \item{murder}{Murder rate per 100,000 population (2018)}
#'   \item{high}{Percent adult population with at least a high school degree (2019)}
#'   \item{bach}{Percent adult population with at least a bachelor's degree or greater (2019)}
#'   \item{heat}{Mean number of degree days (temperature requires heating) per year from 1981-2010}
#' }
"state.x19"
