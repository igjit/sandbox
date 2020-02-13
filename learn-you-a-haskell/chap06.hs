-- 6.1 モジュールをインポートする

import Data.List
import Data.Char
import qualified Data.Map as Map

numUniques :: (Eq a) => [a] -> Int
numUniques = length . nub

-- import qualified Data.Map as M

-- 6.2 標準モジュールの関数で問題を解く

-- words "hey these are the words in this sentence"

wordNums :: String -> [(String,Int)]
wordNums = map (\ws -> (head ws, length ws)) . group . sort . words

-- wordNums "wa wa wee wa"

isIn :: (Eq a) => [a] -> [a] -> Bool
needle `isIn` haystack = any (needle `isPrefixOf`) (tails haystack)

-- "art" `isIn` "party"

encode :: Int -> String -> String
encode offset msg = map (\c -> chr $ ord c + offset) msg

-- encode 3 "hey mark"

decode :: Int -> String -> String
decode shift msg = encode (negate shift) msg

-- decode 3 $ encode 3 "hey mark"

digitSum :: Int -> Int
digitSum = sum . map digitToInt . show

firstTo40 :: Maybe Int
firstTo40 = find (\x -> digitSum x == 40) [1..]

-- 6.3 キーから値へのマッピング

phoneBook =
  [("betty", "555-2938")
  ,("bonnie", "452-2928")
  ,("patsy", "493-2928")
  ,("lucille", "205-2928")
  ,("wendy", "939-8282")
  ,("penny", "853-2492")
  ]

findKey :: (Eq k) => k -> [(k, v)] -> Maybe v
findKey key xs = foldr (\(k, v) acc -> if key == k then Just v else acc) Nothing xs

-- findKey "betty" phoneBook

phoneBook' = Map.fromList $
  [("betty", "555-2938")
  ,("bonnie", "452-2928")
  ,("patsy", "493-2928")
  ,("lucille", "205-2928")
  ,("wendy", "939-8282")
  ,("penny", "853-2492")
  ]

-- Map.lookup "betty" phoneBook'

phoneBook'' =
  [("betty", "555-2938")
  ,("betty", "342-2492")
  ,("bonnie", "452-2928")
  ,("patsy", "493-2928")
  ,("patsy", "943-2929")
  ,("patsy", "827-9162")
  ,("lucille", "205-2928")
  ,("wendy", "939-8282")
  ,("penny", "853-2492")
  ,("penny", "555-2111")
  ]

phoneBookToMap :: (Ord k) => [(k, a)] -> Map.Map k [a]
phoneBookToMap xs = Map.fromListWith (++) $ map (\ (k, v) -> (k, [v])) xs

-- Map.lookup "patsy" $ phoneBookToMap phoneBook''
