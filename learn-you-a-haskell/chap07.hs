-- 7.2 形づくる

-- data Shape = Circle Float Float Float | Rectangle Float Float Float Float deriving (Show)

-- -- Shapeは型, Circleは値コンストラクタ

-- area :: Shape -> Float
-- area (Circle _ _ r) = pi * r ^ 2
-- area (Rectangle x1 y1 x2 y2) = (abs $ x2 - x1) * (abs $ y2 - y1)

import Shapes

-- print $ nudge (baseCircle 30) 10 20
