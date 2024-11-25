{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Text
import Hakyll
import Text.Pandoc
import Text.Pandoc.Walk
import Prelude hiding (drop, take)

main :: IO ()
main = hakyll rules

isLink :: Text -> Bool
isLink t = take 2 t == "[[" && takeEnd 2 t == "]]"

strippedText :: Text -> Text
strippedText = dropEnd 2 . drop 2

makeLink :: Text -> Text
makeLink t = strippedText t `append` ".html"

allCaps :: Inline -> Inline
allCaps SoftBreak = LineBreak
allCaps (Str t) =
    if isLink t
        then
            let m = makeLink t
             in Link nullAttr [Str (strippedText t)] (m, m)
        else Str t
allCaps y = y

rules :: Rules ()
rules = match "roam-export/**.md" $ do
    route $ gsubRoute "roam-export/" (const "") `composeRoutes` setExtension "html"
    compile compile1

compile1 :: Compiler (Item String)
compile1 = pandocCompilerWithTransform def def (walk allCaps)
