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
