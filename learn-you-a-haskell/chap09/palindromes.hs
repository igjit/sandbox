main = interact respondPalindromes

respondPalindromes :: String -> String
respondPalindromes =
  unlines .
  map ( \ xs -> if isPal xs then "palindrome" else "not a palindrome") .
  lines

isPal :: String -> Bool
isPal xs = xs == reverse xs
