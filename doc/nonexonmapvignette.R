## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- results='hide'-----------------------------------------------------
devtools::install_github("VVVVVan/nonexonmap")
library(nonexonmap)

## ---- eval=FALSE---------------------------------------------------------
#  runNonExonApp() # Pop out the shiny page
#  
#  readsFile <- system.file("extdata/testdata", "RRHreads.fasta", package = "nonexonmap")
#  transcriptsFile <- system.file("extdata/testdata", "RRHtranscript.fasta", package = "nonexonmap")
#  intronsFile <- system.file("extdata/testdata", "RRHintrons.fasta", package = "nonexonmap")
#  
#  mainNonExonMap(readsFile,
#                 transcriptsFile)
#  # Return the list of counts of number of non-exon exists.
#  
#  mainNonExonMap(readsFile,
#                 transcriptsFile,
#                 intronsFile)
#  # Return the list of counts of number of non-exon exists and the average introns percentage.

## ---- eval=FALSE---------------------------------------------------------
#  runNonExonApp() # Pop out the shiny page

## ------------------------------------------------------------------------
readsFile <- system.file("extdata/testdata", "RRHreads.fasta", package = "nonexonmap")
transcriptsFile <- system.file("extdata/testdata", "RRHtranscript.fasta", package = "nonexonmap")
intronsFile <- system.file("extdata/testdata", "RRHintrons.fasta", package = "nonexonmap")
mainNonExonMap(readsFile, transcriptsFile, intronsFile)

