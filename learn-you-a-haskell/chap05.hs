-- 5.1 カリー化関数

multThree :: Int -> Int -> Int -> Int
multThree x y z = x * y * z

multTwoWithNine = multThree 9

compareWithHundred :: Int -> Ordering
compareWithHundred = compare 100

divideByTen :: (Floating a) => a -> a
divideByTen = (/10)

isUpperAlphanum :: Char -> Bool
isUpperAlphanum = (`elem` ['A'..'Z'])

-- 5.2 高階実演

applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)

-- applyTwice (+3) 10

zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' _ [] _ = []
zipWith' _ _ [] = []
zipWith' f (x:xs) (y:ys) = f x y : zipWith' f xs ys

-- zipWith' (+) [4,2,5,6] [2,6,2,3]

-- 5.3 関数プログラマの道具箱

-- map (+3) [1,5,3,1,6]

-- filter (>3) [1,5,3,2,1,6,4,3,2,1]

quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) =
  let smallerOrEqual = filter (<= x) xs
      larger = filter (> x) xs
  in quicksort smallerOrEqual ++ [x] ++ quicksort larger

largestDivisible :: Integer
largestDivisible = head (filter p [100000,99999..])
  where p x = x `mod` 3829 == 0

chain :: Integer -> [Integer]
chain 1 = [1]
chain n
  | even n = n : chain (n `div` 2)
  | odd n = n : chain (n * 3 + 1)

numLongChains :: Int
numLongChains = length (filter isLong (map chain [1..100]))
  where isLong xs = length xs > 15

-- 5.4 ラムダ式

-- zipWith (\ a b -> (a * 30 + 3) / b) [5,4,3,2,1] [1,2,3,4,5]

-- 5.5 畳み込み、見込みアリ!

sum' :: (Num a) => [a] -> a
sum' = foldl (+) 0

map' :: (a -> b) -> [a] -> [b]
map' f xs = foldr (\x acc -> f x : acc) [] xs

maximum' :: (Ord a) => [a] -> a
maximum' = foldl1 max

reverse' :: [a] -> [a]
reverse' = foldl (flip (:)) []

and' :: [Bool] -> Bool
and' xs = foldr (&&) True xs

-- and' (repeat False)

-- scanl (+) 0 [3,5,2,1]

sqrtSums :: Int
sqrtSums = length (takeWhile (<1000) (scanl1 (+) (map sqrt [1..]))) + 1

-- 5.6 $ を使った関数適用

-- sum $ filter (> 10) $ map (*2) [2..10]

-- map ($ 3) [(4+), (10*), (^2), sqrt]

-- 5.7 関数合成

-- map (negate . abs) [5,-3,-6,7,-3,2,-19,24]

-- sum . replicate 5 $ max 6.7 8.9
