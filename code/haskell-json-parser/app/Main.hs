
module Main 
    ( main
    ) where


data JSValue
    = JsonNull
    | JsonInteger Integer
    | JsonString String
    | JsonBool Bool
    | JsonArray [JSValue]
    | JsonObject [(String, JSValue)]
    deriving (Eq, Show) 





main :: IO ()
main = undefined