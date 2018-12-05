# countNonExon.R

#' Count the numbers, the position, percentage of introns for non-exon sequences on reference sequences.
#'
#' \code{countNonExon} is a function that is used to count the number of non-exon sequences on specific position of reference sequences and output the percentage of introns in those non-exon sequences.
#'
#' @param findDataFrame the data frame that store the information for funciton to analyze. Should compute from \code{findNonExon} or relateive functions.
#' @param verifyDataFrame the data frame that store the information for funciton to analyze. Should compute from \code{verifyNonExon} or relateive functions.
#' @return A list of list with reference name, alignment position, alignment counts and percentage of introns if there is a verifyDataFrame.
#'
#' @examples
#' \dontrun{
#' readsFile <- system.file("extdata/testdata", "RRHreads.fasta", package = "nonexonmap")
#' transcriptsFile <- system.file("extdata/testdata", "RRHtranscript.fasta", package = "nonexonmap")
#' intronsFile <- system.file("extdata/testdata", "RRHintrons.fasta", package = "nonexonmap")
#'
#' finddataframe <- findNonExon(readsFile, transcriptsFile)
#' countNonExon(finddataframe)
#' verifydataframe <- verifyNonExon(readsFile, intronsFile)
#' countNonExon(finddataframe, verifydataframe)
#' }
countNonExon <- function(findDataFrame, verifyDataFrame = data.frame()) {
  # If missing the verify data frame, just analyze the number of non-exon
  # sequences exist on reference sequences.
  if (missing(verifyDataFrame)) {
    return(countPositionHelp(findDataFrame))
  }
  # If there is no missing then analyze if the non-exon sequences are introns

  # Check verifyDataFrame
  if (! Reduce("&", c("referenceName", "referenceStart", "readUnmatch",
    "readMatch") %in% rownames(verifyDataFrame))) {
    stop("The input should be a data frame in specify format. See help.")
  }

  # Get the data from help function and add more info in it.
  positionHelp <- countPositionHelp(findDataFrame)

  stores <- list() # Initial a list to store all intron percentages
  for (transcript in positionHelp[[1]][[1]]) {
    store <- c()
    j <- 1L # The index for store vector
    for (i in seq_along(names(findDataFrame))) {
      # Check if the reference gene is the same
      if (findDataFrame["referenceName", i] == transcript) {
        nonExonUnmatches <- as.integer(strsplit(
                             findDataFrame["readUnmatch", i], ",")[[1]])
        nonIntronUnmatches <- as.integer(strsplit(
                             verifyDataFrame["readUnmatch", i], ",")[[1]])
        nonIntronMatches <- as.integer(strsplit(
                             verifyDataFrame["readMatch", i], ",")[[1]])

        # Since reads are aligned to transcripts, by default, only start and
        # end part of the reads will hang over. Thus, compute two unmatches.
        for (item in c(1,2)) {
          numberIntron <- 0L
          flag <- TRUE
          # The first and last unmatches need some different value for index
          if (item == 1) {
            index <- 1L
            imatch <- 1L
            iunmatch <- 2L
            differ <- 1L
          } else {
            index <- length(nonExonUnmatches)
            imatch <- as.integer(length(nonIntronMatches))
            iunmatch <- as.integer(length(nonIntronUnmatches)) - 1
            differ <- -1L
          }

          # if the unmatch is 0, then there is no match and skip the loop.
          if (nonExonUnmatches[index] == 0) {
            next
          }

          # if the unmatch is not 0, then check how many of them are introns
          nonIntronIndex <- nonIntronUnmatches[iunmatch - differ]
          # if unmatch of exon is smaller than unmatch of intron, then they
          # are all introns. else, find the percentage by devide intron matches
          # to exon unmatches.
          if (nonExonUnmatches[index] < nonIntronIndex) {
            store[j] <- as.integer(0)
          } else {
            while (nonExonUnmatches[index] > nonIntronIndex) {
              if (flag) {
                nonIntronIndex <- nonIntronIndex + nonIntronMatches[imatch]
                numberIntron <- numberIntron + nonIntronMatches[imatch]
                imatch <- imatch + differ
              } else {
                nonIntronIndex <- nonIntronIndex + nonIntronUnmatches[iunmatch]
                iunmatch <- iunmatch + differ
              }
              flag <- !flag
            }

            ratio <- as.numeric((numberIntron)/ nonExonUnmatches[index])
            if (ratio > 1) {
              store[j] <- 1
            } else {
              store[j] <- ratio
            }

          }
          j <- j + 1
        }
      }
    }
    stores[[match(c(transcript), positionHelp[[1]][[1]])]] <- store
  }
  positionHelp[[4]] <- stores
  return(positionHelp)
}

# [END]
