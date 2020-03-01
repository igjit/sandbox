import System.IO

main = do
  withFile "baabaa.txt" ReadMode $ \ handle -> do
  contents <- hGetContents handle
  putStr contents
