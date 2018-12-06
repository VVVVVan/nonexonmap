# runNonExonApp.R

#' \code{runNonExonApp} launch the shiny app distributed with this package
#' framework
#'
#' \code{runNonExonApp} launches the shiny app for which the code has been
#' placed in  \code{./inst/shiny-scripts/nonexonmapApp/}.
#' @return No return value but will pop up a shiny page.
#'
#' @examples
#' \dontrun{
#' runNonExonApp()
#' }
#' @export

runNonExonApp <- function() {
  appDir <- system.file("shiny-scripts", "nonexonmapApp",
    package = "nonexonmap")
  shiny::runApp(appDir, display.mode = "normal")
  return()
}

# [END]
