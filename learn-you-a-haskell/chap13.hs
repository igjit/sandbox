import Control.Monad

-- 13.2 Maybeから始めるモナド

applyMaybe :: Maybe a -> (a -> Maybe b) -> Maybe b
applyMaybe Nothing f = Nothing
applyMaybe (Just x) f = f x

-- Just 3 `applyMaybe` \x -> Just (x+1)
-- Just "smile" `applyMaybe` \x -> Just (x ++ " :)")
-- Nothing `applyMaybe` \x -> Just (x+1)
-- Nothing `applyMaybe` \x -> Just (x ++ " :)")
-- Just 3 `applyMaybe` \x -> if x > 2 then Just x else Nothing
-- Just 1 `applyMaybe` \x -> if x > 2 then Just x else Nothing

-- 13.3 Monad型クラス

-- return "WHAT" :: Maybe String
-- Just 9 >>= \x -> return (x*10)
-- Nothing >>= \x -> return (x*10)

-- 13.4 綱渡り

type Birds = Int
type Pole = (Birds, Birds)

-- landLeft :: Birds -> Pole -> Pole
-- landLeft n (left, right) = (left + n, right)

-- landRight :: Birds -> Pole -> Pole
-- landRight n (left, right) = (left, right + n)

-- landLeft 2 (0, 0)
-- landRight (-1) (1, 2)

x -: f = f x

-- (0, 0) -: landLeft 1 -: landRight 1 -: landLeft 2

landLeft :: Birds -> Pole -> Maybe Pole
landLeft n (left, right)
  | abs ((left + n) - right) < 4 = Just(left + n, right)
  | otherwise = Nothing

landRight :: Birds -> Pole -> Maybe Pole
landRight n (left, right)
  | abs(left - (right + n)) < 4 = Just(left, right + n)
  | otherwise = Nothing

-- landLeft 2 (0, 0)
-- landLeft 10 (0, 3)

-- landRight 1 (0, 0) >>= landLeft 2
-- Nothing >>= landLeft 2

-- return (0, 0) >>= landRight 2 >>= landLeft 2 >>= landRight 2
-- return (0, 0) >>= landLeft 1 >>= landRight 4 >>= landLeft (-1) >>= landRight (-2)

banana :: Pole -> Maybe Pole
banana _ = Nothing

-- return (0, 0) >>= landLeft 1 >>= banana >>= landRight 1
-- return (0, 0) >>= landLeft 1 >> Nothing >>= landRight 1

-- 13.5 do記法

-- Just 3 >>= (\x -> Just (show x ++ "!"))
-- Just 3 >>= (\x -> Just "!" >>= (\y -> Just (show x ++ y)))

foo :: Maybe String
foo = do
  x <- Just 3
  y <- Just "!"
  Just (show x ++ y)

routine :: Maybe Pole
routine = do
  start <- return (0, 0)
  first <- landLeft 2 start
  Nothing
  second <- landRight 2 first
  landLeft 1 second

justH :: Maybe Char
justH = do
  (x:xs) <- Just "hello"
  return x

-- 13.6 リストモナド

-- [3,4,5] >>= \x -> [x,-x]

-- [1,2] >>= \n -> ['a','b'] >>= \ch -> return (n, ch)

listOfTuples :: [(Int, Char)]
listOfTuples = do
  n <- [1,2]
  ch <- ['a','b']
  return (n, ch)

-- [ (n, ch) | n <- [1,2], ch <- ['a','b'] ]

-- [ x | x <- [1..50], '7' `elem` show x ]

-- [1..50] >>= (\x -> guard ('7' `elem` show x) >> return x)

sevensOnly :: [Int]
sevensOnly = do
  x <- [1..50]
  guard ('7' `elem` show x)
  return x

type KnightPos = (Int, Int)

moveKnight :: KnightPos -> [KnightPos]
moveKnight (c,r) = do
  (c', r') <- [(c+2,r-1),(c+2,r+1),(c-2,r-1),(c-2,r+1)
              ,(c+1,r-2),(c+1,r+2),(c-1,r-2),(c-1,r+2)
              ]
  guard (c' `elem` [1..8] && r' `elem` [1..8])
  return (c', r')

-- moveKnight (6, 2)

in3 :: KnightPos -> [KnightPos]
in3 start = do
  first <- moveKnight start
  second <- moveKnight first
  moveKnight second

canReachIn3 :: KnightPos -> KnightPos -> Bool
canReachIn3 start end = end `elem` in3 start

-- (6, 2) `canReachIn3` (6, 1)

-- 13.7 モナド則

-- return 3 >>= (\x -> Just (x+100000))
-- return "WoM" >>= (\x -> [x,x,x])

-- Just "move on up" >>= return
-- [1,2,3,4] >>= return

-- return (0, 0) >>= (\x -> landRight 2 x >>= (\y -> landLeft 2 y >>= (\z -> landRight 2 z)))
