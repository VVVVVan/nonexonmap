# positionNonExon.R

#' output the positions of start alignment on references and number of nucleotides on reads that matches and unmatches to references.
#'
#' \code{positionNonExon} uses \code{buildindex} and \code{align} to form an alignment file. From the file, output the position of non-exon sequences exist on the references sequences and the match/unmatch numbers in the reads itself.
#'
#' @param readFile The file that store the read sequences, a string.
#' @param referenceFile The file that store the reference sequences, a string.
#' @param outputFile The name of output file in BAM format, a string.
#' @return A data frame.
#'
#'
#' @seealso \code{\link[Rsubread]{buildindex}} Build an index for read mapping to perform.
#' @seealso \code{\link[Rsubread]{align}} Align DNA and RNA sequencing reads and report.
#'
#' @examples
#' \dontrun{
#' positionNonExon("reads.fasta", "transcript.fasta", "outputReadsTranscript.BAM")
#' positionNonExon("reads.fasta", "intron.fasta", "outputReadsIntron.BAM")
#' positionNonExon("exon.fasta", "wholeGene.fasta", "outputExonWholegene.BAM")
#' }
#' @export
positionNonExon <- function(readFile, referenceFile, outputFile) {
  # Check if the file exist, if not stop and return a message.
  if (! (file.exists(readFile) && file.exists(referenceFile))) {
    stop("No such file, please check the path to files")
  }

  # Form a BAM file for alignments by using the functions in Rsubread
  # Make the output of Rsubread function invisible. Dan B, Roman T. (2018).
  # StackOverFlow. https://stackoverflow.com/questions/34208564/how-to-hide-or
  # -disable-in-function-printed-message-in-r/34208658
  invisible(capture.output(Rsubread::buildindex(basename="my_index",
    reference=referenceFile)))
  invisible(capture.output(Rsubread::align(index="my_index",
    readfile1=readFile, type="rna", output_file=outputFile, nthreads=20)))

  # Store useful information from BAM file including read name (qname), read
  # alignment information (cigar), reference name (rname), reference position
  # (pos) in a table for later use.
  output <- Rsamtools::scanBam(outputFile)
  readName <- output[[1]][["qname"]]
  readAlign <- output[[1]][["cigar"]]
  referenceName <- as.character(output[[1]][["rname"]])
  referenceStart <- output[[1]][["pos"]]
  myTable <- rbind(readName,readAlign,referenceName,referenceStart)

  # In BAM file, the read alignment(cigar) contains the match and unmatch
  # information. Match is formed in index + "M" or "=" (e.g. "446M").
  # Unmatch is formed in index + some other character (e.g. "336S").
  # Match and unmatch are combined together as one string. This for loop is
  # used to extract the index of matches and unmatches.
  # ref: https://samtools.github.io/hts-specs/SAMv1.pdf
  readMatch <- list() # Initial a list to store match indexes
  readUnmatch <- list() # Initial a list to store unmatch indexes

  for(i in seq_along(myTable[2, ])) {
    # To split string by unmatch characters
    readIndexes <- strsplit(myTable[[2, i]], "[A-L, N-Z]")[[1]]

    # if there is no alignment to reference sequences, give readMatch and
    # readUnmatch 0 and continue to next for loop.
    # ref: Alexey F. (2018). StackOverflow.https://stackoverflow.com/questions
    # /32076971/r-for-loop-skip-to-next-iteration-ifelse
    if (is.na(readIndexes[1])) {
      readMatch[i] <- c("0")
      readUnmatch[i] <- c("0")
      next
    }

    # if there is an alignment, extract match and unmatch length
    match <- c("")
    a <- 1L # a as index in match, since i has been used
    unmatch <- c("")
    b <- 1L # b as index in unmatch
    for (readIndex in readIndexes) {
      if (length(grep("M", readIndex)) > 0 ||
          length(grep("=", readIndex)) > 0) { # The split has "M" or "=", match
        # Split the match from unmatch part if there is any e.g. 123M456
        indexes <- strsplit(readIndex, "M")[[1]]

        # The first splited item is match since match index is before "M"
        if (a > 1) { # If there are > 1 match, need add "," to separate indexes
          match <- paste(match, ",")
        }
        match <- paste(match, as.numeric(indexes[1])) # Store the match index
        a <- a + 1

        # If there are more than one items in indexes, there exists unmatch
        if (readIndexes[1] == readIndex) {
          unmatch <- c(0)
        }
        if (length(indexes) == 1) {
          unmatch <- paste(unmatch, ",", 0)
        } else {
          if (b > 1) { unmatch <- paste(unmatch, ",") }
          unmatch <- paste(unmatch, as.numeric(indexes[2]))
          b <- b + 1
        }

      } else { #The split has no "M" or "=", unmatch
        if (b > 1) { unmatch <- paste(unmatch, ",") }
        unmatch <- paste(unmatch, as.numeric(readIndex))
        b <- b + 1
      }
    }
    # Store the ith match and unmatch
    readMatch[[i]] <- match
    readUnmatch[[i]] <- unmatch
  }
  # Create data frame from previous data.
  myTabledf <- data.frame(myTable, stringsAsFactors = FALSE)
  names(myTabledf) <- myTable[1,]

  readMatchdf <- data.frame(readMatch, stringsAsFactors = FALSE)
  names(readMatchdf) <- myTable[1,]
  rownames(readMatchdf) <- "readMatch"

  readUnmatchdf <- data.frame(readUnmatch, stringsAsFactors = FALSE)
  names(readUnmatchdf) <- myTable[1,]
  rownames(readUnmatchdf) <- "readUnmatch"
  # To make the final table sorted.
  finaldf <- rbind(myTabledf, readMatchdf, readUnmatchdf)[-2,]
  sortedNames <- sort(colnames(finaldf))
  sortdf <- finaldf
  for (i in seq_along(sortedNames)) {
    sortdf[,i] <- finaldf[,sortedNames[i]]
  }
  names(sortdf) <- sortdf[1,]
  return(sortdf)
}

# [END]
