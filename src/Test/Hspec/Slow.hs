{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE RankNTypes   #-}

module Test.Hspec.Slow (
    configure,
    timedHspec,
    timedHspecParallel
  ) where

import           Control.Concurrent.STM.TVar
import           Control.Monad.IO.Class
import           Control.Monad.Reader
import           Control.Monad.STM
import           Data.Time.Clock
import           Test.Hspec

type SlowResults = [(String, NominalDiffTime)]
type SlowResultTracker = TVar SlowResults

data SlowConfiguration = SlowConfiguration {
  duration :: Int,
  tracker  :: SlowResultTracker
}

configure :: Int -> IO SlowConfiguration
configure x =
  newTVarIO [] >>= \t ->
    return (SlowConfiguration x t)

stopwatch :: MonadIO m => m a -> m (a, NominalDiffTime)
stopwatch x = do
  start <- liftIO $ getCurrentTime
  !a <- x
  end <- liftIO $ getCurrentTime
  return (a, end `diffUTCTime` start)

trackedAction :: MonadIO m => String -> m a -> ReaderT SlowConfiguration m a
trackedAction s m = do
  conf <- ask
  (result, d) <- lift (stopwatch m)
  if (d > (realToFrac . duration $ conf))
    then do
      liftIO $ atomically $ modifyTVar (tracker conf) (++ [(s, d)])
      return result
    else do
      return result

type Timer = forall m a. (MonadIO m, Example (m a)) => String -> m a -> SpecWith (Arg (m a))

timed :: SlowConfiguration -> Timer
timed c s a = it s $ runReaderT (trackedAction s a) c

slowReport :: (MonadIO m) => SlowConfiguration -> m ()
slowReport s = do
  slows <- liftIO $ readTVarIO (tracker s)
  liftIO $ putStrLn "Slow examples:"
  liftIO $ mapM_ (\(t, v) -> putStrLn $ (show v) ++ ": " ++ t) slows

timedHspec :: SlowConfiguration -> (Timer -> SpecWith ()) -> IO ()
timedHspec t x = hspec $ (afterAll_ . slowReport) t $ x (timed t)

timedHspecParallel :: SlowConfiguration -> (Timer -> SpecWith ()) -> IO ()
timedHspecParallel t x = hspec $ (afterAll_ . slowReport) t $ parallel $ x (timed t)
