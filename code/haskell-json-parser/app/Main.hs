{-
    Haskell Json Parser
    by: Jelmer van Vugt
-}

module Main where

import Control.Applicative (Alternative)
import Control.Monad (replicateM)
import Data.Bits (shiftL)
import Data.Char (isDigit, isHexDigit, isSpace, chr, ord, digitToInt)
import Data.Functor (($>))
import Data.List (intercalate)
import GHC.Generics (Generic)
import Numeric (showHex)
import Test.QuickCheck hiding (Positive, Negative)


main :: IO ()
main = someFunc
someFunc = putStrLn "gang"