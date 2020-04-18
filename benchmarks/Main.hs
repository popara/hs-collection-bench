{-# LANGUAGE NoImplicitPrelude #-}
module Main  where


import           Gauge.Main
import           RIO
import qualified RIO.List   as L
import qualified RIO.Vector as V


fib :: Int -> Int
fib 0 = 0
fib 1 = 1
fib n = fib (n-1) + fib (n-2)

main :: IO ()
main = do
  list10 <- sampleList 10
  list100 <- sampleList 100
  list1000 <- sampleList 1000
  list20000 <- sampleList 20000
  list200000 <- sampleList 200000
  vector10 <- sampleVector 10
  vector100 <- sampleVector 100
  vector1000 <- sampleVector 1000
  vector20000 <- sampleVector 20000
  vector200000 <- sampleVector 200000
  defaultMain
    [ bgroup "Fold w Snoc "
      [ bgroup "10"
        [ bench "List" $ whnf mkpctR (list10)
        , bench "Vector" $ whnf mkpctR (vector10)
        ]

      , bgroup "100"
        [ bench "List" $ whnf mkpctR (list100)
        , bench "Vector" $ whnf mkpctR (vector100)
        ]

      , bgroup "1000"
        [ bench "List" $ whnf mkpctR (list1000)
        , bench "Vector" $ whnf mkpctR (vector1000)
        ]

      , bgroup "20000"
        [ bench "List" $ whnf mkpctR (list20000)
        , bench "Vector" $ whnf mkpctR (vector20000)
        ]

      , bgroup "200000"
        [ bench "List" $ whnf mkpctR (list200000)
        , bench "Vector" $ whnf mkpctR (vector200000)
         ]

      ]

    -- , bgroup "Fold 2 - NF "
    --   [ bgroup "10"
    --     [ bench "List" $ nf mkpctL2 (list10)
    --     , bench "Vector" $ nf mkpctL2 (vector10)
    --     ]

    --   , bgroup "100"
    --     [ bench "List" $ nf mkpctL2 (list100)
    --     , bench "Vector" $ nf mkpctL2 (vector100)
    --     ]

    --   , bgroup "1000"
    --     [ bench "List" $ nf mkpctL2 (list1000)
    --     , bench "Vector" $ nf mkpctL2 (vector1000)
    --     ]

    --   , bgroup "20000"
    --     [ bench "List" $ nf mkpctL2 (list20000)
    --     , bench "Vector" $ nf mkpctL2 (vector20000)
    --     ]
    --   ]

    , bgroup "Fold"
      [ bgroup "10"
        [ bench "List" $ whnf mkpctL (list10)
        , bench "Vector" $ whnf mkpctL (vector10)
        ]

      , bgroup "100"
        [ bench "List" $ whnf mkpctL (list100)
        , bench "Vector" $ whnf mkpctL (vector100)
        ]

      , bgroup "1000"
        [ bench "List" $ whnf mkpctL (list1000)
        , bench "Vector" $ whnf mkpctL (vector1000)
        ]

      , bgroup "20000"
        [ bench "List" $ whnf mkpctL (list20000)
        , bench "Vector" $ whnf mkpctL (vector20000)
        ]

      , bgroup "200000"
        [ bench "List" $ whnf mkpctL (list200000)
        , bench "Vector" $ whnf mkpctL (vector200000)
        ]

      ]
    ]


class Op f where
  foldl :: ( b -> a -> b) -> b -> f a -> b
  foldr' :: ( a -> b -> b) -> b -> f a -> b
  cons :: a -> f a -> f a
  snoc ::  f a -> a -> f a
  emt :: f a
  hd :: f a -> Maybe a
  ls :: f a -> Maybe a

instance Op [] where
  foldl = L.foldl
  foldr' = L.foldr
  cons = (:)
  emt = []
  hd = L.headMaybe
  ls = L.lastMaybe
  snoc xs a = xs ++ [a]

instance Op Vector where
  foldl = V.foldl
  foldr' = V.foldr
  cons = V.cons
  emt = V.empty
  hd v = v V.!? 0
  ls v = v V.!? (V.length v - 1)
  snoc = V.snoc

mkpctL :: Op f => f Int -> f (Int, Int)
mkpctL =
  fst . foldl (\(xs, lst) i ->
           (cons (i, i*lst + 2) xs, i)
        ) (emt, 0)

mkpctR :: Op f => f Int -> f (Int, Int)
mkpctR =
  fst .
  foldr' (\i (xs, lst) ->
          (snoc xs (i, i*lst + 2), i)
        ) (emt, 0)

sampleList :: Int -> IO [Int]
sampleList i = RIO.evaluate $ force [1..i]

sampleVector :: Int -> IO (Vector Int)
sampleVector i = RIO.evaluate $ force $ V.fromList [1..i]
