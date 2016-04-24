import           Control.Concurrent
import           Test.Hspec
import           Test.Hspec.Slow
import Control.Concurrent.STM.TVar
import Control.Monad.Reader

main :: IO ()
main = do
  conf <- configure 1
  timedHspec conf $ do
    describe "Main" $ do
     timed "Example 1" conf $ do
       threadDelay 3000000
       1 `shouldBe` 1
     timed "Example 2" conf $ do
       threadDelay 1000
       1 `shouldBe` 1
     timed "Example 3" conf $ do
       threadDelay 4000000
       1 `shouldBe` 1
