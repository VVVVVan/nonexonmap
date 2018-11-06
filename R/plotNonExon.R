# plotNonExon.R

#' plot the information of non-exon sequences on reference sequences.
#'
#' \code{plotNonExon} plot the numebr of non-exon sequences on the position of reference sequences. The percentage of the introns are also drawed, but dont't know how to combine these infomation on the plot at this point.
#'
#' @param countLists a list of list with the non exon position and numbers to plot. Usually get from \code{countNonExon}.
#' @return A list of hist data that could be used for test.
#'
#' @examples
#' \dontrun{
#' readsFile <- system.file("extdata/testdata", "RRHreads.fasta", package = "nonexonmap")
#' transcriptsFile <- system.file("extdata/testdata", "RRHtranscript.fasta", package = "nonexonmap")
#' dataFrame <- findNonExon(readsFile, transcriptsFile)
#' plotNonExon(countNonExon(dataFrame))
#' verifydataFram <- verifyNonExon("reads.fasta", "introns.fasta")
#' plotNonExon(countNonExon(dataFrame, verifydataFram))
#' }
plotNonExon <- function(countLists) {
  # Sepearte the window if there are more than one reference genes
  # Need more improvement for this, what if the number is very large
  if (length(countLists[[1]]) > 1) {
    graphics::par(mfrow=c(as.integer((length(countLists[[1]]) + 1) / 2 ),2))
  }
  infos <- list()
  for (i in seq_along(countLists[[1]])) {
    x <- as.numeric(countLists[[2]][[i]]) # position of introns
    y <- as.numeric(countLists[[3]][[i]])# number of introns
    infos[[i]] <- graphics::hist(x, breaks=10)
    if (length(countLists) == 4) {
      z <- as.numeric(countLists[[4]][[i]])
      graphics::par(mfrow=c(2, 4))
      for (j in seq_along(z)) {
        graphics::pie(c(abs(1-z[j]),z[j]), col=c(8,2),labels=c("non-exon",
          "introns"))
      }
      grDevices::dev.off()
    }
    graphics::plot(x,y)
  }
  return(infos)
}

# [END]
