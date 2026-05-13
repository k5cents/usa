#' Convert state identifiers
#'
#' Take a vector of state identifiers and convert to a common format.
#' Supports all five identifier types in [state_ids]: USPS abbreviation,
#' full name, FIPS code, AP style abbreviation, and ISO 3166-2 code.
#'
#' @param x A character vector of state identifiers in any supported format.
#' @param to The format returned: `"abb"`, `"name"`, `"fips"`, `"ap"`, or
#'   `"iso"`. Defaults to `"abb"`.
#' @examples
#' state_convert(c("AL", "Vermont", "06"))
#' state_convert(c("AL", "Vermont", "06"), to = "name")
#' state_convert(c("AL", "Vermont", "06"), to = "fips")
#' state_convert(c("AL", "Vermont", "06"), to = "ap")
#' state_convert(c("AL", "Vermont", "06"), to = "iso")
#' @return A character vector of single format state identifiers.
#' @export
state_convert <- function(x, to = c("abb", "name", "fips", "ap", "iso")) {
  to <- match.arg(to)
  ids <- usa::state_ids
  match2 <- function(x, table) match(tolower(x), tolower(table))

  # Detect input type by pattern
  is_abb  <- grep("^[A-Z]{2}$", x)              # 2 uppercase letters
  is_iso  <- grep("^US-[A-Z]{2}$", x)           # ISO 3166-2 "US-XX"
  is_fips <- grep("^\\d+$", x)                  # all digits
  is_ap   <- grep("\\.", x)                      # contains a period => AP style
  # Full name: everything else (3+ alpha+space chars, no period)
  is_name <- grep("^[a-zA-Z ]{3,}$", x)

  x[is_fips] <- sprintf("%02d", as.numeric(x[is_fips]))

  to_col <- function(idx, from_col) ids[[to]][match2(x[idx], ids[[from_col]])]

  x[is_abb]  <- to_col(is_abb,  "abb")
  x[is_name] <- to_col(is_name, "name")
  x[is_fips] <- to_col(is_fips, "fips")
  x[is_ap]   <- to_col(is_ap,   "ap")
  x[is_iso]  <- to_col(is_iso,  "iso")

  return(x)
}
