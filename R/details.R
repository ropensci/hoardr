#' @export
print.cache_info <- function(x, ...) {
  cat("<cached files>", sep = "\n")
  cat(sprintf("  directory: %s\n", attr(x, "cpath")), sep = "\n")
  for (i in seq_along(x)) {
    cat(paste0("  file: ", sub(attr(x, "cpath"), "", x[[i]]$file)), sep = "\n")
    cat(paste0("  size: ", x[[i]]$size, if (is.na(x[[i]]$size)) "" else " mb"),
        sep = "\n")
    cat("\n")
  }
}
