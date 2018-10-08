# usePosition.R

#' \code{usePosition} a closure of function \code{positionNonExon.R}.
#'
#' \code{usePosition} form different output file for different purpose of using function \code{positionNonExon} To ensure that the output file of \code{positionNonExon} is in BAM format.
#'
#' @param purpose output file form to determine the outputFile name, a string.
#' @return a function.
#'
#' @seealso \code{\link{positionNonExon}} find position of matches and unmatches.
#'
#' @examples
#' \dontrun{
#' readsFile <- system.file("extdata/testdata", "RRHreads.fasta", package = "nonexonmap")
#' transcriptsFile <- system.file("extdata/testdata", "RRHtranscript.fasta", package = "nonexonmap")
#' dataFrame1 <- findNonExon(readsFile, transcriptsFile)
#' verifyNonExon <- usePosition("verify")
#' readsFile <- system.file("extdata/testdata", "RRHreads.fasta", package = "nonexonmap")
#' intronsFile <- system.file("extdata/testdata", "RRHintrons.fasta", package = "nonexonmap")
#' dataFrame2 <- verifyNonExon(readsFile, intronsFile)
#' }
#' @export
usePosition <- function(purpose) {
  outputFiles <- c("findNonExonTranscripts.BAM", "verifyNonExonIntrons.BAM")
  names(outputFiles) <- c("find", "verify")

  f <- function(readFile, referenceFile) {
    return(positionNonExon(readFile, referenceFile, outputFiles[purpose]))
  }

  return(f)
}

# [END]
