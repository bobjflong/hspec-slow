## hspec-slow

Track and display slow specs in Hspec runs.

## Example spec

You need to create a TVar to hold slow results, then hopefully the API is familiar:

```haskell
-- Consider specs that take longer than a second as "slow"
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
```

## Example Output

```
Main
  Example 1
  Example 2
  Example 3
Slow examples:
3.006113s: Example 1
4.004954s: Example 3

Finished in 7.0152 seconds
3 examples, 0 failures
```
