-- 12.1 既存の型を新しい型にくるむ

newtype CharList = CharList { getCharList :: [Char] } deriving (Eq, Show)

-- CharList "this will be shown!"
-- getCharList $ CharList "benny"

newtype Pair b a = Pair { getPair :: (a, b) }

instance Functor (Pair c) where
  fmap f (Pair (x, y)) = Pair (f x, y)

-- getPair $ fmap (*100) (Pair (2, 3))
-- getPair $ fmap reverse (Pair ("london calling", 3))
