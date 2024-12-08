module Main where

import Data.List (tails, transpose)

windows :: Int ->  [a] -> [[a]]
windows n = filter (\x -> length x == n) . map (take n) . tails

parse :: String -> [[Char]]
parse = lines

getHorisontal :: Int -> [[Char]] -> [String]
getHorisontal length = concatMap (windows length)

getHorisontalBackward :: Int -> [[Char]] -> [String]
getHorisontalBackward length xs  = map reverse $ getHorisontal length xs

getVertical :: Int -> [[Char]] -> [String]
getVertical length xs = getHorisontal length  $ transpose xs

getVerticalBackward :: Int -> [[Char]] -> [String]
getVerticalBackward length xs = map reverse $ getVertical length xs

diagonals :: [[a]] -> [[a]]
diagonals [] = []
diagonals [row] = map (: []) row
diagonals (row : rows) = extendDiagonals row (diagonals rows)
  where
    extendDiagonals row diags = zipWith (:) row ([] : diags) ++ drop (length row - 1) diags

getDiagonal :: Int -> [[Char]] -> [String]
getDiagonal n xs = concatMap (windows n) $ alldiags
  where
    alldiags = diagonals xs ++ diagonals (map reverse xs)

getDiagonalBackward :: Int -> [[Char]] -> [String]
getDiagonalBackward length xs = map reverse $ getDiagonal length xs


solution :: String -> String -> Int
solution goal input = length $ filter (== goal) $ concatMap (\f -> f (length goal) parsed) functions
  where
    parsed = parse input
    functions = [getDiagonalBackward, getDiagonal, getHorisontal, getHorisontalBackward, getVertical, getVerticalBackward]

main :: IO ()
main = do
  contents <- readFile "./input.txt"
  print $ solution "XMAS" contents
