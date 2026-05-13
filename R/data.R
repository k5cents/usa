#' @importFrom tibble tibble
NULL

# objects from states.R ---------------------------------------------------

#' US State Identifiers
#'
#' The 50 states and District of Columbia — all naming and coding
#' systems used to refer to each state. The backing data for [state_convert()].
#'
#' Naming convention: underscore objects (`state_ids`, `state_facts`,
#' `state_geo`) are modern purpose-built tibbles. Convenience vectors
#' (`state_abbs`, `state_names`, etc.) mirror the base R
#' `datasets::state.*` vectors but cover all 51 rows (50 states + DC).
#'
#' @format A tibble with 51 rows and 6 variables:
#' \describe{
#'   \item{name}{Full legal name}
#'   \item{abb}{2-letter USPS abbreviation}
#'   \item{fips}{Federal Information Processing Standard Publication 5-2 code}
#'   \item{icp}{IPUMS Integrated Census Project (STATEICP) code, zero-padded
#'     2-digit string}
#'   \item{ap}{AP style abbreviation; the 8 states with no AP abbreviation
#'     (Alaska, Hawaii, Idaho, Iowa, Maine, Ohio, Texas, Utah) use the full
#'     state name per AP style}
#'   \item{iso}{ISO 3166-2 code (e.g. `"US-AL"`)}
#' }
#' @source
#' * Names, abbreviations, FIPS: \url{https://www2.census.gov/geo/docs/reference/state.txt}
#' * ICP codes: \url{https://usa.ipums.org/usa-action/variables/STATEICP}
#' * AP abbreviations: AP Stylebook
#' * ISO 3166-2: ISO Online Browsing Platform
"state_ids"

#' US State Geography
#'
#' Geographic and classificatory properties for the 50 states and District of
#' Columbia. Keyed by \code{abb} to join with [state_ids].
#'
#' @format A tibble with 51 rows and 10 variables:
#' \describe{
#'   \item{abb}{2-letter USPS abbreviation (join key)}
#'   \item{region}{Census Bureau region}
#'   \item{division}{Census Bureau division}
#'   \item{area_land}{Land area in square miles}
#'   \item{area_water}{Water area in square miles}
#'   \item{lat}{Centroid latitudinal coordinate}
#'   \item{long}{Centroid longitudinal coordinate}
#'   \item{contiguous}{\code{TRUE} for the 48 contiguous states and DC;
#'     \code{FALSE} for Alaska and Hawaii}
#'   \item{landlocked}{\code{TRUE} for states with no coastline on an ocean,
#'     gulf, or Great Lake (21 states including DC)}
#'   \item{peak_elev}{Elevation of the state high point in feet}
#' }
#' @source
#' * Regions and divisions: \url{https://www2.census.gov/programs-surveys/popest/geographies/2018/state-geocodes-v2018.xlsx}
#' * Area and centroids: TIGER/Web REST API (State_County layer)
#' * Peak elevations: USGS state high point records
"state_geo"

#' US State Capitals
#'
#' Capital cities for the 50 states and District of Columbia,
#' with coordinates and 2020 Census population.
#'
#' @format A tibble with 51 rows and 5 variables:
#' \describe{
#'   \item{abb}{2-letter USPS abbreviation (join key)}
#'   \item{capital}{Capital city name}
#'   \item{lat}{Latitudinal coordinate of the capital}
#'   \item{long}{Longitudinal coordinate of the capital}
#'   \item{population}{Capital city population (2020 Decennial Census,
#'     city proper)}
#' }
#' @source \url{https://www.census.gov/quickfacts/}
"state_capitals"

#' US Territories
#'
#' The 6 US territories: Puerto Rico (PR) and the 5 island territories
#' (AS, GU, MP, UM, VI).
#'
#' @format A tibble with 6 rows and 6 variables:
#' \describe{
#'   \item{abb}{2-letter abbreviation}
#'   \item{name}{Full legal name}
#'   \item{fips}{Federal Information Processing Standard Publication 5-2 code}
#'   \item{area}{Area in square miles}
#'   \item{lat}{Center latitudinal coordinate}
#'   \item{long}{Center longitudinal coordinate}
#' }
"territory"

#' US State Abbreviations
#'
#' The 2-letter USPS abbreviations for the 50 states and District of Columbia.
#' Parallel to [state_names].
#'
#' @format A character vector of length 51.
#' @source \url{https://www2.census.gov/geo/docs/reference/state.txt}
"state_abbs"

