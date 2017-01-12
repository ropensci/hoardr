ct <- function(l) Filter(Negate(is.null), l)

assert_is <- function(x, y) {
  if (!is.null(x)) {
    if (!class(x) %in% y) {
      stop(deparse(substitute(x)), " must be of class ",
           paste0(y, collapse = ", "), call. = FALSE)
    }
  }
}

assert_n <- function(x, n) {
  if (!is.null(x)) {
    if (!length(x) == n) {
      stop(deparse(substitute(x)), " must be length ", n, call. = FALSE)
    }
  }
}

file_info_ <- function(x) {
  if (file.exists(x)) {
    fs <- file.size(x)
  } else {
    fs <- type <- NA
    x <- paste0(x, " - does not exist")
  }
  list(file = x,
       type = "nc",
       size = if (!is.na(fs)) getsize(fs) else NA
  )
}

getsize <- function(x) round(x/10 ^ 6, 3)
