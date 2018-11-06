# mainNonexonmap.R

#' An main function to plot the non-exon on reference gene.
#'
#' \code{mainNonexonmap} This is the main function for my functions in this package. The function will plot the non-exon position on reference gene and if they are introns (if intronsFile exist).
#'
#' @param readsFile The file that store the read sequences, a string.
#' @param referencesFile The file that store the reference sequences, a string.
#' @param intronsFile The file that contains the intron sequences, a string.
#' @return A hist of the position non-exon sequences on reference sequences.
#'
#' @examples
#' \dontrun{
#' readsFile <- system.file("extdata/testdata", "RRHreads.fasta", package = "nonexonmap")
#' transcriptsFile <- system.file("extdata/testdata", "RRHtranscript.fasta", package = "nonexonmap")
#' intronsFile <- system.file("extdata/testdata", "RRHintrons.fasta", package = "nonexonmap")
#' mainNonexonmap(readsFile, transcriptsFile)
#' mainNonexonmap(readsFile, transcriptsFile, intronsFile)
#' }
#' @export
mainNonexonmap <- function(readsFile, referencesFile, intronsFile = "") {
  if (intronsFile == "") {
    # plot the position only
    dataFrame <- findNonExon(readsFile, referencesFile)
    result <- plotNonExon(countNonExon(dataFrame))
  } else {
    # plot how many of non-exon are introns and position in two graph
    verifydataFram <- verifyNonExon(readsFile, intronsFile)
    plotNonExon(countNonExon(dataFrame, verifydataFram))
  }

  # Delete the files
  file.remove(list.files("./", pattern = "^output.BAM"))
  file.remove(list.files("./", pattern = "^my_index"))
  file.remove(list.files("./",pattern = "^findNonExonTranscripts.BAM"))
  file.remove(list.files("./",pattern = "^verifyNonExonIntrons.BAM"))

  return(result)
}

# [END]