#' US Territory Abbreviations
#'
#' The 2-letter abbreviations for the US territories (PR, AS, GU, MP, UM, VI).
#'
#' @format A character vector of length 6.
#' @source \url{https://www2.census.gov/geo/docs/reference/state.txt}
"territory_abbs"

#' US State Land Areas
#'
#' Land area in square miles for the 50 states and District of Columbia.
#' Parallel to [state_names].
#'
#' @format A numeric vector of length 51.
#' @source TIGER/Web REST API (State_County layer)
"state_areas"

#' US Territory Areas
#'
#' The area in square miles of the US territories (PR, AS, GU, MP, UM, VI).
#'
#' @format A numeric vector of length 6.
#' @source TIGER/Web REST API (State_County layer)
"territory_areas"

#' US State Geographic Centers
#'
#' A list with components named `x` and `y` giving the approximate geographic
#' centroid of each state in longitude and latitude. Parallel to [state_names].
#'
#' @format A list of length two, each element a numeric vector of length 51.
#' \describe{
#'   \item{x}{Centroid longitudinal coordinate}
#'   \item{y}{Centroid latitudinal coordinate}
#' }
#' @source TIGER/Web REST API (State_County layer)
"state_centers"

#' US Territory Geographic Centers
#'
#' A list with components named `x` and `y` giving the approximate geographic
#' center of each territory in longitude and latitude.
#'
#' @format A list of length two, each element a numeric vector of length 6.
#' \describe{
#'   \item{x}{Center longitudinal coordinate}
#'   \item{y}{Center latitudinal coordinate}
#' }
#' @source TIGER/Web REST API (State_County layer)
"territory_centers"

#' US State Census Divisions
#'
#' The Census division to which each state belongs, one of nine. Parallel to
#' [state_names].
#'
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
#' @format A factor vector of length 51.
#' @source \url{https://www2.census.gov/programs-surveys/popest/geographies/2018/state-geocodes-v2018.xlsx}
"state_divisions"

#' US State Names
#'
#' The full names for the 50 states and District of Columbia.
#' Parallel to [state_abbs].
#'
#' @format A character vector of length 51.
#' @source \url{https://www2.census.gov/geo/docs/reference/state.txt}
"state_names"

#' US Territory Names
#'
#' The full names for the US territories (PR, AS, GU, MP, UM, VI).
#'
#' @format A character vector of length 6.
#' @source \url{https://www2.census.gov/geo/docs/reference/state.txt}
"territory_names"

#' US State Census Regions
#'
#' The Census region to which each state belongs, one of four. Parallel to
#' [state_names].
#'
#' 1. Northeast
#' 2. Midwest
#' 3. South
#' 4. West
#'
#' @format A factor vector of length 51.
#' @source \url{https://www2.census.gov/programs-surveys/popest/geographies/2018/state-geocodes-v2018.xlsx}
"state_regions"

# objects from facts.R -----------------------------------------------------

#' US State Facts
#'
#' Updated version of the [datasets::state.x77] matrix, which provided eight
#' statistics from the 1970s. This version is a modern tibble with updated
#' statistics.
#'
#' See also [state_ids] for state identifiers and [state_geo] for geography.
#'
#' @format A tibble with 51 rows and 9 variables:
#' \describe{
#'   \item{name}{Full state name}
#'   \item{population}{Resident population (2020 Decennial Census, April 1, 2020)}
#'   \item{electors}{Votes in the Electoral College (2020 Census reapportionment, applies 2022–2032)}
#'   \item{admission}{The date on which the state was admitted to the union}
#'   \item{income}{Per capita income in dollars (2022 ACS 1-year)}
#'   \item{life_exp}{Life expectancy at birth in years, both sexes (2021 NCHS)}
#'   \item{murder}{Homicide rate per 100,000 population (2022 FBI NIBRS)}
#'   \item{college}{Proportion of population 25+ with a bachelor's degree or higher (2022 ACS 1-year)}
#'   \item{frost}{Mean number of days per year with minimum temperature below freezing (1991-2020 NCEI Climate Normals)}
#' }
#' @source
#' * Population: 2020 Decennial Census PL 94-171 file, variable \code{P1_001N} via tidycensus
#' * Electoral College: 2020 Census reapportionment (NARA \url{https://www.archives.gov/electoral-college/allocation})
#' * Income: 2022 ACS 1-year, variable \code{B19301_001} (per capita income) via tidycensus
#' * Life Expectancy: NCHS 2021 state life tables via \url{https://data.cdc.gov/api/views/it4f-frdc/rows.csv}
#' * Murder: FBI Crime Data Explorer API (2022 NIBRS)
#' * Education: 2022 ACS 1-year Subject Table S1501, variable \code{S1501_C02_015} via tidycensus
#' * Frost: NCEI 1991-2020 Climate Normals, variable \code{ANN-TMIN-AVGNDS-LSTH032}, \url{https://www.ncei.noaa.gov/data/normals-annualseasonal/1991-2020/}
"state_facts"

