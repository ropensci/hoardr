#' hoardr class
#'
#' @export
#' @param path (character) a path to cache files in. required
#' @param type (character) type of cache. One of "user_cache_dir" (default),
#' "user_log_dir", "user_data_dir", "user_config_dir", "site_data_dir",
#' "site_config_dir". Can also pass in any function that gives a path to a
#' directory, e.g., `tempdir()`. required.
#' @details
#' For the purposes of caching, you'll likely want to stick with
#' `user_cache_dir`, but you can change the type of cache with the `type`
#' parameter.
#'
#' `hoard` is just a tiny wrapper around `HoardClient$new()` - use either
#' one.
#'
#' **Methods**
#'   \describe{
#'     \item{`cache_path_get()`}{
#'       Get the cache path\cr
#'       return: (character) path to the cache directory
#'     }
#'     \item{`cache_path_set(path, type = "user_cache_dir", prefix = "R")`}{
#'       Set the cache path. By default, we set cache path to
#'       `file.path(user_cache_dir, prefix, path)`. Note that this does not
#'       actually make the directory, but just sets the path to it.
#'       \itemize{
#'        \item path (character) the path to be appended to the cache path set
#'         by `type`
#'        \item type (character) the type of cache, see [rappdirs]
#'        \item prefix (character) prefix to the `path` value. Default: "R"
#'       }\cr
#'       return: (character) path to the cache directory just set
#'     }
#'     \item{`list()`}{
#'       List files in the directory (full file paths)\cr
#'       return: (character) vector of file paths for files in the cache
#'     }
#'     \item{`mkdir()`}{
#'       Make the directory if doesn't exist already\cr
#'       return: `TRUE`, invisibly
#'     }
#'     \item{`delete(files, force = TRUE)`}{
#'       Delete files by name
#'       \itemize{
#'        \item files (character) vector/list of file paths
#'        \item force (logical) force deletion? Default: `TRUE`
#'       }\cr
#'       retun: nothing
#'     }
#'     \item{`delete_all(force = TRUE)`}{
#'       Delete all files
#'       \itemize{
#'        \item force (logical) force deletion? Default: `FALSE`
#'       }\cr
#'       return: nothing
#'     }
#'     \item{`details(files = NULL)`}{
#'       Get file details
#'       \itemize{
#'        \item files (character) vector/list of file paths
#'       }\cr
#'       return: objects of class `cache_info`, each with brief summary
#'       info including file path and file size
#'     }
#'     \item{`keys(algo = "md5")`}{
#'       Get a hash for all files. Note that these keys may not be unique
#'       if the files are identical, leading to identical hashes\cr
#'       return: (character) path to the cache directory
#'     }
#'     \item{`key(x, algo = "md5")`}{
#'       Get a hash for a single file. Note that these keys may not be unique
#'       if the files are identical, leading to identical hashes
#'       \itemize{
#'        \item x (character) path to a file
#'        \item algo (character) the algorithm to be used, passed on to
#'        [digest::digest()], choices: md5 (default), sha1, crc32, sha256,
#'        sha512, xxhash32, xxhash64 and murmur32.
#'       }\cr
#'       return: (character) hash for the file
#'     }
#'     \item{`files()`}{
#'       Get all files as HoardFile objects\cr
#'       return: (character) path to the cache directory
#'     }
#'     \item{`compress()`}{
#'       Compress files into a zip file - leaving only the zip file\cr
#'       return: (character) path to the cache directory
#'     }
#'     \item{`uncompress()`}{
#'       Uncompress all files and remove zip file\cr
#'       return: (character) path to the cache directory
#'     }
#'   }
#' @format NULL
#' @usage NULL
#' @examples
#' (x <- hoard())
#' x$cache_path_set(path = "foobar", type = 'tempdir')
#' x
#' x$path
#' x$cache_path_get()
#'
#' # make the directory if doesn't exist already
#' x$mkdir()
#'
#' # list files in dir
#' x$list()
#' cat(1:10000L, file = file.path(x$cache_path_get(), "foo.txt"))
#' x$list()
#'
#' # cache details
#' x$details()
#'
#' # delete files by name - we prepend the base path for you
#' x$delete("foo.txt")
#' x$list()
#' x$details()
#'
#' # delete all files
#' cat("one\ntwo\nthree", file = file.path(x$cache_path_get(), "foo.txt"))
#' cat("asdfasdf asd fasdf", file = file.path(x$cache_path_get(), "bar.txt"))
#' x$delete_all()
#' x$list()
#'
#' # make/get a key for a file
#' cat(1:10000L, file = file.path(x$cache_path_get(), "foo.txt"))
#' x$keys()
#' x$key(x$list()[1])
#'
#' # as files
#' Map(function(z) z$exists(), x$files())
#'
#' # compress and uncompress
#' x$compress()
#' x$uncompress()
#'
#' # reset cache path
#' x$cache_path_set(path = "stuffthings", type = "tempdir")
#' x
#' x$cache_path_get()
#' x$list()
#'
#' # cleanup
#' unlink(x$cache_path_get())
hoard <- function() HoardClient$new()

