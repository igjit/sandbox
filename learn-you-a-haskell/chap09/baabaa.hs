import System.IO

main = do
  handle <- openFile "baabaa.txt" ReadMode
  contents <- hGetContents handle
  putStr contents
  hClose handle
