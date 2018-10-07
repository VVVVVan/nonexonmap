#test_countPositionHelp.R

context("countPositionHelp")

# ==== BEGIN SETUP AND PREPARE =================================================
#

load(system.file("extdata/testdata", "testDataFind.Rdata", package = "nonexonmap"))
load(system.file("extdata/testdata", "testDataCountPosition.Rdata", package = "nonexonmap"))
testemptydf <- data.frame()
testdf <- testReadsToTranscripts[-2,]

#
# ==== END SETUP AND PREPARE ===================================================

test_that("corrupt input generates errors",  {
  expect_error(countPositionHelp(testemptydf),
    "The input should be a data frame in specify format. See help.")
  expect_error(countPositionHelp(testdf),
    "The input should be a data frame in specify format. See help.")
})

test_that("a sample input prouces the expected output",  {
  expect_equal(countPositionHelp(testReadsToTranscripts), testCountPositionHelp)
})


# ==== BEGIN TEARDOWN AND RESTORE ==============================================
# Remove every persitent construct that the test has created, except for
# stuff in tempdir().
#
rm(testReadsToTranscripts)
rm(testCountPositionHelp)

# ==== END  TEARDOWN AND RESTORE ===============================================

# [END]
