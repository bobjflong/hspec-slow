## hspec-slow

Track and display slow specs in Hspec runs.

## Example spec

```haskell
main :: IO ()
main = do
  conf <- configure 1
  timedHspec conf $ \timed -> do
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

## Parallel specs

Parallel specs are supported. They are run similarly to above:

```haskell
timedHspecParallel conf $ \timed -> do
  -- ...
```

Output:

```
time stack test
hspec-slow-0.1.0.0: test (suite: hspec-slow-test)

Main
  Example 1
  Example 2
  Example 3
Slow examples:
3.002526s: Example 1
4.002236s: Example 3

Finished in 4.0028 seconds
3 examples, 0 failures
stack test  0.81s user 0.21s system 20% cpu 4.963 total
```
