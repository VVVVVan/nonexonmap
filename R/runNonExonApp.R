# runNonExonApp.R

#' \code{runNonExonApp} launch the shiny app distributed with this package framework
#'
#' \code{runNonExonApp} launches the shiny app for which the code has been placed in  \code{./inst/shiny-scripts/nonexonmapApp/}.
#' @export

runNonExonApp <- function() {
  appDir <- system.file("shiny-scripts", "nonexonmapApp", package = "nonexonmap")
  shiny::runApp(appDir, display.mode = "normal")
  return()
}

# [END]
