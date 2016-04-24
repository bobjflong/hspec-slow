import           Control.Concurrent
import           Control.Concurrent.STM.TVar
import           Control.Monad.Reader
import           Test.Hspec
import           Test.Hspec.Slow

main :: IO ()
main = do
  conf <- configure 1
  timedHspecParallel conf $ \it ->
    describe "Main" $ do
      it "should foo" $ do
        threadDelay 3000000
        1 `shouldBe` 1
      it "should bar" $ do
        threadDelay 1000
        1 `shouldBe` 1
      it "should baz" $ do
        threadDelay 4000000
        1 `shouldBe` 1
