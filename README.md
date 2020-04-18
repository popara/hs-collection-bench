# Testing actual speed of Haskell Collectionns

Incorrect attempt at benchmarking collections.


## Run benchmarks 

`stack bench`



## First results 
```
Fold w Snoc /10/List                     mean 166.8 ns  ( +- 7.095 ns  )
Fold w Snoc /10/Vector                   mean 554.8 ns  ( +- 13.22 ns  )
Fold w Snoc /100/List                    mean 1.737 μs  ( +- 36.54 ns  )
Fold w Snoc /100/Vector                  mean 12.70 μs  ( +- 280.4 ns  )
Fold w Snoc /1000/List                   mean 28.83 μs  ( +- 1.054 μs  )
Fold w Snoc /1000/Vector                 mean 2.748 ms  ( +- 140.9 μs  )
Fold w Snoc /20000/List                  mean 5.581 ms  ( +- 280.2 μs  )
benchmarking Fold w Snoc /20000/Vector ... took 119.9 s, total 56 iterations
Fold w Snoc /20000/Vector                mean 2.150 s   ( +- 107.9 ms  )
```
