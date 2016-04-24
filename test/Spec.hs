import           Control.Concurrent
import           Test.Hspec
import           Test.Hspec.Slow
import Control.Concurrent.STM.TVar
import Control.Monad.Reader

conf :: SlowConfiguration
conf = SlowConfiguration { duration = 1 }

main :: IO ()
main = do
  tracker <- newTVarIO []
  timedHspec tracker $ do
    describe "Main" $ do
     timed "Example 1" tracker conf $ do
       threadDelay 3000000
       1 `shouldBe` 1
     timed "Example 2" tracker conf $ do
       threadDelay 1000
       1 `shouldBe` 1
     timed "Example 3" tracker conf $ do
       threadDelay 4000000
       1 `shouldBe` 1
