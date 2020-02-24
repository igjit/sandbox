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

-- 7.7 再帰的なデータ構造

-- data List a = Empty | Cons a (List a) deriving (Show, Read, Eq, Ord)

-- 5 `Cons` Empty

infixr 5 :-:
data List a = Empty | a :-: (List a) deriving (Show, Read, Eq, Ord)

-- 3 :-: 4 :-: 5 :-: Empty

infixr 5 ^++
(^++) :: List a -> List a -> List a
Empty ^++ ys = ys
(x :-: xs) ^++ ys = x :-: (xs ^++ ys)

-- a = 3 :-: 4 :-: 5 :-: Empty
-- b = 6 :-: 7 :-: Empty
-- a ^++ b

data Tree a = EmptyTree | Node a (Tree a) (Tree a) deriving (Show)

singleton :: a -> Tree a
singleton x = Node x EmptyTree EmptyTree

treeInsert :: (Ord a) => a -> Tree a -> Tree a
treeInsert x EmptyTree = singleton x
treeInsert x (Node a left right)
  | x == a = Node x left right
  | x < a = Node a (treeInsert x left) right
  | x > a = Node a left (treeInsert x right)

treeElem :: (Ord a) => a -> Tree a -> Bool
treeElem x EmptyTree = False
treeElem x (Node a left right)
  | x == a = True
  | x < a = treeElem x left
  | x > a = treeElem x right

nums = [8,6,4,1,7,3,5]
numsTree = foldr treeInsert EmptyTree nums

-- 8 `treeElem` numsTree

data TrafficLight = Red | Yellow | Green

instance Eq TrafficLight where
  Red == Red = True
  Green == Green = True
  Yellow == Yellow = True
  _ == _ = False

instance Show TrafficLight where
  show Red = "Red light"
  show Yellow = "Yellow light"
  show Green = "Green light"

-- Red == Red

-- 7.9 Yes と No の型クラス

class YesNo a where
  yesno :: a -> Bool

instance YesNo Int where
  yesno 0 = False
  yesno _ = True

instance YesNo [a] where
  yesno [] = False
  yesno _ = True

instance YesNo Bool where
  yesno = id

instance YesNo (Maybe a) where
  yesno (Just _ ) = True
  yesno Nothing = False

instance YesNo (Tree a) where
  yesno EmptyTree = False
  yesno _ = True

instance YesNo TrafficLight where
  yesno Red = False
  yesno _ = True

-- yesno $ length []
-- yesno "haha"
-- yesno ""

yesnoIf :: (YesNo y) => y -> a -> a -> a
yesnoIf yesnoVal yesResult noResult =
  if yesno yesnoVal
  then yesResult
  else noResult

-- yesnoIf [] "YEAH!" "NO!"
-- yesnoIf [2,3,4] "YEAH!" "NO!"

-- 7.10 Functor 型クラス

-- fmap (*2) [1..3]

-- fmap (++ " HEY GUYS IM INSIDE THE JUST") (Just "Something serious.")
-- fmap (++ " HEY GUYS IM INSIDE THE JUST") Nothing

instance Functor Tree where
  fmap f EmptyTree = EmptyTree
  fmap f (Node x left right)
    = Node (f x) (fmap f left) (fmap f right)

-- fmap (*4) (foldr treeInsert EmptyTree [5,7,3])
