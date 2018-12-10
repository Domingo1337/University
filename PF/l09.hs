-- Zadanie 1
f :: [Integer] -> [Integer]
f [] = []
f (x:xs) = [y | y <- xs, y `mod` x /= 0]

primes = map head (iterate f [2 ..])

-- Zadanie 2
primes' = 2 :[x | x <- [3..], all (\y -> x `mod` y /= 0) (takeWhile (\y -> y * y <= x) [2 ..])]

-- Zadanie 3
fib = 1 : 1 : zipWith (+) fib (tail fib)

-- Zadanie 4
iperm :: [a] -> [[a]]
iperm [] = [[]]
iperm (x:xs) = concatMap (insAll x) (iperm xs)
  where
    insAll :: a -> [a] -> [[a]]
    insAll x [] = [[x]]
    insAll x (y:ys) = (x : y : ys) : map (y :) (insAll x ys)

sperm :: [a] -> [[a]]
sperm [] = [[]]
sperm (x:xs) =
  concatMap (\xs -> map (head xs :) (sperm (tail xs))) (mixhead x xs [])
  where
    mixhead :: a -> [a] -> [a] -> [[a]]
    mixhead x [] rys = [x : reverse rys]
    mixhead x (y:ys) rs = (x : reverse rs ++ (y : ys)) : mixhead y ys (x : rs)

-- Zadanie 5
sublist :: [a] -> [[a]]
sublist [] = [[]]
sublist (x:xs) = map (x :) (sublist xs) ++ sublist xs

-- Zadanie 6
diagonal :: [a] -> [b] -> [(a, b)]
diagonal [] _ = []
diagonal _ [] = []
diagonal (x:xs) (y:ys) = (x, y) : diagonal xs ys

(><) :: [a] -> [b] -> [(a, b)]
(><) xs ys = mixhead xs ys []
  where
    mixhead :: [a] -> [b] -> [b] -> [(a, b)]
    mixhead [] [] _ = []
    mixhead (x:xs) [] rys = diagonal xs rys ++ mixhead xs [] rys
    mixhead xs (y:ys) rys = diagonal xs (y : rys) ++ mixhead xs ys (y : rys)
