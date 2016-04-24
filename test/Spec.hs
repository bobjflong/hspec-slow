import           Control.Concurrent
import           Test.Hspec
import           Test.Hspec.Slow
import Control.Concurrent.STM.TVar
import Control.Monad.Reader

main :: IO ()
main = do
  conf <- configure 1
  timedHspecParallel conf $ \timed ->
    describe "Main" $ do
      timed "Example 1" $ do
        threadDelay 3000000
        1 `shouldBe` 1
      timed "Example 2" $ do
        threadDelay 1000
        1 `shouldBe` 1
      timed "Example 3" $ do
        threadDelay 4000000
        1 `shouldBe` 1
