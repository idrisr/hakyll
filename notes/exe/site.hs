{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Maybe
import Data.Text
import Hakyll
import Text.Pandoc
import Text.Pandoc.Walk
import Prelude hiding (drop, take)

main :: IO ()
main = hakyll $ do
    match "templates/*" $ compile templateBodyCompiler
    match "roam-export/**.md" rules
    match "index.html" r6

r6 :: Rules ()
r6 = do
    route idRoute
    compile $ do
        posts <- loadAll "roam-export/**.md"
        let indexCtx = listField "posts" context (pure posts) <> defaultContext
        getResourceBody
            >>= applyAsTemplate indexCtx
            >>= loadAndApplyTemplate "templates/template.html" indexCtx

-- >>= relativizeUrls

isLink :: Text -> Bool
isLink t = take 2 t == "[[" && takeEnd 2 t == "]]"

strippedText :: Text -> Text
strippedText = dropEnd 2 . drop 2

makeLink :: Text -> Text
makeLink t = strippedText t `append` ".html"

linkify :: Inline -> Inline
linkify SoftBreak = LineBreak
linkify (Str t) =
    if isLink t
        then
            let m = makeLink t
             in Link nullAttr [Str (strippedText t)] (m, m)
        else Str t
linkify y = y

context :: Context String
context =
    mconcat
        [ titleContext
        , field "body" $ pure . itemBody
        ]

titleContext :: Context a
titleContext = field "title" $ \item -> do
    metadata <- getMetadata (itemIdentifier item)
    pure $ fromMaybe "" $ lookupString "title" metadata

rules :: Rules ()
rules = do
    route $ gsubRoute "roam-export/" (const "") `composeRoutes` setExtension "html"
    compile $ (pandocCompilerWithTransform def def . walk) linkify >>= loadAndApplyTemplate "templates/template.html" context
