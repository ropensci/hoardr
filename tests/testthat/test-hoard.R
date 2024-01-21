test_that("hoard works", {
  aa <- hoard()

  expect_s3_class(aa, "HoardClient")
  expect_s3_class(aa, "R6")
  expect_equal(class(aa$cache_path_get), "function")
  expect_equal(class(aa$cache_path_set), "function")
  expect_equal(class(aa$compress), "function")
  expect_equal(class(aa$uncompress), "function")
  expect_equal(class(aa$delete), "function")
  expect_equal(class(aa$delete_all), "function")
  expect_equal(class(aa$details), "function")
  expect_equal(class(aa$files), "function")
  expect_equal(class(aa$key), "function")
  expect_equal(class(aa$keys), "function")
  expect_equal(class(aa$list), "function")
  expect_equal(class(aa$mkdir), "function")
  expect_null(aa$path)
  expect_null(aa$type)
})

test_that("hoard works with multiple instances", {
  aa <- hoard()
  bb <- hoard()

  aa$cache_path_set('foobar')

  expect_match(aa$cache_path_get(), 'foobar')
  expect_null(bb$cache_path_get())

  bb$cache_path_set('helloworld')

  expect_match(aa$cache_path_get(), 'foobar')
  expect_match(bb$cache_path_get(), 'helloworld')
})

test_that("hoard fails well", {
  expect_error(hoard(f = 5),
                 "unused argument")
})