# the client
HoardClient <- R6::R6Class(
  'HoardClient',
  public = list(
    path = NULL,
    type = NULL,

    print = function(x, ...) {
      cat("<hoard> ", sep = "\n")
      cat(paste0("  path: ", self$path), sep = "\n")
      cat(paste0("  cache path: ", self$cache_path_get()), sep = "\n")
      invisible(self)
    },

    initialize = function(path) {
      if (!missing(path)) self$path <- path
    },

    cache_path_get = function() {
      res <- tryCatch(get('cache_path', envir = private$hoard_env),
               error = function(e) e)
      if (inherits(res, "error")) return(NULL) else res
    },

    cache_path_set = function(path, type = "user_cache_dir", prefix = "R") {
      self$path <- path
      private$hoard_env$cache_path <-
        file.path(eval(parse(text = type))(), prefix, path)
      self$cache_path_get()
    },

    list = function() {
      list.files(self$cache_path_get(), ignore.case = TRUE, include.dirs = TRUE,
                 recursive = TRUE, full.names = TRUE)
    },

    mkdir = function() {
      if (!file.exists(self$cache_path_get())) {
        dir.create(self$cache_path_get(), recursive = TRUE)
      }
    },

    delete = function(files, force = TRUE) {
      files <- private$make_paths(files)
      if (!all(file.exists(files))) {
        stop("These files don't exist or can't be found: \n",
             strwrap(files[!file.exists(files)], indent = 5), call. = FALSE)
      }
      unlink(files, force = force, recursive = TRUE)
    },

    delete_all = function(force = FALSE) {
      ff <- self$list()
      if (length(ff) == 0) return(message("no files found"))
      unlink(ff, force = force, recursive = TRUE)
    },

    details = function(files = NULL) {
      if (is.null(files)) {
        files <- self$list()
        structure(lapply(files, file_info_), class = "cache_info",
                  cpath = self$cache_path_get())
      } else {
        files <- private$make_paths(files)
        structure(lapply(files, file_info_), class = "cache_info",
                  cpath = self$cache_path_get())
      }
    },

    key = function(x, algo = "md5") {
      if (is.na(x) || is.null(x) || length(x) == 0) {
        NULL
      } else {
        # check that file exists first
        if (!file.exists(x)) stop("file does not exist", call. = FALSE)
        # make hash
        digest::digest(x, algo = algo, file = TRUE)
      }
    },

    keys = function(algo = "md5") {
      unlist(lapply(self$list(), function(z) self$key(z, algo = algo)))
    },

    files = function() {
      tmp <- self$list()
      if (length(tmp)) lapply(tmp, HoardFile$new) else NULL
    },

    compress = function() {
      comp_path <- file.path(self$cache_path_get(), "compress.zip")
      if (file.exists(comp_path)) return(message("already compressed"))
      if (length(self$list()) == 0) stop("no files to compress", call. = FALSE)
      ff <- self$list()
      zip(comp_path, ff)
      # remove files on success
      unlink(ff)
      message("compressed!")
    },

    uncompress = function() {
      comp_path <- file.path(self$cache_path_get(), "compress.zip")
      if (!file.exists(comp_path)) return(message("no files to uncompress"))
      unzip(comp_path, exdir = self$cache_path_get(), junkpaths = TRUE)
      # remove zip file
      unlink(comp_path)
      message("uncompressed!")
    }
  ),

  private = list(
    hoard_env = new.env(),

    make_paths = function(x) {
      file.path(self$cache_path_get(), basename(x))
    }
  )
)

HoardFile <- R6::R6Class(
  'HoardFile',
  public = list(
    path = NULL,

    print = function(x, ...) {
      cat("<hoard file> ", sep = "\n")
      cat(paste0("  path: ", self$path), sep = "\n")
      invisible(self)
    },

    initialize = function(path) {
      if (!missing(path)) self$path <- path
    },

    exists = function() {
      file.exists(self$path)
    }
  )
)

