module Main where

import Data.List (tails, transpose)

windows :: Int ->  [a] -> [[a]]
windows n = filter (\x -> length x == n) . map (take n) . tails

windows_2d :: Int -> [[a]] -> [[[a]]]
windows_2d n = windows n . concat . transpose .  map (windows n)

parse :: String -> [[Char]]
parse = lines

valid_x :: [[Char]] -> Bool
valid_x matrix = (diagonal1 == "MAS" || diagonal1 == "SAM") && (diagonal2 == "MAS" || diagonal2 == "SAM")
  where
    diagonal1 = zipWith (!!) matrix [0..]
    diagonal2 = zipWith (!!) (map reverse $ matrix) [0..]

solution :: String -> Int
solution = length . filter id . map valid_x . windows_2d 3 . parse

main :: IO ()
main = do
  contents <- readFile "./input.txt"
  print $ solution contents
