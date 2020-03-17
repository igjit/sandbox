-- 11.1 帰ってきたファンクター

-- fmap (replicate 3) [1,2,3,4]
-- fmap (replicate 3) (Just 4)
-- fmap (replicate 3) (Right "blah")
-- fmap (replicate 3) Nothing
-- fmap (replicate 3) (Left "foo")

-- 11.2 ファンクター則

data CMaybe a = CNothing | CJust Int a deriving (Show)

instance Functor CMaybe where
  fmap f CNothing = CNothing
  fmap f (CJust counter x) = CJust (counter+1) (f x)

-- fmap (++"ha") (CJust 0 "ho")
-- fmap id (CJust 0 "haha")

-- 11.3 アプリカティブファンクターを使おう

-- let a = fmap (*) [1,2,3,4]
-- fmap ( \ f -> f 9) a

-- pure (+) <*> Just 3 <*> Just 5

-- (++) <$> Just "johntra" <*> Just "volta"

-- [(*0),(+100),(^2)] <*> [1,2,3]
