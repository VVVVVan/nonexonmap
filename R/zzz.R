# zzz.R
#
# Package startup and unload functions



.onLoad <- function(libname, pkgname) {
  # Set up two function for the user.
  findNonExon <- usePosition("find")
  verifyNonExon <- usePosition("verify")

    invisible()
}


.onAttach <- function(libname, pkgname) {
  # Startup message
  m <- character()
  m[1] <- "\nWelcome to nonexonmap.\n"
  m[2] <- "\nThere are four function that users can use.\n"
  m[3] <- "\nThe function names are findNonExon, verifyNonExon, countNonExon, and plotNonExon.\n"
  m[4] <- "\nThere are also some help functions like positionNonExon, usePosition, countPositionHelp.\n"

  packageStartupMessage(paste(m, collapse=""))
}


# .onUnload <- function(libname, pkgname) {
#
# }



# [END]
