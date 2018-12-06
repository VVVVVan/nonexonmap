# positionNonExon.R

#' Output the positions of reads on reference sequences with number of match
#' /unmatch.
#'
#'
#' \code{positionNonExon} uses \code{\link[Rsubread]{buildindex}} and
#' \code{\link[Rsubread]{align}} to form an alignment file. From the file,
#' output the position of non-exon sequences exist on the references sequences
#' and the match/unmatch numbers in the reads itself.
#'
#' @param readsFile The file that store the read sequences, a string.
#' @param referencesFile The file that store the reference sequences, a string.
#' @param outputsFile The name of output file in BAM format, a string.
#' @return A data frame in special format in this package. The row names of
#' the data frame are readName (name of read sequences), referenceName (name of
#' reference seqeunces), referenceStart (the start position alignmnet in
#' reference seqeunces), readMatch and readUnmatch (match/unmatch length of
#' reads). The column names of the data frame are the name of read sequences.
#'
#' @seealso \code{\link[Rsubread]{buildindex}} Build an index for read mapping
#' to perform.
#' @seealso \code{\link[Rsubread]{align}} Align DNA and RNA sequencing reads
#' and report.
#' @seealso \code{\link[Rsamtools]{scanBam}} Read the Bam file.
#'
#' @examples
#' readsFile <- system.file("extdata/testdata", "RRHreads.fasta",
#' package = "nonexonmap")
#' transcriptsFile <- system.file("extdata/testdata", "RRHtranscript.fasta",
#' package = "nonexonmap")
#' intronsFile <- system.file("extdata/testdata", "RRHintrons.fasta",
#' package = "nonexonmap")
#' \dontrun{
#' positionNonExon(readsFile, transcriptsFile, "outputReadsTranscript.BAM")
#' positionNonExon(readsFile, intronsFile, "outputReadsIntron.BAM")
#' }
positionNonExon <- function(readsFile, referencesFile, outputsFile) {
  # Check if the file exist, if not stop and return a message.
  if (! (file.exists(readsFile) && file.exists(referencesFile))) {
    stop("No such file, please check the path to files")
  }

  # Form a BAM file for alignments by using the functions in Rsubread
  # Make the output of Rsubread function invisible. Dan B, Roman T. (2018).
  # StackOverFlow. https://stackoverflow.com/questions/34208564/how-to-hide-or
  # -disable-in-function-printed-message-in-r/34208658
  invisible(utils::capture.output(Rsubread::buildindex(basename="my_index",
    reference=referencesFile)))
  invisible(utils::capture.output(Rsubread::align(index="my_index",
    readfile1=readsFile, type="rna", output_file=outputsFile, nthreads=20)))

  # Store useful information from BAM file for later use.
  output <- Rsamtools::scanBam(outputsFile)
  # The output has lots of information, the information that is useful for
  # this function are qname, cigar, rname, pos.
  readName <- output[[1]][["qname"]] # qname is read name
  readAlign <- output[[1]][["cigar"]] # cigar is read alignment information
  referenceName <- as.character(output[[1]][["rname"]]) # ranme is ref name
  referenceStart <- output[[1]][["pos"]] # pos is reference start position
  myTable <- rbind(readName,readAlign,referenceName,referenceStart)

  # In BAM file, the read alignment(cigar) contains the match and unmatch
  # information. Match is formed in index + "M" or "=" (e.g. "446M").
  # Unmatch is formed in index + some other character (e.g. "336S").
  # Match and unmatch are combined together as one string.
  # ref: https://samtools.github.io/hts-specs/SAMv1.pdf

  # Extract the index of matches and unmatches.
  readMatch <- list() # Initial a list to store match indexes
  readUnmatch <- list() # Initial a list to store unmatch indexes

  for(i in seq_along(myTable[2, ])) {
    # To split string by unmatch characters
    readIndexes <- strsplit(myTable[[2, i]], "[A-L, N-Z]")[[1]]

    # No alignment to reference sequences, assign readMatch and readUnmatch to
    # "0" and continue to next for loop.
    # ref: Alexey F. (2018). StackOverflow.https://stackoverflow.com/questions
    # /32076971/r-for-loop-skip-to-next-iteration-ifelse
    if (is.na(readIndexes[1])) {
      readMatch[i] <- c("0")
      readUnmatch[i] <- c("0")
      next
    }

    # Alignment exist, extract match and unmatch length.
    match <- unmatch <- c("")
    a <- b <- 1L # a as index in match, b as index in unmatch
    for (readIndex in readIndexes) {
      if (length(grep("M", readIndex)) > 0 ||
          length(grep("=", readIndex)) > 0) { # The split has "M" or "=", match
        # Split the match from unmatch part if there is any e.g. 123M456
        indexes <- strsplit(readIndex, "M")[[1]]

        # The first splited item is match since match index is before "M"
        if (a > 1) {
          match <- paste(match, ",")
        }
        match <- paste(match, as.numeric(indexes[1]))
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
  sortdf <- finaldf <- rbind(myTabledf, readMatchdf, readUnmatchdf)[-2,]
  sortedNames <- sort(colnames(finaldf))
  for (i in seq_along(sortedNames)) {
    sortdf[,i] <- finaldf[,sortedNames[i]]
  }
  names(sortdf) <- sortdf[1,]
  return(sortdf)
}

# [END]
