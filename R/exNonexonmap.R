# exNonexonmap.R

#' An example of calling functions in my package.
#'
#' \code{exNonexonmap} This is the example call of my functions with inputs from my extdata.
#'
#' @return A hist of the position non-exon sequences on reference sequences.
#'
#' @examples
#' exNonexonmap()
#' @export
exNonexonmap <- function() {
  # Read the files
  readsFile <- system.file("extdata/testdata", "RRHreads.fasta", package = "nonexonmap")
  transcriptsFile <- system.file("extdata/testdata", "RRHtranscript.fasta", package = "nonexonmap")
  intronsFile <- system.file("extdata/testdata", "RRHintrons.fasta", package = "nonexonmap")
  # Initial the closure functions
  findNonExon <- usePosition("find")
  verifyNonExon <- usePosition("verify")

  # plot the position only
  dataFrame <- findNonExon(readsFile, transcriptsFile)
  result <- plotNonExon(countNonExon(dataFrame))

  # plot how many of non-exon are introns and position in two graph
  # (Sorry for the fact that non-exon consistion is only available in function
  # and is replaced by the position plot when grDevices::dev.off() is called in
  # plotNonExon.R, need to combine those in further improvements)
  verifydataFram <- verifyNonExon(readsFile, intronsFile)
  plotNonExon(countNonExon(dataFrame, verifydataFram))

  # Delete the files
  file.remove(list.files("./", pattern = "^output.BAM"))
  file.remove(list.files("./", pattern = "^my_index"))
  file.remove(list.files("./",pattern = "^findNonExonTranscripts.BAM"))
  file.remove(list.files("./",pattern = "^verifyNonExonIntrons.BAM"))

  return(result)
}

# [END]
