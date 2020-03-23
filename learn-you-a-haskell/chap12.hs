import Data.Monoid

-- 12.1 既存の型を新しい型にくるむ

newtype CharList = CharList { getCharList :: [Char] } deriving (Eq, Show)

-- CharList "this will be shown!"
-- getCharList $ CharList "benny"

newtype Pair b a = Pair { getPair :: (a, b) }

instance Functor (Pair c) where
  fmap f (Pair (x, y)) = Pair (f x, y)

-- getPair $ fmap (*100) (Pair (2, 3))
-- getPair $ fmap reverse (Pair ("london calling", 3))

-- head [3,4,5,undefined,2,undefined]

newtype CoolBool = CoolBool { getCoolBool :: Bool }

helloMe :: CoolBool -> String
helloMe (CoolBool _) = "hello"

-- helloMe undefined

-- 12.3 モノイドとの遭遇

-- [1,2,3] `mappend` [4,5,6]
-- mconcat [[1,2],[3,6],[9]]

-- getProduct $ Product 3 `mappend` Product 9
-- getSum $ Sum 2 `mappend` Sum 9

-- getAny $ Any True `mappend` Any False
-- getAny $ mempty `mappend` mempty

-- getAll $ mempty `mappend` All True
-- getAll $ mempty `mappend` All False

lengthCompare :: String -> String -> Ordering
lengthCompare x y = (length x `compare` length y) `mappend`
                    (x `compare` y)

-- lengthCompare "zen" "ants"
-- lengthCompare "zen" "ant"

lengthCompare' :: String -> String -> Ordering
lengthCompare' x y = (length x `compare` length y) `mappend`
                     (vowels x `compare` vowels y) `mappend`
                     (x `compare` y)
  where vowels = length . filter (`elem` "aeiou")

-- lengthCompare' "zen" "anna"
-- lengthCompare' "zen" "ana"
-- lengthCompare' "zen" "ann"
