## hspec-slow

Track and display slow specs in Hspec runs.

## Example spec

```haskell
main :: IO ()
main = do
  conf <- configure 1 -- Track specs that take longer than 1s
  timedHspec conf $ \it ->
    describe "Main" $ do
      it "should foo" $ do
        threadDelay 3000000
        1 `shouldBe` 1
      it "should bar" $ do
        threadDelay 1000
        1 `shouldBe` 1
      it "should baz" $ do
        threadDelay 4000000
        1 `shouldBe` 1```
```

## Example Output

```
Main
  should foo
  should bar
  should baz
Slow examples:
3.002925s: should foo
4.006186s: should baz

Finished in 7.0141 seconds
3 examples, 0 failures
```

## Parallel specs

Parallel specs are supported. They are run similarly to above:

```haskell
timedHspecParallel conf $ \it -> do
  -- ...
```

Output:

```
Main
  should foo
  should bar
  should baz
Slow examples:
3.005728s: should foo
4.00143s: should baz

Finished in 4.0024 seconds
3 examples, 0 failures
```
