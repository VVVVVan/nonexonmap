# verifyNonExon.R

#' Applied to verify if the non-exon sequences are introns.
#'
#' \code{verifyNonExon} use \code{positionNonExon} to align the reads with introns and output a BAM file named "verifyNonExonIntrons.BAM". The return value is a data frame with all position of alignment and number of matches and unmatches.
#'
#' @param readsFile The file that store the read sequences, a string.
#' @param referenceFile The file that store the reference sequences usually introns, a string.
#' @return A data frame contains the name of read, name of reference seqeunces, match/unmatch position and reference start position.
#'
#' @examples
#' \dontrun{
#' readsFile <- system.file("extdata/testdata", "RRHreads.fasta", package = "nonexonmap")
#' intronsFile <- system.file("extdata/testdata", "RRHintrons.fasta", package = "nonexonmap")
#' dataFrame <- verifyNonExon(readsFile, intronsFile)
#' }
#' @export
verifyNonExon <- function(readsFile, referenceFile) {
  NULL
}

# [END]
