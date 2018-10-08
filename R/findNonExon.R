# findNonExon.R

#' \code{findNonExon} is applied to find the non-exon sequences in reads.
#'
#' \code{findNonExon} use \code{positionNonExon} to align the reads with transcripts and output a BAM file named "findNonExonTranscripts.BAM". The return value is a data frame with all position of alignment and number of matches and unmatches. \code{findNonExon} can be called by user directly.
#'
#' @param readFile the reads file that is used as query, a string.
#' @param referenceFile the file usually transcripts that is used as reference, a string.
#' @return a data frame.
#'
#' @seealso \code{\link{usePosition}} the closure of \code{\link{positionNonExon}}
#'
#' @examples
#' \dontrun{
#' dataFram <- findNonExon("reads.fasta", "transcripts.fasta")
#' }
#' @export
findNonExon <- function(readFile, referenceFile) {
  return(data.frame())
}

# [END]
