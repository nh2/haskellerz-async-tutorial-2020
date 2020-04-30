{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Control.Applicative ((<|>))
import Control.Concurrent (forkIO, threadDelay)
import Control.Concurrent.MVar
import Control.Exception (bracket, bracket_)
import Control.Monad (when)
import Data.Foldable (for_)
import Data.Text (Text)
import qualified Data.Text as T
import Say
import System.Timeout (timeout)
import UnliftIO.Async
import Control.Concurrent.QSem

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

  -- page <- timeout 1500000 $ getURL "url1"
  -- print page

  -- var1 <- newEmptyMVar
  -- var2 <- newEmptyMVar

  -- tid1 <- forkIO $ do
  --   page1 <- getURL "url1"
  --   error $ "connection aborted"
  --   putMVar var1 page1
  --   say $ T.pack $ show page1

  -- tid2 <- forkIO $ do
  --   page2 <- getURL "url2"
  --   putMVar var2 page2
  --   say $ T.pack $ show page2

  -- print tid1
  -- print tid2

  -- page1 <- takeMVar var1 -- this hangs forever (unless GHC detects it, then we get a fancy error we didn't expect)
  -- page2 <- takeMVar var2


  -- print page1
  -- print page2

  let withQSem :: QSem -> IO a -> IO a
      withQSem sem f = bracket_ (waitQSem sem) (signalQSem sem) f


  let urls =
        [ T.pack ("url" <> show i)
        | i <- [1..20 :: Int]
        ]

  sem <- newQSem 4

  pages <- forConcurrently urls $ \url ->
    -- Safe but not great, because it will start more threads at cancellation
    -- because not all cancellation signals appear at the same time,
    -- so some QSem slots become free before their threads get cancelled.
    -- Confusing behaviour seen by the user.
    --
    -- Also bad because we start unlimitedly many threads in `forConcurrently`
    -- and then they all block (memory usage and schedulding overhead).
    withQSem sem $ do
      getURL url
  print pages
