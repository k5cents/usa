#' Convert state identifiers
#'
#' Take a vector of state identifiers and convert to a common format.
#'
#' @param x A character vector of: state names, abbreviations, or FIPS codes.
#' @param to The format returned: `"abb"`, `"name"`, or `"fips"`. Defaults to
#'   `"abb"`.
#' @examples
#' state_convert(c("AL", "Vermont", "06"))
#' state_convert(c("AL", "Vermont", "06"), to = "name")
#' state_convert(c("AL", "Vermont", "06"), to = "fips")
#' @return A character vector of single format state identifiers.
#' @export
state_convert <- function(x, to = c("abb", "name", "fips")) {
  to <- match.arg(to)
  abbs <- grep("^[A-Z]{2}$", x)
  full <- grep("^[a-zA-Z ]{3,}$", x)
  fips <- grep("^\\d+$", x)
  x[fips] <- sprintf("%02d", as.numeric(x[fips]))
  match2 <- function(x, table) {
    match(tolower(x), tolower(table))
  }
  if (to == "abb") {
    x[abbs] <- usa::state.abb[match2(x[abbs], usa::state.abb)]
    x[full] <- usa::state.abb[match2(x[full], usa::state.name)]
    x[fips] <- usa::state.abb[match2(x[fips], usa::states$fips)]
  } else if (to == "name") {
    x[abbs] <- usa::state.name[match2(x[abbs], usa::state.abb)]
    x[full] <- usa::state.name[match2(x[full], usa::state.name)]
    x[fips] <- usa::state.name[match2(x[fips], usa::states$fips)]
  } else if (to == "fips") {
    x[abbs] <- usa::states$fips[match2(x[abbs], usa::state.abb)]
    x[full] <- usa::states$fips[match2(x[full], usa::state.name)]
    x[fips] <- usa::states$fips[match2(x[fips], usa::states$fips)]
  }
  return(x)
}
