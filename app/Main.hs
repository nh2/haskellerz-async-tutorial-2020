{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Control.Exception (bracket)
import Control.Applicative ((<|>))
import Control.Monad (when)
import Control.Concurrent.Async
import Control.Concurrent (threadDelay)
import Data.Foldable (for_)
import Data.Text (Text)
import qualified Data.Text as T
import Say
import System.Timeout (timeout)

data Resource = FileDescriptor
  deriving (Eq, Ord, Show)

getURL :: Text -> IO Text
getURL url = do
  bracket
    -- create resource
    (do say $ "Acquiring file descriptor"
        return FileDescriptor
    )
    -- free the resouce
    (\fd -> say $ "Deallocating file descriptor " <> T.pack (show fd))
    $ \fd -> do -- do something with the resource

      say $ "Downloading " <> url <> ": Starting with fd " <> T.pack (show fd)
      threadDelay (1 * 1000000)
      say $ "Downloading " <> url <> ": 1 second passed"

      -- when (url == "url1") $ error $ "connection aborted for " <> show url

      threadDelay (1 * 1000000)
      say $ "Downloading " <> url <> ": 2 seconds passed"
      threadDelay (1 * 1000000)
      say $ "Downloading " <> url <> ": 3 second3 passed"
      threadDelay (1 * 1000000)
      say $ "Downloading " <> url <> ": Done"

      return $ "Contents of " <> url

getURLwithDuration :: Int -> Text -> IO Text
getURLwithDuration seconds url = do

  say $ "Downloading " <> url <> ": Starting"

  for_ [1..seconds] $ \s -> do
    threadDelay (1 * 1000000)
    say $ "Downloading " <> url <> ": " <> T.pack (show s) <> " second passed"

  say $ "Downloading " <> url <> ": Done"

  return $ "Contents of " <> url


main :: IO ()
main = do
  -- res1 <- getURL "url1"
  -- res2 <- getURL "url2"
  -- print res1
  -- print res2

  -- withAsync (getURL "url1") $ \a1 -> do
  --   withAsync (getURL "url2") $ \a2 -> do
  --     page1 <- wait a1
  --     page2 <- wait a2
  --     print page1
  --     print page2

  -- (page1, page2) <- concurrently (getURL "url1") (getURL "url2")
  -- print page1
  -- print page2

  -- let urls =
  --       [ "url1"
  --       , "url2"
  --       , "url3"
  --       , "url4"
  --       ]

  -- pages <- forConcurrently urls $ \url ->
  --   getURL url
  -- print pages

  -- eResult <- race
  --   (getURLwithDuration 5 "url1")
  --   (getURLwithDuration 3 "url2")

  -- print eResult


  -- (page1, page2, page3)
  --     <-
  --     runConcurrently $
  --       (,,)
  --         <$> Concurrently (getURL "url1")
  --         <*> ( Concurrently (getURL "url2a") <|> Concurrently (getURL "url2b") )
  --         <*> Concurrently (getURL "url3")

  -- print page1
  -- print page2
  -- print page3


  -- Cross-thread communications:
  -- * IORef
  -- * MVar
  -- * Chan
  -- * STM

  page <- timeout 1500000 $ getURL "url1"
  print page
