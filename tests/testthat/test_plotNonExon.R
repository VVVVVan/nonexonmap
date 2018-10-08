#test_plotNonExon.R

context("plotNonExon")

# ==== BEGIN SETUP AND PREPARE =================================================
# This test is just a test at this point. Not sure how to test plot file.

load(system.file("extdata/testdata", "testDataCount.Rdata", package = "nonexonmap"))
load(system.file("extdata/testdata", "testDataCountMissing.Rdata", package = "nonexonmap"))
load(system.file("extdata/testdata", "testPlotTmp.Rdata", package = "nonexonmap"))
testemptydf <- data.frame()

#
# ==== END SETUP AND PREPARE ===================================================

test_that("corrupt input generates errors",  {
  expect_error(plotNonExon(),
    "argument \"countLists\" is missing, with no default")
})

test_that("a sample input prouces the expected output",  {
  expect_equal(plotNonExon(testCountNonExonMissing), testPlotTmp)
  expect_equal(plotNonExon(testCountNonExon), testPlotTmp)
})


# ==== BEGIN TEARDOWN AND RESTORE ==============================================
# Remove every persitent construct that the test has created, except for
# stuff in tempdir().
#
rm(testCountNonExonMissing)
rm(testCountNonExon)
rm(testPlotTmp)

# ==== END  TEARDOWN AND RESTORE ===============================================

# [END]
