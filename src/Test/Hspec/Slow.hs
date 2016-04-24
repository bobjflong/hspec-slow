{-# LANGUAGE BangPatterns #-}

module Test.Hspec.Slow where

import           Control.Concurrent.STM.TVar
import           Control.Monad.IO.Class
import           Control.Monad.Reader
import           Control.Monad.STM
import           Data.Time.Clock
import           Test.Hspec

type SlowResults = [(String, NominalDiffTime)]
type SlowResultTracker = TVar SlowResults

data SlowConfiguration = SlowConfiguration {
  duration :: Int
}

stopwatch :: MonadIO m => m a -> m (a, NominalDiffTime)
stopwatch x = do
  start <- liftIO $ getCurrentTimebea
  !a <- x
  end <- liftIO $ getCurrentTime
  return (a, end `diffUTCTime` start)

trackedAction :: MonadIO m => String -> SlowResultTracker -> m a -> ReaderT SlowConfiguration m a
trackedAction s t m = do
  conf <- ask
  (result, d) <- lift (stopwatch m)
  if (d > (realToFrac . duration $ conf))
    then do
      liftIO $ atomically $ modifyTVar t (++ [(s, d)])
      return result
    else do
      return result

timed
  :: (MonadIO m, Example (m a)) =>
     String
     -> SlowResultTracker
     -> SlowConfiguration
     -> m a
     -> SpecWith (Arg (m a))
timed s t c a = it s $ runReaderT (trackedAction s t a) c

slowReport :: (MonadIO m) => SlowResultTracker -> m ()
slowReport s = do
  slows <- liftIO $ readTVarIO s
  liftIO $ putStrLn "Slow examples:"
  liftIO $ mapM_ (\(t, v) -> putStrLn $ (show v) ++ ": " ++ t) slows

timedHspec t x = hspec $ (afterAll_ . slowReport) t $ x
