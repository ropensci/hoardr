# hoardr 0.5.3

This patch release was submitted to CRAN because the maintainer of the project
has changed.

# hoardr 0.5.2

## Test environments

* local OS X install, R 3.5.1 patched
* ubuntu 14.04 (on travis-ci), R 3.5.1
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

## Reverse dependencies

* I have run R CMD check on the 11 downstream dependencies
(<https://github.com/ropensci/hoardr/blob/master/revdep/README.md>).
No problems were found related to this package.

---

This submission includes a fix so that many objects in the same R session don't
share variables anymore.

Thanks!
Scott Chamberlain
