test_that("HoardClient works when files don't exist", {
  aa <- HoardClient
  expect_s3_class(aa, "R6ClassGenerator")

  bb <- HoardClient$new()

  expect_s3_class(bb, "HoardClient")
  expect_s3_class(bb, "R6")
  expect_null(bb$path)
  expect_null(bb$type)

  # test print method
  expect_output(bb$print(), "<hoard>")
  expect_output(bb$print(), "cache path")

  # test cache_path_get method
  ## before set
  expect_equal(class(bb$cache_path_get), "function")
  expect_null(bb$cache_path_get())

  # test cache_path_set method
  expect_equal(class(bb$cache_path_set), "function")
  expect_equal(length(bb$cache_path_set()), 0)
  expect_type(
    bb$cache_path_set(path = "test123", type = 'tempdir'),
    "character"
  )
  expect_match(
    bb$cache_path_set(path = "test123", type = 'tempdir'),
    "test123"
  )

  # use full_path
  expect_type(
    bb$cache_path_set(full_path = file.path(tempdir(), "foobar")),
    'character'
  )

  # clean up before testing
  if (dir.exists(bb$cache_path_get())) {
    unlink(bb$cache_path_get(), recursive = TRUE, force = TRUE)
  }

  # test cache_path_get method
  ## after set
  expect_type(bb$cache_path_get(), "character")

  # test list method
  expect_equal(class(bb$list), "function")
  expect_equal(length(bb$list()), 0)

  # test mkdir method
  expect_equal(class(bb$mkdir), "function")
  expect_false(dir.exists(bb$cache_path_get()))
  expect_true(bb$mkdir())
  expect_true(dir.exists(bb$cache_path_get()))

  # test delete method
  expect_equal(class(bb$delete), "function")
  ## no files input
  expect_error(bb$delete(), "argument \"files\" is missing")

  # test delete_all method
  expect_equal(class(bb$delete_all), "function")
  ## no files input
  expect_message(bb$delete_all(), "no files found")
  expect_null(suppressMessages(bb$delete_all()))

  # test details method
  expect_equal(class(bb$details), "function")
  ## no files in yet
  deets1 <- bb$details()
  expect_equal(length(deets1), 0)

  # test key method
  expect_equal(class(bb$key), "function")
  ## no x param passed
  expect_error(bb$key(), "argument \"x\" is missing")
  ## no files in yet
  expect_error(bb$key(x = "adfdf"), "file does not exist")

  # test keys method
  expect_equal(class(bb$keys), "function")
  ## no files in yet, gives NULL
  expect_null(bb$keys())

  # test files method
  expect_equal(class(bb$files), "function")
  ## no files in yet, gives NULL
  expect_null(bb$files())

  # test compress method
  expect_equal(class(bb$compress), "function")
  ## no files in yet, gives error
  expect_error(bb$compress(), "no files to compress")

  # test uncompress method
  expect_equal(class(bb$uncompress), "function")
  ## no files in yet, gives error
  expect_message(bb$uncompress(), "no files to uncompress")

  # test exists method
  ## add some files first
  cat(1:10000L, file = file.path(bb$cache_path_get(), "bar1.txt"))
  cat(1:10000L, file = file.path(bb$cache_path_get(), "bar2.txt"))
  expect_s3_class(bb$exists('bar1.txt'), "data.frame")
  expect_true(bb$exists('bar1.txt')$exists)
  expect_false(bb$exists('asdfasdsdf')$exists)
  ## no files in yet, gives error
  expect_error(bb$exists(), "argument \"files\" is missing")
})

test_that("HoardClient works when files exist", {
  cc <- HoardClient$new()

  expect_s3_class(cc, "HoardClient")
  expect_s3_class(cc, "R6")

  # set cache path
  cc$cache_path_set(path = "test456", type = 'tempdir')

  # mkdir
  cc$mkdir()

  # make some files
  cat(1:10000L, file = file.path(cc$cache_path_get(), "foo.txt"))
  cat(1:10000L, file = file.path(cc$cache_path_get(), "foo1.txt"))
  cat(1:10000L, file = file.path(cc$cache_path_get(), "foo2.txt"))
  cat(1:10000L, file = file.path(cc$cache_path_get(), "foo3.txt"))

  # test list method
  expect_equal(class(cc$list), "function")
  expect_equal(length(cc$list()), 4)
  expect_type(cc$list(), "character")

  # test delete method
  expect_error(cc$delete(), "argument \"files\" is missing")

  # test delete_all method
  expect_equal(suppressMessages(cc$delete_all()), 0)

  # make files again
  cat(1:10000L, file = file.path(cc$cache_path_get(), "foo.txt"))
  cat(1:10000L, file = file.path(cc$cache_path_get(), "foo1.txt"))
  cat(1:10000L, file = file.path(cc$cache_path_get(), "foo2.txt"))
  cat(1:10000L, file = file.path(cc$cache_path_get(), "foo3.txt"))

  # test details method
  deets1 <- cc$details()
  expect_equal(class(deets1), "cache_info")
  expect_equal(length(deets1), 4)
  expect_type(deets1[[1]], "list")
  expect_named(deets1[[1]], c('file', 'type', 'size'))
  ## print method print.cache_info
  expect_output(print(deets1), "<cached files>")
  expect_output(print(deets1), "file:")
  expect_output(print(deets1), "size:")
  expect_output(print(deets1), "mb")

  # test key method
  expect_type(cc$key(x = cc$list()[1]), "character")
  expect_identical(cc$key(x = cc$list()[1]), cc$key(x = cc$list()[1]))

  # test keys method
  expect_type(cc$keys(), "character")
  expect_equal(length(cc$keys()), 4)

  # test files method
  expect_type(cc$files(), "list")
  zz <- cc$files()[[1]]
  expect_s3_class(zz, "HoardFile")
  expect_equal(class(zz$exists), "function")
  expect_true(zz$exists())
  expect_type(zz$path, "character")
  expect_equal(zz$path, cc$list()[1])
  expect_equal(class(zz$print), "function")
  expect_output(zz$print(), "<hoard file>")
  expect_output(zz$print(), "path:")

  # test compress method
  comp <- cc$compress()
  expect_null(comp)
  expect_message(cc$compress(), "already compressed")

  # test uncompress method
  uncomp <- cc$uncompress()
  expect_null(uncomp)
  expect_message(cc$uncompress(), "no files to uncompress")
})

test_that("HoardClient fails well", {
  expect_error(HoardClient$new(f = 5),
               "unused argument")
})
