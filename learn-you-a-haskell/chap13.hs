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

landLeft :: Birds -> Pole -> Pole
landLeft n (left, right) = (left + n, right)

landRight :: Birds -> Pole -> Pole
landRight n (left, right) = (left, right + n)

-- landLeft 2 (0, 0)
-- landRight (-1) (1, 2)

x -: f = f x

-- (0, 0) -: landLeft 1 -: landRight 1 -: landLeft 2
