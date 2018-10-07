# countNonExon.R

#' count the numbers, the position, percentage of introns for non-exon sequences on reference sequences.
#'
#' \code{countNonExon} is a function that is used to count the number of non-exon sequences on specific position of reference sequences and output the percentage of introns in those non-exon sequences.
#'
#' Details.
#' @section usage: countNonExon(findDataFrame).
#'
#' @param findDataFrame the data frame that store the information for funciton to analyze. Should compute from \code{findNonExon} or relateive functions.
#' @param verifyDataFrame the data frame that store the information for funciton to analyze. Should compute from \code{verifyNonExon} or relateive functions.
#' @return A list of list with reference name, alignment position, alignment counts and percentage of introns if there is a verifyDataFrame.
#'
#' @seealso \code{\link{findNonExon}}, \code{\link{verifyNonExon}} compute the input for this function.
#'
#' @examples
#' \dontrun{
#' dataFram <- findNonExon("reads.fasta", "transcripts.fasta")
#' countNonExon(dataFram)
#' verifydataFram <- verifyNonExon("reads.fasta", "introns.fasta")
#' countNonExon(dataFram, verifydataFram)
#' }
countNonExon <- function(findDataFrame, verifyDataFrame = data.frame()) {
  # if missing the verify data frame, just analye the number of non-exon
  # sequences exist on reference sequences.
  if (missing(verifyDataFrame)) {
    return(countPositionHelp(findDataFrame))
  }
  # if there is no missing then analyze if the non-exon sequences are introns
  # check if the file is as requried.
  if (! Reduce("&", c("referenceName", "referenceStart", "readUnmatch",
    "readMatch") %in% rownames(verifyDataFrame))) {
    stop("The input should be a data frame in specify format. See help.")
  }
  # get the data from help function and add more info in it.
  positionHelp <- countPositionHelp(findDataFrame)

  stores <- list() # initial a list to store all intron percentages
  for (transcript in positionHelp[[1]][[1]]) {
    store <- c()
    j <- 1L # the index for store vector
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
          # The first and last unmatches need some different value for index
          if (item == 1) {
            index <- 1
            imatch <- 1L
            iunmatch <- 2L
            differ <- 1L
            flag <- TRUE
          } else {
            index <- length(nonExonUnmatches)
            imatch <- as.integer(length(nonIntronMatches))
            iunmatch <- as.integer(length(nonIntronUnmatches)) - 1
            differ <- -1L
            flag <- TRUE
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
            store[j] <- as.numeric((numberIntron)/ nonExonUnmatches[index])
          }
          j <- j + 1
        }
      }
    }
  }
  stores[[match(c(transcript), positionHelp[[1]][[1]])]] <- store
  positionHelp[[4]] <- stores

  return(positionHelp)
}

# [END]