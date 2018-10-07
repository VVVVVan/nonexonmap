# zzz.R
#
# Package startup and unload functions



.onLoad <- function(libname, pkgname) {
  # Install the Rsubread package to use some of its functions
  if (! require(Rsubread, quietly=TRUE)) {
    source("http://bioconductor.org/biocLite.R")
    biocLite("Rsubread")
    library(Rsubread)
  }

  if (! require(GenomeInfoDb, quietly=TRUE)) {
    biocLite("GenomeInfoDb")
    library(GenomeInfoDb)
  }

  if (! require(Rsamtools, quietly=TRUE)) {
    biocLite("Rsamtools")
    library(Rsamtools)
  }

  # Set up two function for the user.
  findNonExon <- usePosition("find")
  verifyNonExon <- usePosition("verify")

    # # Make list of package parameters and add to global options
    #
    # # filepath of logfile
    # optRpt <- list(rpt.logfile = logFileName() )
    #
    # # add more options ...
    # optRpt[["nameOfOption"]] <- value
    #
    # optionsToSet <- !(names(optRpt) %in% names(options()))
    #
    # if(any(optionsToSet)) {
    #     options(optShi[optionsToSet])
    # }

    invisible()
}


.onAttach <- function(libname, pkgname) {
  # Startup message
  m <- character()
  m[1] <- "\nWelcome to nonexonmap.\n"

  packageStartupMessage(paste(m, collapse=""))
}


# .onUnload <- function(libname, pkgname) {
#
# }



# [END]
