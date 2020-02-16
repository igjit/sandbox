-- 7.2 形づくる

-- data Shape = Circle Float Float Float | Rectangle Float Float Float Float deriving (Show)

-- -- Shapeは型, Circleは値コンストラクタ

-- area :: Shape -> Float
-- area (Circle _ _ r) = pi * r ^ 2
-- area (Rectangle x1 y1 x2 y2) = (abs $ x2 - x1) * (abs $ y2 - y1)

import Shapes

-- print $ nudge (baseCircle 30) 10 20

-- 7.3 レコード構文

data Person = Person { firstName :: String
                     , lastName :: String
                     , age :: Int
                     , height :: Float
                     , phoneNumber :: String
                     , flavor :: String } deriving (Show)

data Car = Car { company :: String
               , model :: String
               , year :: Int
               } deriving (Show)

-- Car { company="Ford", model="Mustang", year=1967 }
