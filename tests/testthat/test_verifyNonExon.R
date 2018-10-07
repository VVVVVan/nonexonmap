#test_verifyNonExon.R

context("verifyNonExon")

# ==== BEGIN SETUP AND PREPARE =================================================
#
readsFile <- system.file("extdata/testdata", "RRHreads.fasta", package = "nonexonmap")
intronsFile <- system.file("extdata/testdata", "RRHintrons.fasta", package = "nonexonmap")

load(system.file("extdata/testdata", "testAssets2.Rdata", package = "nonexonmap"))
verifyNonExon <- usePosition("verify")
#
# ==== END SETUP AND PREPARE ===================================================

test_that("corrupt input generates errors",  {
  expect_error(verifyNonExon(readsFile),
    "argument \"referenceFile\" is missing, with no default")
  expect_error(verifyNonExon("reads.fasta", transcriptsFile),
    "No such file, please check the path to files")
})

test_that("a sample input prouces the expected output",  {
  expect_equal(verifyNonExon(readsFile, intronsFile), testReadsToIntrons)
})


# ==== BEGIN TEARDOWN AND RESTORE ==============================================
# Remove every persitent construct that the test has created, except for
# stuff in tempdir().
#
rm(testReadsToIntrons)
file.remove(paste("./tests/testthat/",list.files("./tests/testthat/",
  pattern = "^my_index"),sep=""))
file.remove(paste("./tests/testthat/",list.files("./tests/testthat/",
  pattern = "^verifyNonExonIntrons.BAM"),sep=""))
# remove the output and my_index by file.remove()
# ==== END  TEARDOWN AND RESTORE ===============================================

# [END]
