#' @importFrom tibble tibble
NULL

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

# objects from people.R ---------------------------------------------------

#' Synthetic Sample of US population
#'
#' This dataset was originally produced by the Pew Research center for their paper entitled
#' [_For Weighting Online Opt-In Samples, What Matters Most?_](https://www.pewresearch.org/methods/wp-content/uploads/sites/10/2018/01/Weighting-Online-Opt-In-Samples.pdf)
#' The synthetic population dataset was created to serve as a reference for making online opt-in
#' surveys more representative of the overall population.
#'
#' @details
#' See [Appendix B: Synthetic population dataset](https://www.pewresearch.org/methods/2018/01/26/appendix-b-synthetic-population-dataset/)
#' for a more detailed description of the method for and rationale behind creating this dataset.
#'
#' In short, the dataset was created to overcome the limitations of using large, federal benchmark
#' survey datasets such as the American Community Survey (ACS) or Current Population Survey (CPS).
#' These surveys often do not contain the exact questions asked in online-opt in surveys, keeping
#' them from being used for proper adjustment.
#'
#' This _synthetic_ dataset was created by combining nine separate benchmark datasets. Each had a
#' set of common demographic variables but many added unique variables such as gun ownership or
#' voter registration. The surveys were combined, stratified, sampled, combined, and imputed to
#' fill missing values from each. From this large dataset, the original 20,000 surveys from the ACS
#' were kept to ensure accurate demographic distribution.
#'
#' The names were _RANDOMLY_ assigned to respondents to better simulate a synthetic sample of the
#' population. First names were taken from the [babynames::babynames] dataset which contains the
#' Social Security Administration's record of baby names from 1880 to 2017 along with gender and
#' proportion. First names were proportionally randomly assigned by birth year and sex. Last names
#' were taken from the Census Bureau, who provides the 162,254 most common last names in the 2010
#' Census, covering over 90% of the population. For a given surname, the proportion of that name
#' belonging to members of each race and ethnicity is provided. The last names were proportionally
#' randomly assigned by race.
#'
#' @format A tibble with 20,000 rows and 40 variables:
#' \describe{
#'   \item{id}{Sequential unique ID}
#'   \item{fname}{Random first name, see details}
#'   \item{lname}{Random last name, see details}
#'   \item{gender}{Biological sex}
#'   \item{age}{Age capped at 85}
#'   \item{race}{Race and Ethnicity}
#'   \item{edu}{Educational attainment}
#'   \item{div}{Census regional division}
#'   \item{married}{Marital status}
#'   \item{house_size}{Household size}
#'   \item{children}{Has children}
#'   \item{us_citizen}{Is a US citizen}
#'   \item{us_born}{Was born in the Us}
#'   \item{house_income}{Family income}
#'   \item{emp_status}{Employment status}
#'   \item{emp_sector}{Employment sector}
#'   \item{hours_work}{Hours worked per week}
#'   \item{hours_vary}{Hours vary week to week}
#'   \item{mil}{Has served in the military}
#'   \item{house_own}{Home ownership}
#'   \item{metro}{Lives in metropolitan area}
#'   \item{internet}{Household has internet access}
#'   \item{foodstamp}{Recieves foodstamps}
#'   \item{house_moved}{Moved in the last year}
#'   \item{pub_contact}{Contacted or visited a public official}
#'   \item{boycott}{}
#'   \item{hood_group}{Participated in a community association}
#'   \item{hood_talks}{Talked with neighbors}
#'   \item{hood_trust}{Trusts neighbors}
#'   \item{tablet}{Uses a tablet or e-reader}
#'   \item{texting}{Uses text messaging}
#'   \item{social}{Uses social media}
#'   \item{volunteer}{Volunteered}
#'   \item{register}{Is registered to vote}
#'   \item{vote}{Voted in the 2014 midterm elections}
#'   \item{party}{Political party}
#'   \item{religion}{Religious (evangelical) affilitation}
#'   \item{ideology}{Political ideology}
#'   \item{govt}{Follows government and public affairs}
#'   \item{guns}{Owns a gun}
#' }
#' @source “For Weighting Online Opt-In Samples, What Matters Most?” Pew
#'   Research Center, Washington, D.C. (January 26, 2018)
#'   \url{http://pewrsr.ch/2rNawC7}
"people"



