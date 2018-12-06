# scriptTemplate.R
#
# Purpose:
# Version:
# Date:
# Author:
#
# Input:
# Output:
# Dependencies:
#
# ToDo:
# Notes:
#
# ==============================================================================

setwd("<your/project/directory>")

# ====  PARAMETERS  ============================================================
# Define and explain all parameters. No "magic numbers" in your code below.



# ====  PACKAGES  ==============================================================
# Load all required packages.

if (! require(seqinr, quietly=TRUE)) {
  install.packages("seqinr")
  library(seqinr)
}
# Package information:
#  library(help = seqinr)       # basic information
#  browseVignettes("seqinr")    # available vignettes
#  data(package = "seqinr")     # available datasets




# ====  FUNCTIONS  =============================================================

# Define functions or source external files
source("<myUtilityFunctionsScript.R>")

myFunction <- function(a, b=1) {
  # Purpose:
  #     Describe ...
  # Parameters:
  #     a: ...
  #     b: ...
  # Value:
  #     result: ...

  # code ...

  return(result)
}



# ====  PROCESS  ===============================================================
# Enter the step-by-step process of your project here. Strive to write your
# code so that you can simply run this entire file and re-create all
# intermediate results.






# ====  TESTS  =================================================================
# Enter your function tests here...


# [END]


# ====  FUNCTIONS  =============================================================

# Define functions or source external files
#source("R/findNonExon.R")
#source("R/verifyNonExon.R")
#source("R/countNonExon.R")
#source("R/plotNonExon.R")
source("R/nonExonMap.R")

nonExonMapEx <- function() {
	# Purpose: An example run for my package.
	#     This is the example call of my functions with inputs from my extdata.
	# Value:
	#     result: A hist of the position non-exon sequences on reference sequences.

  result <- nonExonMap()

  # Delete the files
  file.remove(list.files("./", pattern = "^output.BAM"))
  file.remove(list.files("./", pattern = "^my_index"))
  file.remove(list.files("./",pattern = "^findNonExonTranscripts.BAM"))
  file.remove(list.files("./",pattern = "^verifyNonExonIntrons.BAM"))

	return(result)
}



# ====  PROCESS  ===============================================================
# Enter the step-by-step process of your project here. Strive to write your
# code so that you can simply run this entire file and re-create all
# intermediate results.






# [END]
