context("hoard")

test_that("hoard works", {
  aa <- hoard()

  expect_is(aa, "HoardClient")
  expect_is(aa, "R6")
  expect_is(aa$cache_path_get, "function")
  expect_is(aa$cache_path_set, "function")
  expect_is(aa$compress, "function")
  expect_is(aa$uncompress, "function")
  expect_is(aa$delete, "function")
  expect_is(aa$delete_all, "function")
  expect_is(aa$details, "function")
  expect_is(aa$files, "function")
  expect_is(aa$key, "function")
  expect_is(aa$keys, "function")
  expect_is(aa$list, "function")
  expect_is(aa$mkdir, "function")
  expect_null(aa$path)
  expect_null(aa$type)
})

test_that("hoard fails well", {
  expect_error(hoard(f = 5),
                 "unused argument")
})