# objects from zipcodes.R -------------------------------------------------

#' US ZIP Code Locations
#'
#' This tibble contains city, state, latitude, and longitude for U.S. ZIP
#' codes from the CivicSpace Database (August 2004) augmented by Daniel Coven's
#' [web site](http://federalgovernmentzipcodes.us/) (updated on January 22,
#' 2012). The data was originally contained in the
#' [`zipcodes`](https://CRAN.R-project.org/package=zipcode) CRAN package, which
#' was archived on Janurary 1, 2020.
#'
#' @format A tibble with 57 rows and 9 variables:
#' \describe{
#'   \item{zip}{5 digit Zipcode or military postal code (FPO/APO)}
#'   \item{city}{USPS offical city name}
#'   \item{state}{USPS offical state, territory abbreviation code}
#'   \item{latitude}{Decimal Latitude}
#'   \item{longitude}{Decimal Longitude}
#' }
#' @source Daniel Coven's [web site](http://federalgovernmentzipcodes.us/) and
#'   the CivicSpace US ZIP Code Database written by Schuyler Erle
#'   <schuyler@geocoder.us>, 5 August 2004.
"zipcodes"

#' US ZIP Codes
#'
#' The United States Postal Service's 5-digit codes used to identify a
#' particular postal delivery area.
#'
#' @format A character vector of length 44336.
#' @source Daniel Coven's [web site](http://federalgovernmentzipcodes.us/) and
#'   the CivicSpace US ZIP Code Database written by Schuyler Erle
#'   <schuyler@geocoder.us>, 5 August 2004.
"zip.code"

#' US ZIP Centers
#'
#' A list with components named `x` and `y` giving the approximate geographic
#' center of each ZIP code in negative longitude and latitude.
#'
#' @format A list of length two, each element a numeric vector of length 44336.
#' \describe{
#'   \item{x}{Center longitudinal coordinate}
#'   \item{y}{Center latitudinal coordinate}
#' }
#' @source Daniel Coven's [web site](http://federalgovernmentzipcodes.us/) and
#'   the CivicSpace US ZIP Code Database written by Schuyler Erle
#'   <schuyler@geocoder.us>, 5 August 2004.
"zip.center"

#' US ZIP Cities
#'
#' The United States Postal Service's official names for the cities in which
#' ZIP codes are contained. This vector contains unique values, sorted
#' alphabetically; because of this, they do not line up the other vectors in the
#' way [zip.code] and [zip.center] do.
#'
#' @format A character vector of length 19108.
#' @source Daniel Coven's [web site](http://federalgovernmentzipcodes.us/) and
#'   the CivicSpace US ZIP Code Database written by Schuyler Erle
#'   <schuyler@geocoder.us>, 5 August 2004.
"city.name"

#' US Counties
#'
#' The county subdivisions of the US states and territories.
#'
#' @format A tibble with 3,232 rows and 3 variables:
#' \describe{
#'   \item{fips}{Federal Information Processing Standard Publication 5-2 code}
#'   \item{name}{Census county names}
#'   \item{state}{USPS offical state, territory abbreviation code}
#' }
#' @source Kyle Walker (2020). tidycensus: Load US Census Boundary and Attribute
#'   Data as 'tidyverse' and 'sf'-Ready Data Frames. R package version 0.9.6.
#'   https://CRAN.R-project.org/package=tidycensus
"counties"

#' US County Names
#'
#' The name of distinct US counties.
#'
#' @format A character vector of length 19108.
#' @source Kyle Walker (2020). tidycensus: Load US Census Boundary and Attribute
#'   Data as 'tidyverse' and 'sf'-Ready Data Frames. R package version 0.9.6.
#'   https://CRAN.R-project.org/package=tidycensus
"county.name"
