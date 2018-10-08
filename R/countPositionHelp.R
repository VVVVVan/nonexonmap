# countPositionHelp.R

#' help \code{countNonExon} to count the numbers and the position of non-exon sequences on reference sequences.
#'
#' \code{countPositionHelp} is a help function for \code{countNonExon}. It take the data frame and analyze the number of non-exon sequences on a specific place in references.
#'
#' @param informationdf the data frame that store the information for funciton to analyze. Should compute from \code{findNonExon}, \code{verifyNonExon} or relateive functions.
#' @return A list of lists with order of reference sequences name, aligned index on reference sequence, number of aligned reads on the spot.
#'
#' @seealso \code{\link{findNonExon}}, \code{\link{verifyNonExon}} compute the input for this function.
#'
#' @examples
#' \dontrun{
#' readsFile <- system.file("extdata/testdata", "RRHreads.fasta", package = "nonexonmap")
#' transcriptsFile <- system.file("extdata/testdata", "RRHtranscript.fasta", package = "nonexonmap")
#' dataFrame <- findNonExon(readsFile, transcriptsFile)
#' countPositionHelp(dataFrame)
#' }
#' @export
countPositionHelp <- function(informationdf) {
  if (! Reduce("&", c("referenceName", "referenceStart", "readUnmatch",
    "readMatch") %in% rownames(informationdf))) {
    stop("The input should be a data frame in specify format. See help.")
  }
  # Find the unique reference sequeces. StrikeR. (2018). StackOverflow
  # https://stackoverflow.com/questions/28628384/count-number-of-unique-values-per-row
  transcripts <- as.list(apply(informationdf, 1,
    function(x){unique(x)})$referenceName)

  # initial a list to store aligned indexes and number for each reference
  alignedIndexes <- list()
  numberAligneds <- list()
  for (transcript in transcripts) {
    alignedIndex <- c()
    numberAligned <- c()
    j <- 1L # a index for vectors above to store infomation
    for (i in seq_along(names(informationdf))) { # go through the data frame
      if(informationdf["referenceName", i] == transcripts) {
        # Take unmatches, matches, reference start back to numbers
        unmatches <- as.integer(strsplit(informationdf["readUnmatch", i],
          ",")[[1]])
        matches <- as.integer(strsplit(informationdf["readMatch", i],
          ",")[[1]])
        referenceStarts <- as.integer(strsplit(
          informationdf["referenceStart", i],",")[[1]])

        # since reads should be aligned to transcripts with only start or end
        # part as non-exon sequences, so just compute the start and end parts
        # of unmatches.
        for (item in c(1,2)) {
          if (item == 1) {
            iunmatch <- 1
            reference <- referenceStarts[1]
          } else {
            iunmatch <- length(unmatches)
            reference <- referenceStarts[1] + sum(matches) +
              sum(unmatches) - unmatches[1] - unmatches[length(unmatches)]
          }

          if (unmatches[iunmatch] != 0) {
            if (reference %in% alignedIndex) {
              index <- match(c(reference), alignedIndex)
              numberAligned[index] <- numberAligned[index] + 1
            } else {
              alignedIndex[j] <- reference
              numberAligned[j] <- 1
              j <- j + 1
            }
          }
        }
      }
    }
    # store the infomation for this transcript
    alignedIndexes[[match(c(transcript), transcripts)]] <- alignedIndex
    numberAligneds[[match(c(transcript), transcripts)]] <- numberAligned
  }
  return(list(transcripts, alignedIndexes, numberAligneds))
}

# [END]
