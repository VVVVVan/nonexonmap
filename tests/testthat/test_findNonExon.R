#test_findNonExon.R

context("findNonExon")

# ==== BEGIN SETUP AND PREPARE =================================================
#
readsFile <- system.file("extdata/testdata", "RRHreads.fasta", package = "nonexonmap")
transcriptsFile <- system.file("extdata/testdata", "RRHtranscript.fasta", package = "nonexonmap")

load(system.file("extdata/testdata", "testDataFind.Rdata", package = "nonexonmap"))
findNonExon <- usePosition("find")
#
# ==== END SETUP AND PREPARE ===================================================

test_that("corrupt input generates errors",  {
  expect_error(findNonExon(readsFile),
    "argument \"referenceFile\" is missing, with no default")
  expect_error(findNonExon("reads.fasta", transcriptsFile),
    "No such file, please check the path to files")
})

test_that("a sample input prouces the expected output",  {
  expect_equal(findNonExon(readsFile, transcriptsFile), testReadsToTranscripts)
})


# ==== BEGIN TEARDOWN AND RESTORE ==============================================
# Remove every persitent construct that the test has created, except for
# stuff in tempdir().
#
rm(testReadsToTranscripts)
file.remove(list.files("./", pattern = "^my_index"))
file.remove(list.files("./",pattern = "^findNonExonTranscripts.BAM"))
# remove the output and my_index by file.remove()
# ==== END  TEARDOWN AND RESTORE ===============================================

# [END]
