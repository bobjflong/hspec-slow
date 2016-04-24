## hspec-slow

Track and display slow specs in Hspec runs.

## Example spec

You need to create a TVar to hold slow results, then hopefully the API is familiar:

```haskell
main :: IO ()
main = do
  conf <- configure 1 -- track tests that take longer than 1s
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
