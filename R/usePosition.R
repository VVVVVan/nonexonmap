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
#' findNonExon <- usePosition("find")
#' dataFram1 <- findNonExon("reads.fasta", "transcript.fasta")
#' verifyNonExon <- usePosition("verify")
#' dataFram2 <- verifyNonExon("reads.fasta", "introns.fasta")
#' }
usePosition <- function(purpose) {
  outputFiles <- c("findNonExonTranscripts.BAM", "verifyNonExonIntrons.BAM")
  names(outputFiles) <- c("find", "verify")

  f <- function(readFile, referenceFile) {
    return(positionNonExon(readFile, referenceFile, outputFiles[purpose]))
  }

  return(f)
}

# [END]
