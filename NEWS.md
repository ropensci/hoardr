hoardr 0.5.2
============

### BUG FIXES

* Important fix: `HoardClient`, called by `hoardr()` function, was storing the cache path in an environment inside the R6 class. If multiple instances of `HoardClient` exist in the same R session, the cache path for any one then affects all others. Fixed by storing as a private variable int he R6 class instead of in an environment (#14)


hoardr 0.5.0
============

### NEW FEATURES

* Gains new method on the `HoardClient` object to check if one or more files exist, returning a data.frame (#10)
* `cache_path_set()` method on `HoardClient` gains new parameter `full_path` to make the base cache path directly with a full path rather than using the three other parameters (`path`, `type`, and `prefix`) (#12)


hoardr 0.2.0
============

### CHANGES

* Compliance with CRAN policies about writing to users disk (#6)

### MINOR IMPROVEMENTS

* Improved documentation (#7)

### BUG FIXES

* Change `key()` and `keys()` to use `file=TRUE` (#8)
* Fix R6 import warning (#5)


hoardr 0.1.0
============

### NEW FEATURES

* released to CRAN
