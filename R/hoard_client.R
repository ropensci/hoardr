#' hoardr class
#'
#' @export
#' @param path (character) a path to cache files in. required
#' @param type (character) type of cache. One of user_cache_dir (default),
#' user_log_dir, user_data_dir, user_config_dir, site_data_dir,
#' site_config_dir. required
#' @details
#' \strong{Methods}
#'   \describe{
#'     \item{\code{cache_path_get()}}{
#'       Get the cache path
#'     }
#'     \item{\code{cache_path_set()}}{
#'       Set the cache path
#'     }
#'     \item{\code{list()}}{
#'       List files in the directory (full file paths)
#'     }
#'     \item{\code{mkdir()}}{
#'       Make the directory if doesn't exist already
#'     }
#'     \item{\code{delete()}}{
#'       Delete files by name
#'     }
#'     \item{\code{delete_all()}}{
#'       Delete all files
#'       - force (\code{FALSE} as default)
#'     }
#'     \item{\code{details()}}{
#'       Get file details
#'     }
#'     \item{\code{keys()}}{
#'       Get SHA keys for all files
#'     }
#'     \item{\code{key()}}{
#'       Get a SHA keys for a single file
#'     }
#'     \item{\code{files()}}{
#'       Get all files as HoardFile objects
#'     }
#'     \item{\code{compress()}}{
#'       Compress files into a zip file - leaving only the zip file
#'     }
#'     \item{\code{uncompress()}}{
#'       Uncompress all files and remove zip file
#'     }
#'   }
#' @format NULL
#' @usage NULL
#' @examples
#' (x <- hoard())
#' x$cache_path_set("foobar")
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
#' x$cache_path_set("stuffthings")
#' x
#' x$cache_path_get()
#' x$list()
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

    cache_path_set = function(path, type = "user_cache_dir") {
      self$path <- path
      private$hoard_env$cache_path <- eval(parse(text = type))(path)
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
      #files <- file.path(self$cache_path_get(), basename(files))
      files <- private$make_paths(files)
      if (!all(file.exists(files))) {
        stop("These files don't exist or can't be found: \n",
             strwrap(files[!file.exists(files)], indent = 5), call. = FALSE)
      }
      unlink(files, force = force, recursive = TRUE)
    },

    delete_all = function(force = FALSE) {
      unlink(self$list(), force = force, recursive = TRUE)
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

    key = function(x) {
      if (is.na(x) || is.null(x) || length(x) == 0) NULL else digest::digest(x)
    },

    keys = function() {
      unlist(lapply(self$list(), self$key))
    },

    files = function() {
      tmp <- self$list()
      if (length(tmp)) lapply(tmp, HoardFile$new) else NULL
    },

    compress = function() {
      comp_path <- file.path(self$cache_path_get(), "compress.zip")
      ff <- self$list()
      zip(comp_path, ff)
      # remove files on success
      unlink(ff)
      message("compressed!")
    },

    uncompress = function() {
      comp_path <- file.path(self$cache_path_get(), "compress.zip")
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

