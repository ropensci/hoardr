context("util functions")

test_that("ct", {
  expect_is(ct, "function")
  expect_equal(length(ct(list(NULL, 4))), 1)
})

test_that("assert_is", {
  expect_is(assert_is, "function")
  expect_null(assert_is(TRUE, "logical"))
  expect_error(assert_is(TRUE, "character"), "TRUE must be of class character")
})

test_that("assert_n", {
  expect_is(assert_n, "function")
  expect_null(assert_n(letters, 26))
  expect_error(assert_n(letters, 4), "letters must be length 4")
})
