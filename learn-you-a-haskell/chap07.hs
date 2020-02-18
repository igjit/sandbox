import qualified Data.Map as Map

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

-- 7.4 型引数

-- data Maybe a = Nothing | Just a

-- Maybe は型コンストラクタ

data Vector a = Vector a a a deriving (Show)

vplus :: (Num a) => Vector a -> Vector a -> Vector a
(Vector i j k) `vplus` (Vector l m n) = Vector (i+l) (j+m) (k+n)

dotProd :: (Num a) => Vector a -> Vector a -> a
(Vector i j k) `dotProd` (Vector l m n) = i*l + j*m + k*n

vmult :: (Num a) => Vector a -> a -> Vector a
(Vector i j k) `vmult` m = Vector (i*m) (j*m) (k*m)

-- Vector 3 5 8 `vplus` Vector 9 2 8
-- Vector 3 9 7 `vmult` 10
-- Vector 4 9 5 `dotProd` Vector 9.0 2.0 4.0

-- 7.5 インスタンスの自動導出

-- read "Just 3" :: Maybe Int

-- Nothing < Just 100

data Day = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday
  deriving (Eq, Ord, Show, Read, Bounded, Enum)

-- read "Saturday" :: Day
-- Saturday > Friday

-- 7.6 型シノニム

type PhoneNumber = String
type Name = String
type PhoneBook = [(Name, PhoneNumber)]

inPhoneBook :: Name -> PhoneNumber -> PhoneBook -> Bool
inPhoneBook name pnumber pbook = (name, pnumber) `elem` pbook

data LockerState = Taken | Free deriving (Show, Eq)
type Code = String
type LockerMap = Map.Map Int (LockerState, Code)

lockerLookup :: Int -> LockerMap -> Either String Code
lockerLookup lockerNumber map = case Map.lookup lockerNumber map of
  Nothing -> Left $ "Locker " ++ show lockerNumber ++ " doesn't exist!"
  Just (state, code) -> if state /= Taken
                        then Right code
                        else Left $ "Locker " ++ show lockerNumber
                             ++ " is already taken!"

lockers :: LockerMap
lockers = Map.fromList
  [(100,(Taken, "ZD39I"))
  ,(101,(Free, "JAH3I"))
  ,(103,(Free, "IQSA9"))
  ,(105,(Free, "QOTSA"))
  ,(109,(Taken, "893JJ"))
  ,(110,(Taken, "99292"))
  ]

-- lockerLookup 101 lockers
-- lockerLookup 100 lockers
