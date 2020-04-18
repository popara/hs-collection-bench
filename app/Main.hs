{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE TemplateHaskell   #-}
module Main (main) where



import qualified Paths_fairinsight
import           Prelude           (putStrLn)
import           RIO


main :: IO ()
main =
   putStrLn $ "Main App: v" ++ show Paths_fairinsight.version

