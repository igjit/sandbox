-- :set -package mtl
import Control.Monad.Writer
import Control.Monad.State
import System.Random

-- 14.1 Writer? 中の人なんていません!

isBigGang :: Int -> (Bool, String)
isBigGang x = (x > 9, "Compared gang size to 9.")

-- isBigGang 3

-- applyLog :: (a, String) -> (a -> (b, String)) -> (b, String)
-- applyLog (x, log) f = let (y, newLog) = f x in (y, log ++ newLog)

-- (3, "Smallish gang.") `applyLog` isBigGang
-- ("Tobin", "Got outlaw name.") `applyLog` (\x -> (length x, "Applied length."))

applyLog :: (Monoid m) => (a, m) -> (a -> (b, m)) -> (b, m)
applyLog (x, log) f = let (y, newLog) = f x in (y, log `mappend` newLog)

-- runWriter (return 3 :: Writer String Int)

logNumber :: Int -> Writer [String] Int
logNumber x = writer (x, ["Got number: " ++ show x])

multWithLog :: Writer [String] Int
multWithLog = do
  a <- logNumber 3
  b <- logNumber 5
  tell ["Gonna multiply these two"]
  return (a*b)

-- runWriter multWithLog

gcd' :: Int -> Int -> Writer [String] Int
gcd' a b
  | b == 0 = do
      tell ["Finished with " ++ show a]
      return a
  | otherwise = do
      tell [show a ++ " mod " ++ show b ++ " = " ++ show (a `mod` b)]
      gcd' b (a `mod` b)

-- runWriter (gcd' 8 3)

gcdReverse :: Int -> Int -> Writer [String] Int
gcdReverse a b
  | b == 0 = do
      tell ["Finished with " ++ show a]
      return a
  | otherwise = do
      result <- gcdReverse b (a `mod` b)
      tell [show a ++ " mod " ++ show b ++ " = " ++ show (a `mod` b)]
      return result

-- mapM_ putStrLn $ snd $ runWriter (gcdReverse 8 3)

-- 14.2 Reader? それはあなたです!

addStuff :: Int -> Int
addStuff = do
  a <- (*2)
  b <- (+10)
  return (a+b)

-- 14.3 計算の状態の正体

type Stack = [Int]

-- pop :: Stack -> (Int, Stack)
-- pop (x:xs) = (x, xs)

-- push :: Int -> Stack -> ((), Stack)
-- push a xs = ((), a:xs)

-- stackManip :: Stack -> (Int, Stack)
-- stackManip stack = let
--   ((), newStack1) = push 3 stack
--   (a , newStack2) = pop newStack1
--   in pop newStack2

pop :: State Stack Int
pop = state $ \(x:xs) -> (x, xs)

push :: Int -> State Stack ()
push a = state $ \xs -> ((), a:xs)

stackManip :: State Stack Int
stackManip = do
  push 3
  pop
  pop

-- runState stackManip [5,8,2,1]

stackStuff :: State Stack ()
stackStuff = do
  a <- pop
  if a == 5
    then push 5
    else do
      push 3
      push 8

-- runState stackStuff [9,0,2,1,0]

randomSt :: (RandomGen g, Random a) => State g a
randomSt = state random

threeCoins :: State StdGen (Bool, Bool, Bool)
threeCoins = do
  a <- randomSt
  b <- randomSt
  c <- randomSt
  return (a, b, c)

-- runState threeCoins (mkStdGen 33)
