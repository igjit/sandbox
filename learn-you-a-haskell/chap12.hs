import Data.Monoid
import qualified Data.Foldable as F

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

-- Nothing `mappend` Just "andy"
-- Just (Sum 3) `mappend` Just (Sum 4)

-- getFirst $ First (Just 'a') `mappend` First (Just 'b')
-- getFirst $ First Nothing `mappend` First (Just 'b')

-- getFirst . mconcat . map First $ [Nothing, Just 9, Just 10]
-- getLast . mconcat . map Last $ [Nothing, Just 9, Just 10]

-- 12.4 モノイドで畳み込む

-- F.foldr (*) 1 [1,2,3]
-- F.foldl (+) 2 (Just 9)
-- F.foldr (||) False (Just True)

data Tree a = EmptyTree | Node a (Tree a) (Tree a) deriving (Show)

instance F.Foldable Tree where
  foldMap f EmptyTree = mempty
  foldMap f (Node x l r) = F.foldMap f l `mappend`
                           f x `mappend`
                           F.foldMap f r

testTree = Node 5
           (Node 3
             (Node 1 EmptyTree EmptyTree)
             (Node 6 EmptyTree EmptyTree)
           )
           (Node 9
            (Node 8 EmptyTree EmptyTree)
            (Node 10 EmptyTree EmptyTree)
           )

-- F.foldl (+) 0 testTree
-- F.foldl (*) 1 testTree

-- getAny $ F.foldMap (\x -> Any $ x == 3) testTree
-- getAny $ F.foldMap (\x -> Any $ x > 15) testTree

-- F.foldMap (\x -> [x]) testTree
