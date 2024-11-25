{-# LANGUAGE OverloadedStrings #-}

import Hakyll

r1 :: Rules ()
r1 = do
    route idRoute
    compile copyFileCompiler

r2 :: Rules ()
r2 = do
    route idRoute
    compile compressCssCompiler

r3 :: Rules ()
r3 = do
    route $ setExtension "html"
    compile p1
  where
    p1 :: Compiler (Item String)
    p1 =
        pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

r4 :: Rules ()
r4 = do
    route $ setExtension "html"
    compile p1
  where
    p1 :: Compiler (Item String)
    p1 =
        pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html" postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

r5 :: Rules ()
r5 = do
    route idRoute
    compile $ do
        posts <- recentFirst =<< loadAll "posts/*"
        let archiveCtx =
                listField "posts" postCtx (return posts)
                    <> constField "title" "Archives"
                    <> defaultContext
        makeItem ""
            >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
            >>= loadAndApplyTemplate "templates/default.html" archiveCtx
            >>= relativizeUrls

r6 :: Rules ()
r6 = do
    route idRoute
    compile $ do
        posts <- recentFirst =<< loadAll "posts/*"
        let indexCtx =
                listField "posts" postCtx (return posts)
                    <> defaultContext
        getResourceBody
            >>= applyAsTemplate indexCtx
            >>= loadAndApplyTemplate "templates/default.html" indexCtx
            >>= relativizeUrls

r7 :: Rules ()
r7 = compile templateBodyCompiler

main :: IO ()
main =
    hakyllWith config $ do
        match "images/*" r1
        match "css/*" r2
        match (fromList ["about.rst", "contact.markdown"]) r3
        match "posts/*" r4
        create ["archive.html"] r5
        match "index.html" r6
        match "templates/*" r7

config :: Configuration
config =
    defaultConfiguration
        { destinationDirectory = "deck"
        , previewPort = 6969
        }

postCtx :: Context String
postCtx = dateField "date" "%B %e, %Y" <> defaultContext
