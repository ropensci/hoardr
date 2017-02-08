context("HoardClient")

test_that("HoardClient works", {
  aa <- HoardClient
  expect_is(aa, "R6ClassGenerator")

  bb <- HoardClient$new()

  expect_is(bb, "HoardClient")
  expect_is(bb, "R6")
  expect_is(bb$cache_path_get, "function")
  expect_is(bb$cache_path_set, "function")
  expect_is(bb$compress, "function")
  expect_is(bb$uncompress, "function")
  expect_is(bb$delete, "function")
  expect_is(bb$delete_all, "function")
  expect_is(bb$details, "function")
  expect_is(bb$files, "function")
  expect_is(bb$key, "function")
  expect_is(bb$keys, "function")
  expect_is(bb$list, "function")
  expect_is(bb$mkdir, "function")
  expect_null(bb$path)
  expect_null(bb$type)
})

test_that("HoardClient fails well", {
  expect_error(HoardClient$new(f = 5),
               "unused argument")
})
