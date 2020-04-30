{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Control.Monad (when)
import Control.Concurrent.Async
import Control.Concurrent (threadDelay)
import Data.Text (Text)
import Say

getURL :: Text -> IO Text
getURL url = do

  say $ "Downloading " <> url <> ": Starting"
  threadDelay (1 * 1000000)
  say $ "Downloading " <> url <> ": 1 second passed"

  when (url == "url1") $ error $ "connection aborted for " <> show url

  threadDelay (1 * 1000000)
  say $ "Downloading " <> url <> ": 2 seconds passed"
  threadDelay (1 * 1000000)
  say $ "Downloading " <> url <> ": 3 second3 passed"
  threadDelay (1 * 1000000)
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

  (page1, page2) <- concurrently (getURL "url1") (getURL "url2")
  print page1
  print page2
