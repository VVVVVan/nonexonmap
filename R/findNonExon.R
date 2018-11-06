# findNonExon.R

#' Applied to find the non-exon sequences in reads.
#'
#' \code{findNonExon} use \code{positionNonExon} to align the reads with reference sequences and output a BAM file named "findNonExonTranscripts.BAM". The return value is a data frame with all position of alignment and number of matches and unmatches.
#'
#' @param readsFile The file that store the read sequences, a string.
#' @param referencesFile The file that store the reference sequences usually transcripts, a string.
#' @return A data frame contains the name of read, name of reference seqeunces, match/unmatch position and reference start position.
#'
#' @examples
#' \dontrun{
#' readsFile <- system.file("extdata/testdata", "RRHreads.fasta", package = "nonexonmap")
#' transcriptsFile <- system.file("extdata/testdata", "RRHtranscript.fasta", package = "nonexonmap")
#' dataFrame <- findNonExon(readsFile, transcriptsFile)
#' }
#' @export
findNonExon <- function(readsFile, referencesFile) {
  NULL
}
# [END]
