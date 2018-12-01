# finch

Version: 0.2.0

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘rappdirs’
      All declared Imports should be used.
    ```

# getCRUCLdata

Version: 0.2.5

## In both

*   checking tests ...
    ```
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Last 13 lines of output:
      1/1 mismatches
      [1] 12.9 - 12.9 == 5.72e-07
      
      ── 2. Failure: Test that create_stack creates tmn if requested (@test-create_CRU
      raster::maxValue(CRU_stack_list[[1]][[1]]) not equal to 4.3.
      1/1 mismatches
      [1] 4.3 - 4.3 == 1.91e-07
      
      ══ testthat results  ═══════════════════════════════════════════════════════════
      OK: 637 SKIPPED: 23 FAILED: 2
      1. Failure: Test that create_stack creates tmx if requested (@test-create_CRU_stack.R#868) 
      2. Failure: Test that create_stack creates tmn if requested (@test-create_CRU_stack.R#1233) 
      
      Error: testthat unit tests failed
      Execution halted
    ```

