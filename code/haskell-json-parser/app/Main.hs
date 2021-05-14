{-
    Haskell Json Parser
    by: Jelmer van Vugt

    notes:
    del .ghc.environment.x86_64-mingw32-9.0.1
    cabal install --lib --package-env . QuickCheck
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

data JValue = JNull
            | JBool Bool
            | JString String
            | JNumber { int :: Integer, frac :: [Int], exponent :: Integer }
            | JArray [JValue]
            | JObject [(String, JValue)]
            deriving (Eq, Generic)

instance Show JValue where
  show value = case value of
    JNull           ->  "null"
    JBool True      ->  "true"
    JBool False     ->  "false"
    JString s       ->  showJSONString s
    JNumber s [] 0  ->  show s
    JNumber s f 0   ->  show s ++ "." ++ concatMap show f
    JNumber s [] e  ->  show s ++ "e" ++ show e
    JNumber s f e   ->  show s ++ "." ++ concatMap show f ++ "e" ++ show e
    JArray a        ->  "[" ++ intercalate ", " (map show a) ++ "]"
    JObject o       ->  "{" ++ intercalate ", " (map showKV o) ++ "}"
    where
      showKV (k, v) = showJSONString k ++ ": " ++ show v

showJSONString :: String -> String

-- Strings are notated with quotation marks
showJSONString s = "\"" ++ concatMap showJSONChar s ++ "\""

-- The definition of control characters in Haskell and JSON differ.
-- This is why this parser implements his own.
isControl :: Char -> String
isControl c = c `elem` ['\0' .. '\31']

showJSONChar :: Char -> String
showJSONChar c = case c of
    "\'" -> "'"
    '\"' -> "\\\""
    '\\' -> "\\\\"
    '/'  -> "\\/"
    '\b' -> "\\b"
    '\f' -> "\\f"
    '\n' -> "\\n"
    '\r' -> "\\r"
    '\t' -> "\\t"
    _ | isControl c -> "\\u" ++ showJSONNonASCIIChar c
    _ -> [c]
    where
      showJSONNonASCIIChar c =
        let a = "0000" ++ showHex (ord c) "" in drop (length a - 4) a
