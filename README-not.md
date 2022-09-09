hoardr
======



[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![cran checks](https://cranchecks.info/badges/worst/hoardr)](https://cranchecks.info/pkgs/hoardr)
[![R-check](https://github.com/ropensci/hoardr/workflows/R-check/badge.svg)](https://github.com/ropensci/hoardr/actions?query=workflow%3AR-check)
[![codecov.io](https://codecov.io/github/ropensci/hoardr/coverage.svg?branch=master)](https://codecov.io/github/ropensci/hoardr?branch=master)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/hoardr)](https://github.com/metacran/cranlogs.app)
[![cran version](https://www.r-pkg.org/badges/version/hoardr)](https://cran.r-project.org/package=hoardr)


`hoard` - manage cached files

Exposes a single `R6` object so that when the package is imported in another
package for managing cached files, you don't need to pollute the NAMESPACE
with a bunch of functions. (you can always just `hoardr::fxn`, but
with a single object there are other benefits as well [maintaining state, e.g.]).

## install

stable


```r
install.packages("hoardr")
```

dev version


```r
remotes::install_github("ropensci/hoardr")
```


```r
library(hoardr)
```

## usage

initialize client


```r
(x <- hoardr::hoard())
#> <hoard> 
#>   path: 
#>   cache path:
```

set cache path


```r
x$cache_path_set("foobar", type = 'tempdir')
#> [1] "/var/folders/fc/n7g_vrvn0sx_st0p8lxb3ts40000gn/T//RtmpWAAkp3/R/foobar"
```

make the directory if doesn't exist


```r
x$mkdir()
```

put a file in the cache


```r
cat("hello world", file = file.path(x$cache_path_get(), "foo.txt"))
```

list the files


```r
x$list()
#> [1] "/var/folders/fc/n7g_vrvn0sx_st0p8lxb3ts40000gn/T//RtmpWAAkp3/R/foobar/foo.txt"
```

details


```r
x$details()
#> <cached files>
#>   directory: /var/folders/fc/n7g_vrvn0sx_st0p8lxb3ts40000gn/T//RtmpWAAkp3/R/foobar
#> 
#>   file: /foo.txt
#>   size: 0 mb
```

delete by file name


```r
x$delete("foo.txt")
x$list()
#> character(0)
```

## todo

see [issue 1](https://github.com/ropensci/hoardr/issues/1)

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/hoardr/issues).
* License: MIT
* Get citation information for `hoardr` in R doing `citation(package = 'hoardr')`
* Please note that this project is released with a [Contributor Code of Conduct][coc]. By participating in this project you agree to abide by its terms.

[![rofooter](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)

[coc]: https://github.com/ropensci/hoardr/blob/master/CODE_OF_CONDUCT.md
