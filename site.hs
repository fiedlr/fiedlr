--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           System.FilePath
import           Data.Maybe
import           Data.Monoid (mappend)
import           Hakyll

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match (fromList ["about.rst", "contact.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "csl/*" $ compile cslCompiler
    match "bib/*" $ compile biblioCompiler

    match "posts/2019-01-30-sample.tex" $ do
        route   $ setExtension "html"
        compile $ do
            --itemFilePath <- getResourceFilePath
            --
            id         <- getUnderlying
            biblioFile <- getMetadataField id "bibliography"
            (maybe pandocCompiler (\biblioFileName ->
                pandocBiblioCompiler 
                    "csl/elsevier-with-titles-alphabetical.csl"
                    ("bib" </> biblioFileName <.> "bib")
                ) biblioFile)
            -- let fileName = "bib" </> (fromMaybe "default" biblioFile) <.> "bib"
            -- pandocBiblioCompiler
            --        "csl/elsevier-with-titles-alphabetical.csl" (fileName)
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls


    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Home"                `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext
