#' Convert state identifiers
#'
#' Take a vector of state identifiers and convert to a common format.
#'
#' @param x A character vector of: state names, abbreviations, or FIPS codes.
#' @param to The format returned: name, abbreviation, or FIPS codes.
#' @return A character vector of single format state identifiers.
#' @examples
#' state_convert(c("AL", "Vermont", "06"))
#' @export
state_convert <- function(x, to = NULL) {
  to <- match.arg(to, c("abb", "names", "fips"), several.ok = FALSE)
  abbs <- grep("^[A-Z]{2}$", x)
  full <- grep("^[A-z]{3,}$", x)
  fips <- grep("^\\d+$", x)
  x[fips] <- sprintf("%02d", as.numeric(x[fips]))
  if (to == "abb") {
    x[full] <- usa::state.abb[match(x[full], usa::state.name)]
    x[fips] <- usa::state.abb[match(x[fips], usa::states$fips)]
  } else if (to == "names") {
    x[abbs] <- usa::state.name[match(x[abbs], usa::state.abb)]
    x[fips] <- usa::state.name[match(x[fips], usa::states$fips)]
  } else if (to == "fips") {
    x[abbs] <- usa::states$fips[match(x[abbs], usa::state.abb)]
    x[full] <- usa::states$fips[match(x[full], usa::state.name)]
  }
  return(x)
}
