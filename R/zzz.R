#' Load package dependencies
#'
#' @param libname libname
#' @param pkgname pkgname
#' @importFrom shiny addResourcePath
#' @return Load package dependencies
#' @noRd

.onLoad <- function(libname, pkgname) {
  shiny::addResourcePath(
    "ShinyRating-assets",
    system.file("assets", package = "ShinyFriendlyCaptcha")
  )
}
