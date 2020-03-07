import System.Random

threeCoins :: StdGen -> (Bool, Bool, Bool)
threeCoins gen =
  let (firstCoin, newGen) = random gen
      (secondCoin, newGen') = random newGen
      (thirdCoin, newGen'') = random newGen'
  in (firstCoin, secondCoin, thirdCoin)

-- threeCoins (mkStdGen 22)

randoms' :: (RandomGen g, Random a) => g -> [a]
randoms' gen = let (value, newGen) = random gen in value:randoms' newGen

-- take 5 $ randoms' (mkStdGen 11)

-- randomR (1, 6) (mkStdGen 359353)

-- take 10 $ randomRs ('a', 'z') (mkStdGen 3) :: [Char]