# objects from people.R ---------------------------------------------------

#' Synthetic Sample of US population
#'
#' A statistically representative synthetic sample of 20,000 Americans. Each
#' record is a simulated survey respondent.
#'
#' @details
#' This dataset was originally produced by the Pew Research center for their
#' paper entitled [_For Weighting Online Opt-In Samples, What Matters Most?_][1]
#' The synthetic population dataset was created to serve as a reference for
#' making online opt-in surveys more representative of the overall population.
#'
#' See [Appendix B: Synthetic population dataset][2] for a more detailed
#' description of the method for and rationale behind creating this dataset.
#'
#' In short, the dataset was created to overcome the limitations of using large,
#' federal benchmark survey datasets such as the American Community Survey (ACS)
#' or Current Population Survey (CPS). These surveys often do not contain the
#' exact questions asked in online-opt in surveys, keeping them from being used
#' for proper adjustment.
#'
#' This _synthetic_ dataset was created by combining nine separate benchmark
#' datasets. Each had a set of common demographic variables but many added
#' unique variables such as gun ownership or voter registration. The surveys
#' were combined, stratified, sampled, combined, and imputed to fill missing
#' values from each. From this large dataset, the original 20,000 surveys from
#' the ACS were kept to ensure accurate demographic distribution.
#'
#' The names were randomly assigned to respondents to better simulate a
#' synthetic sample of the population. First names were taken from the
#' `babynames` dataset which contains the Social Security Administration's
#' record of baby names from 1880 to 2017 along with gender and proportion.
#' First names were proportionally randomly assigned by birth year and sex. Last
#' names were taken from the Census Bureau, who provides the 162,254 most common
#' last names in the 2010 Census, covering over 90% of the population. For a
#' given surname, the proportion of that name belonging to members of each race
#' and ethnicity is provided. The last names were proportionally randomly
#' assigned by race.
#'
#' [1]: https://www.pewresearch.org/methods/2018/01/26/for-weighting-online-opt-in-samples-what-matters-most/
#' [2]: https://www.pewresearch.org/methods/2018/01/26/appendix-b-synthetic-population-dataset/
#'
#' @format A tibble with 20,000 rows and 40 variables:
#' \describe{
#'   \item{id}{Sequential unique ID}
#'   \item{fname}{Random first name, see details}
#'   \item{lname}{Random last name, see details}
#'   \item{gender}{Gender (male/female)}
#'   \item{age}{Age capped at 85}
#'   \item{race}{Race and Ethnicity}
#'   \item{edu}{Educational attainment}
#'   \item{div}{Census regional division}
#'   \item{married}{Marital status}
#'   \item{house_size}{Household size}
#'   \item{children}{Has children}
#'   \item{us_citizen}{Is a US citizen}
#'   \item{us_born}{Was born in the US}
#'   \item{house_income}{Family income}
#'   \item{emp_status}{Employment status}
#'   \item{emp_sector}{Employment sector}
#'   \item{hours_work}{Hours worked per week}
#'   \item{hours_vary}{Hours vary week to week}
#'   \item{mil}{Has served in the military}
#'   \item{house_own}{Home ownership}
#'   \item{metro}{Lives in metropolitan area}
#'   \item{internet}{Household has internet access}
#'   \item{foodstamp}{Receives food stamps}
#'   \item{house_moved}{Moved in the last year}
#'   \item{pub_contact}{Contacted or visited a public official}
#'   \item{boycott}{Participated in a product boycott}
#'   \item{hood_group}{Participated in a community association}
#'   \item{hood_talks}{Talked with neighbors}
#'   \item{hood_trust}{Trusts neighbors}
#'   \item{tablet}{Uses a tablet or e-reader}
#'   \item{texting}{Uses text messaging}
#'   \item{social}{Uses social media}
#'   \item{volunteer}{Volunteered}
#'   \item{register}{Is registered to vote}
#'   \item{vote}{Voted in the most recent midterm election}
#'   \item{party}{Political party}
#'   \item{religion}{Religious (evangelical) affiliation}
#'   \item{ideology}{Political ideology}
#'   \item{govt}{Follows government and public affairs}
#'   \item{guns}{Owns a gun}
#' }
#' @source “For Weighting Online Opt-In Samples, What Matters Most?” Pew
#'   Research Center, Washington, D.C. (January 26, 2018)
#'   \url{https://www.pewresearch.org/methods/2018/01/26/for-weighting-online-opt-in-samples-what-matters-most/}
"people"

