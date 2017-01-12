hoard
=====



[![Build Status](https://travis-ci.org/ropensci/hoard.svg?branch=master)](https://travis-ci.org/ropensci/hoard)

`hoard` - manage cached files

Exposes a single `R6` object so that when the package is imported in another
package for managing cached files, you don't need to polute the NAMESPACE 
with a bunch of functions. (you can always just `hoard::fxn`, but 
with a single object there are other benefits as well [maintaining state, e.g.]).

## install


```r
devtools::install_github("ropensci/hoard")
```


```r
library(hoard)
```

## usage

initialize client


```r
(x <- hoard::hord())
#> <hoard> 
#>   path: 
#>   cache path: /Users/sacmac/Library/Caches/foobar
```

set cache path


```r
x$cache_path_set("foobar")
#> [1] "/Users/sacmac/Library/Caches/foobar"
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
#> [1] "/Users/sacmac/Library/Caches/foobar/foo.txt"
```

details


```r
x$details()
#> <cached files>
#>   directory: /Users/sacmac/Library/Caches/foobar
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

see [issue 1](https://github.com/ropensci/hoard/issues/1)

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/hoard/issues).
* License: MIT
* Get citation information for `hoard` in R doing `citation(package = 'hoard')`
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![rofooter](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
