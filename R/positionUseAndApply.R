# positionUseAndApply.R

#' A closure for function \code{positionNonExon}.
#'
#' \code{usePosition} form different output file for different purpose of
#' using function \code{positionNonExon} To ensure that the output file of
#' \code{positionNonExon} is in BAM format.
#'
#' @param purpose output file form to determine the outputFile name, a string.
#' @return a function.
#'
#' @examples
#' readsFile <- system.file("extdata/testdata", "RRHreads.fasta",
#' package = "nonexonmap")
#' transcriptsFile <- system.file("extdata/testdata", "RRHtranscript.fasta",
#' package = "nonexonmap")
#' \dontrun{
#' findNonExon <- usePosition("find")
#' dataFrame1 <- findNonExon(readsFile, transcriptsFile)
#' }
usePosition <- function(purpose) {
  outputFiles <- c("findNonExonTranscripts.BAM", "verifyNonExonIntrons.BAM")
  names(outputFiles) <- c("find", "verify")

  f <- function(readFile, referenceFile) {
    return(positionNonExon(readFile, referenceFile, outputFiles[purpose]))
  }

  return(f)
}

#' Applied to find the non-exon sequences in reads.
#'
#' \code{findNonExon} use \code{positionNonExon} to align the reads with
#' reference sequences and output a BAM file named
#' "findNonExonTranscripts.BAM". The return value is a data frame with all
#' position of alignment and number of matches and unmatches.
#'
#' @param readsFile The file that store the read sequences, a string.
#' @param referencesFile The file that store the reference sequences usually
#' transcripts, a string.
#' @return A data frame contains the name of read, name of reference
#' seqeunces, match/unmatch position and reference start position.
#'
#' @examples
#' readsFile <- system.file("extdata/testdata", "RRHreads.fasta",
#' package = "nonexonmap")
#' transcriptsFile <- system.file("extdata/testdata", "RRHtranscript.fasta",
#' package = "nonexonmap")
#' \dontrun{
#' dataFrame <- findNonExon(readsFile, transcriptsFile)
#' }
#' @export
findNonExon <- function(readsFile, referencesFile) {
  NULL
}

#' Applied to verify if the non-exon sequences are introns.
#'
#' \code{verifyNonExon} use \code{positionNonExon} to align the reads with
#' introns and output a BAM file named "verifyNonExonIntrons.BAM". The return
#' value is a data frame with all position of alignment and number of matches
#' and unmatches.
#'
#' @param readsFile The file that store the read sequences, a string.
#' @param referenceFile The file that store the reference sequences usually
#' introns, a string.
#' @return A data frame contains the name of read, name of reference
#' seqeunces, match/unmatch position and reference start position.
#'
#' @examples
#' readsFile <- system.file("extdata/testdata", "RRHreads.fasta",
#'   package = "nonexonmap")
#' intronsFile <- system.file("extdata/testdata", "RRHintrons.fasta",
#'  package = "nonexonmap")
#' \dontrun{
#' dataFrame <- verifyNonExon(readsFile, intronsFile)
#' }
#' @export
verifyNonExon <- function(readsFile, referenceFile) {
  NULL
}

# [END]
