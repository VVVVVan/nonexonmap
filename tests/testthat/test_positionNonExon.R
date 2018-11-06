#test_positionNonExon.R

context("positionNonExon")

# ==== BEGIN SETUP AND PREPARE =================================================
#
readsFile <- system.file("extdata/testdata", "RRHreads.fasta", package = "nonexonmap")
transcriptsFile <- system.file("extdata/testdata", "RRHtranscript.fasta", package = "nonexonmap")
intronsFile <- system.file("extdata/testdata", "RRHintrons.fasta", package = "nonexonmap")

load(system.file("extdata/testdata", "testDataFind.Rdata", package = "nonexonmap"))

#
# ==== END SETUP AND PREPARE ===================================================

test_that("corrupt input generates errors",  {
  expect_error(positionNonExon(readsFile, transcriptsFile),
    "argument \"outputsFile\" is missing, with no default")
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
# To get all the file start with something konwn. Rime (2018). StackOverflow
# https://stackoverflow.com/questions/36999611/
# using-list-files-in-r-to-find-files-that-start-with-a-specific-string
file.remove(list.files("./", pattern = "^output.BAM"))
file.remove(list.files("./", pattern = "^my_index"))

# ==== END  TEARDOWN AND RESTORE ===============================================

# [END]
