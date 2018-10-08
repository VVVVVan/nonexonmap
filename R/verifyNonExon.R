# verifyNonExon.R

#' \code{verifyNonExon} is applied to verify if the non-exon sequences are introns.
#'
#' \code{verifyNonExon} use \code{positionNonExon} to align the reads with introns and output a BAM file named "verifyNonExonIntrons.BAM". The return value is a data frame with all position of alignment and number of matches and unmatches. \code{verifyNonExon} can be called by user directly.
#'
#' @param readFile the reads file that is used as query, a string.
#' @param referenceFile the file usually introns that is used as reference, a string.
#' @return a data frame.
#'
#' @seealso \code{\link{usePosition}} the closure of \code{\link{positionNonExon}}
#'
#' @examples
#' \dontrun{
#' readsFile <- system.file("extdata/testdata", "RRHreads.fasta", package = "nonexonmap")
#' intronsFile <- system.file("extdata/testdata", "RRHintrons.fasta", package = "nonexonmap")
#' dataFrame <- verifyNonExon(readsFile, intronsFile)
#' }
#' @export
verifyNonExon <- function(readFile, referenceFile) {
  return(data.frame())
}

# [END]
