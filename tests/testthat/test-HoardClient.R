context("HoardClient - when files don't exist")

test_that("HoardClient works", {
  aa <- HoardClient
  expect_is(aa, "R6ClassGenerator")

  bb <- HoardClient$new()

  expect_is(bb, "HoardClient")
  expect_is(bb, "R6")
  expect_null(bb$path)
  expect_null(bb$type)

  # test print method
  expect_output(bb$print(), "<hoard>")
  expect_output(bb$print(), "cache path")

  # test cache_path_get method
  ## before set
  expect_is(bb$cache_path_get, "function")
  expect_null(bb$cache_path_get())

  # test cache_path_set method
  expect_is(bb$cache_path_set, "function")
  expect_error(bb$cache_path_set(), "argument \"path\" is missing")
  expect_is(bb$cache_path_set("test123"), "character")
  expect_match(bb$cache_path_set("test123"), "test123")

  # clean up before testing
  if (dir.exists(bb$cache_path_get())) {
    unlink(bb$cache_path_get(), recursive = TRUE, force = TRUE)
  }

  # test cache_path_get method
  ## after set
  expect_is(bb$cache_path_get(), "character")

  # test list method
  expect_is(bb$list, "function")
  expect_equal(length(bb$list()), 0)

  # test mkdir method
  expect_is(bb$mkdir, "function")
  expect_false(dir.exists(bb$cache_path_get()))
  expect_true(bb$mkdir())
  expect_true(dir.exists(bb$cache_path_get()))

  # test delete method
  expect_is(bb$delete, "function")
  ## no files input
  expect_error(bb$delete(), "argument \"files\" is missing")

  # test delete_all method
  expect_is(bb$delete_all, "function")
  ## no files input
  expect_message(bb$delete_all(), "no files found")
  expect_null(suppressMessages(bb$delete_all()))

  # test details method
  expect_is(bb$details, "function")
  ## no files in yet
  deets1 <- bb$details()
  expect_equal(length(deets1), 0)

  # test key method
  expect_is(bb$key, "function")
  ## no x param passed
  expect_error(bb$key(), "argument \"x\" is missing")
  ## no files in yet
  expect_error(bb$key(x = "adfdf"), "file does not exist")

  # test keys method
  expect_is(bb$keys, "function")
  ## no files in yet, gives NULL
  expect_null(bb$keys())

  # test files method
  expect_is(bb$files, "function")
  ## no files in yet, gives NULL
  expect_null(bb$files())

  # test compress method
  expect_is(bb$compress, "function")
  ## no files in yet, gives error
  expect_error(bb$compress(), "no files to compress")

  # test uncompress method
  expect_is(bb$uncompress, "function")
  ## no files in yet, gives error
  expect_message(bb$uncompress(), "no files to uncompress")
})

context("HoardClient - when files exist")

test_that("HoardClient works", {
  cc <- HoardClient$new()

  expect_is(cc, "HoardClient")
  expect_is(cc, "R6")

  # set cache path
  cc$cache_path_set("test456")

  # mkdir
  cc$mkdir()

  # make some files
  cat(1:10000L, file = file.path(cc$cache_path_get(), "foo.txt"))
  cat(1:10000L, file = file.path(cc$cache_path_get(), "foo1.txt"))
  cat(1:10000L, file = file.path(cc$cache_path_get(), "foo2.txt"))
  cat(1:10000L, file = file.path(cc$cache_path_get(), "foo3.txt"))

  # test list method
  expect_is(cc$list, "function")
  expect_equal(length(cc$list()), 4)
  expect_is(cc$list(), "character")

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
  expect_is(deets1, "cache_info")
  expect_equal(length(deets1), 4)
  expect_is(deets1[[1]], "list")
  expect_named(deets1[[1]], c('file', 'type', 'size'))
  ## print method print.cache_info
  expect_output(print(deets1), "<cached files>")
  expect_output(print(deets1), "file:")
  expect_output(print(deets1), "size:")
  expect_output(print(deets1), "mb")

  # test key method
  expect_is(cc$key(x = cc$list()[1]), "character")
  expect_identical(cc$key(x = cc$list()[1]), cc$key(x = cc$list()[1]))

  # test keys method
  expect_is(cc$keys(), "character")
  expect_equal(length(cc$keys()), 4)

  # test files method
  expect_is(cc$files(), "list")
  zz <- cc$files()[[1]]
  expect_is(zz, "HoardFile")
  expect_is(zz$exists, "function")
  expect_true(zz$exists())
  expect_is(zz$path, "character")
  expect_equal(zz$path, cc$list()[1])
  expect_is(zz$print, "function")
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
