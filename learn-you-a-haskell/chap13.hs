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