# objects from zipcodes.R -------------------------------------------------

#' US ZIP Code Locations
#'
#' This tibble contains city, state, latitude, and longitude for U.S. ZIP codes
#' from the CivicSpace Database (August 2004) augmented by Daniel Coven's [web
#' site](https://federalgovernmentzipcodes.us/) (updated on January 22, 2012).
#' The data was originally contained in the
#' [`zipcode`](https://CRAN.R-project.org/package=zipcode) CRAN package, which
#' was archived on January 1, 2020.
#'
#' @format A tibble with 44,336 rows and 5 variables:
#' \describe{
#'   \item{zip}{5 digit ZIP code or military postal code (FPO/APO)}
#'   \item{city}{USPS official city name}
#'   \item{state}{USPS official state, territory abbreviation code}
#'   \item{lat}{Decimal latitude}
#'   \item{long}{Decimal longitude}
#' }
#' @source Daniel Coven's [web site](https://federalgovernmentzipcodes.us/) and
#'   the CivicSpace US ZIP Code Database written by Schuyler Erle
#'   <schuyler@geocoder.us>, 5 August 2004.
"zipcodes"

#' US ZIP Codes
#'
#' The United States Postal Service's 5-digit codes used to identify a
#' particular postal delivery area.
#'
#' @format A character vector of length 44336.
#' @source Daniel Coven's [web site](https://federalgovernmentzipcodes.us/) and
#'   the CivicSpace US ZIP Code Database written by Schuyler Erle
#'   <schuyler@geocoder.us>, 5 August 2004.
"zip_codes"

#' US ZIP Centers
#'
#' A list with components named `x` and `y` giving the approximate geographic
#' center of each ZIP code in longitude and latitude.
#'
#' @format A list of length two, each element a numeric vector of length 44336.
#' \describe{
#'   \item{x}{Center longitudinal coordinate}
#'   \item{y}{Center latitudinal coordinate}
#' }
#' @source Daniel Coven's [web site](https://federalgovernmentzipcodes.us/) and
#'   the CivicSpace US ZIP Code Database written by Schuyler Erle
#'   <schuyler@geocoder.us>, 5 August 2004.
"zip_centers"

#' US ZIP Cities
#'
#' The United States Postal Service's official names for the cities in which
#' ZIP codes are contained. This vector contains unique values, sorted
#' alphabetically; because of this, they do not line up the other vectors in the
#' way [zip_codes] and [zip_centers] do.
#'
#' @format A character vector of length 19108.
#' @source Daniel Coven's [web site](https://federalgovernmentzipcodes.us/) and
#'   the CivicSpace US ZIP Code Database written by Schuyler Erle
#'   <schuyler@geocoder.us>, 5 August 2004.
"city_names"

#' US Counties
#'
#' The county subdivisions of the US states and territories.
#'
#' @format A tibble with 3,235 rows and 3 variables:
#' \describe{
#'   \item{fips}{Five-digit FIPS code (state FIPS + county FIPS)}
#'   \item{name}{County name (type suffix such as "County", "Parish", "Borough" removed)}
#'   \item{state}{USPS state/territory abbreviation}
#' }
#' @source Census TIGER 2020 national county reference file,
#'   \url{https://www2.census.gov/geo/docs/reference/codes2020/national_county2020.txt}
"counties"

#' US County Names
#'
#' The name of distinct US counties.
#'
#' @format A character vector of length 1,925.
#' @source Census TIGER 2020 national county reference file,
#'   \url{https://www2.census.gov/geo/docs/reference/codes2020/national_county2020.txt}
"county_names"
