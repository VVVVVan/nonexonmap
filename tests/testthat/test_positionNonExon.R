#test_positionNonExon.R

context("positionNonExon")

# ==== BEGIN SETUP AND PREPARE =================================================
#
readsFile <- system.file("extdata/testdata", "RRHreads.fasta", package = "nonexonmap")
transcriptsFile <- system.file("extdata/testdata", "RRHtranscript.fasta", package = "nonexonmap")
intronsFile <- system.file("extdata/testdata", "RRHintrons.fasta", package = "nonexonmap")

load(system.file("extdata/testdata", "testAssets.Rdata", package = "nonexonmap"))

#
# ==== END SETUP AND PREPARE ===================================================

test_that("corrupt input generates errors",  {
  expect_error(positionNonExon(readsFile, transcriptsFile),
    "argument \"outputFile\" is missing, with no default")
  expect_error(positionNonExon("reads.fasta", transcriptsFile,"output.BAM"),
    "No such file, please check the path to files")
})

test_that("a sample input prouces the expected output",  {
  expect_equal(positionNonExon(readsFile, transcriptsFile, "output.BAM"), testReadsToTranscripts)
})


# ==== BEGIN TEARDOWN AND RESTORE ==============================================
# Remove every persitent construct that the test has created, except for
# stuff in tempdir().
#
rm(testReadsToTranscripts)
file.remove(paste("./tests/testthat/",list.files("./tests/testthat/",
  pattern = "^output.BAM"),sep=""))
file.remove(paste("./tests/testthat/",list.files("./tests/testthat/",
  pattern = "^my_index"),sep=""))
# remove the output and my_index by file.remove()
# ==== END  TEARDOWN AND RESTORE ===============================================

# [END]
