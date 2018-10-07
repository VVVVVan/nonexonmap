#test_countNonExon.R

context("countNonExon")

# ==== BEGIN SETUP AND PREPARE =================================================
#

load(system.file("extdata/testdata", "testDataFind.Rdata", package = "nonexonmap"))
load(system.file("extdata/testdata", "testDataVerify.Rdata", package = "nonexonmap"))
load(system.file("extdata/testdata", "testDataCount.Rdata", package = "nonexonmap"))
load(system.file("extdata/testdata", "testDataCountMissing.Rdata", package = "nonexonmap"))
testemptydf <- data.frame()
testdf <- testReadsToTranscripts[-2,]

#
# ==== END SETUP AND PREPARE ===================================================

test_that("corrupt input generates errors",  {
  expect_error(countNonExon(testemptydf),
    "The input should be a data frame in specify format. See help.")
  expect_error(countNonExon(testReadsToTranscripts, testdf),
    "The input should be a data frame in specify format. See help.")
})

test_that("a sample input prouces the expected output",  {
  expect_equal(countNonExon(testReadsToTranscripts), testCountNonExonMissing)
  expect_equal(countNonExon(testReadsToTranscripts, testReadsToIntrons), testCountNonExon)
})


# ==== BEGIN TEARDOWN AND RESTORE ==============================================
# Remove every persitent construct that the test has created, except for
# stuff in tempdir().
#
rm(testReadsToTranscripts)
rm(testReadsToIntrons)
rm(testCountNonExon)
rm(testCountNonExonMissing)

# ==== END  TEARDOWN AND RESTORE ===============================================

# [END]
