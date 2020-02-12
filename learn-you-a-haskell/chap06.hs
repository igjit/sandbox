-- 6.1 モジュールをインポートする

import Data.List

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
