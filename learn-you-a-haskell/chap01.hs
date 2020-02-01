-- 1.2 赤ちゃんの最初の関数

doubleMe x = x + x

doubleUs x y = x * 2 + y * 2

doubleSmallNumber x = if x > 100
                      then x
                      else x * 2

doubleSmallNumber' x = (if x > 100 then x else x * 2) + 1

-- 1.5 リスト内包表記

boomBangs xs = [if x < 10 then "BOOM!" else "BANG!" | x <- xs, odd x]

length' xs = sum [1 | _ <- xs]

removeNonUpperCase st = [c | c <- st, c `elem` ['A'..'Z']]

-- 1.6 タプル

-- let rightTriangles = [ (a,b,c) | c <- [1..10], a <- [1..c], b <- [1..a], a^2 + b^2 == c^2]

-- let rightTriangles' = [ (a,b,c) | c <- [1..10], a <- [1..c], b <- [1..a], a^2 + b^2 == c^2, a+b+c == 24]
