# mainNonExonMap.R

#' An main function to plot the non-exon on reference gene.
#'
#' \code{mainNonExonMap} This is the main function for my functions in this package. The function will plot the non-exon position on reference gene and if they are introns (if intronsFile exist).
#'
#' @param readsFile The file that store the read sequences, a string.
#' @param transcriptsFile The file that store the reference sequences, a string.
#' @param intronsFile The file that contains the intron sequences, a string.
#' @return A list of list with reference name, alignment position, alignment counts and percentage of introns if there is a verifyDataFrame.
#'
#' @examples
#' \dontrun{
#' readsFile <- system.file("extdata/testdata", "RRHreads.fasta", package = "nonexonmap")
#' transcriptsFile <- system.file("extdata/testdata", "RRHtranscript.fasta", package = "nonexonmap")
#' intronsFile <- system.file("extdata/testdata", "RRHintrons.fasta", package = "nonexonmap")
#' mainNonExonMap(readsFile, transcriptsFile)
#' mainNonExonMap(readsFile, transcriptsFile, intronsFile)
#' }
#' @export
mainNonExonMap <- function(readsFile, transcriptsFile, intronsFile = "") {
  # Set up two function for the user.
  findNonExon <- usePosition("find")
  verifyNonExon <- usePosition("verify")

  # Define the position of introns on references gene first
  dataFrame <- findNonExon(readsFile, transcriptsFile)

  # Plot according to if there is introns file exists
  if (intronsFile == "") {
    # plot the position only
    result <- countNonExon(dataFrame)
  } else {
    # plot how many of non-exon are introns and position in two graph
    verifydataFram <- verifyNonExon(readsFile, intronsFile)
    result <- countNonExon(dataFrame, verifydataFram)
  }

  # Delete the files
  file.remove(list.files("./", pattern = "^output.BAM"))
  file.remove(list.files("./", pattern = "^my_index"))
  file.remove(list.files("./",pattern = "^findNonExonTranscripts.BAM"))
  file.remove(list.files("./",pattern = "^verifyNonExonIntrons.BAM"))

  return(result)
}

# [END]
