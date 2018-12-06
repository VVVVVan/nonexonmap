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
  m[2] <- "\nThere is two functions that users can use.\n"
  m[3] <- "\nThe functions name are mainNonexonmap and runNonExonApp.\n"

  packageStartupMessage(paste(m, collapse=""))
}


# .onUnload <- function(libname, pkgname) {
#
# }



# [END]
