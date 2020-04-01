-- :set -package mtl
import Control.Monad.Writer

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
