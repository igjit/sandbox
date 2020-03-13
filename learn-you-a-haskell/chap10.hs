-- 10.1 逆ポーランド記法電卓

solveRPN :: String -> Double
solveRPN = head . foldl foldingFunction [] . words
  where foldingFunction (x:y:ys) "*" = (y * x):ys
        foldingFunction (x:y:ys) "+" = (y + x):ys
        foldingFunction (x:y:ys) "-" = (y - x):ys
        foldingFunction (x:y:ys) "/" = (y / x):ys
        foldingFunction (x:y:ys) "^" = (y ** x):ys
        foldingFunction (x:ys) "ln" = log x:ys
        foldingFunction xs "sum" = [sum xs]
        foldingFunction xs numberString = read numberString:xs

-- solveRPN "10 4 3 + 2 * -"
-- solveRPN "2.7 ln"
-- solveRPN "10 10 10 10 10 sum 4 /"
-- solveRPN "10 2 ^"

-- 10.2 ヒースロー空港からロンドンへ

data Section = Section { getA :: Int, getB :: Int, getC :: Int }
  deriving (Show)

type RoadSystem = [Section]

heathrowToLondon :: RoadSystem
heathrowToLondon = [ Section 50 10 30
                   , Section 5 90 20
                   , Section 40 2 25
                   , Section 10 8 0
                   ]

data Label = A | B | C deriving (Show)

type Path = [(Label, Int)]
