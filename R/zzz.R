.onAttach <- function(libname, pkgname) {
  masked <- c(
    "state.abb",
    "state.area",
    "state.center",
    "state.division",
    "state.name",
    "state.region"
  )
  masked <- paste("*", masked, collapse = "\n")
  msg <- c(
    "The 'usa' package masks the state datasets included in base R:\n",
    masked,
    "\nObjects are similar in class and content but updated and expanded."
  )
  packageStartupMessage(msg)
}
