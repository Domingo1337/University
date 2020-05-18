-- Dominik Gulczyński
-- Kurs Języka Haskell
-- 13.02.2020
-- Lista 1

import           Prelude                 hiding ( concat
                                                , concat
                                                , and
                                                , all
                                                )
import           Data.Char


-- Zadanie 1 -------------------------------------------------------------------
intercalate :: [a] -> [[a]] -> [a]
intercalate _ []       = []
intercalate _ [y     ] = y
intercalate x (y : ys) = y ++ x ++ intercalate x ys

-- zakłada, że argumentem jest poprawna macierz, tzn podlisty są tej samej długości
transpose :: [[a]] -> [[a]]
transpose = reverse . grabHeads []
 where
  grabHeads :: [[a]] -> [[a]] -> [[a]]
  grabHeads acc []       = acc
  grabHeads acc ([] : _) = acc
  grabHeads acc xs       = grabHeads (heads : acc) tails
   where
    (heads, tails) =
      foldr (\l a -> (head l : fst a, tail l : snd a)) ([], []) xs

concat :: [[a]] -> [a]
concat = foldr (++) []

and :: [Bool] -> Bool
and [True     ] = True
and (True : xs) = and xs
and _           = False

all :: (a -> Bool) -> [a] -> Bool
all f = and . map f

maximum :: [Integer] -> Integer
maximum []       = error "empty"
maximum (x : xs) = foldr max x xs


-- Zadanie 2 -------------------------------------------------------------------
newtype Vector a = Vector { fromVector :: [a] } deriving Show

scaleV :: Num a => a -> Vector a -> Vector a
scaleV scalar = Vector . map (scalar *) . fromVector

norm :: Floating a => Vector a -> a
norm = sqrt . foldl (\acc x -> acc + x * x) 0 . fromVector

-- bardzo przydatna pomocniczna funkcja, działająca jak zipWith,
-- ale kończąca się błędem dla argumentów różnej długości
zipWithLength :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWithLength _ []       []       = []
zipWithLength _ _        []       = error "arguments of different length"
zipWithLength _ []       _        = error "arguments of different length"
zipWithLength f (x : xs) (y : ys) = f x y : zipWithLength f xs ys

zipWithV :: (a -> b -> c) -> Vector a -> Vector b -> Vector c
zipWithV f (Vector v) (Vector u) = Vector $ zipWithLength f v u

scalarProd :: Num a => Vector a -> Vector a -> a
scalarProd v u = sum . fromVector $ zipWithV (*) v u

sumV :: Num a => Vector a -> Vector a -> Vector a
sumV = zipWithV (+)


-- Zadanie 3 -------------------------------------------------------------------
newtype Matrix a = Matrix { fromMatrix :: [[a]] } deriving Show


sumM :: Num a => Matrix a -> Matrix a -> Matrix a
sumM m n =
  Matrix $ zipWithLength (zipWithLength (+)) (fromMatrix m) (fromMatrix n)

prodM :: Num a => Matrix a -> Matrix a -> Matrix a
prodM m n = Matrix
  $ map (\row -> map (sum . zipWithLength (*) row) transposed) (fromMatrix m)
  where transposed = transpose $ fromMatrix n

-- obliczany za pomocą rozwinięcia Laplace'a
-- nie warto uruchamiać dla macierzy o rozmiarze > 10
det :: Num a => Matrix a -> a
det = det' . fromMatrix
 where
  det' :: Num a => [[a]] -> a
  det' []           = 0
  det' [[   x ]   ] = x
  det' (row : rows) = fst $ foldl
    (\(acc, i) x -> ((-1) ^ i * x * det' (exclude i columns) + acc, i + 1))
    (0, 0)
    row
    --  korzystamy z tego że det M == det M^T wiec obliczamy transponowane minory zeby latwo usunac kolumne (wiersz)


   where
    columns = transpose rows
    exclude 0 []       = []
    exclude _ []       = error "not a square matrix"
    exclude 0 (_ : xs) = xs
    exclude i (x : xs) = x : exclude (i - 1) xs


-- Zadanie 4 -------------------------------------------------------------------
isbn13_check :: String -> Bool
isbn13_check s =
  sum
      ( zipWithLength (\x c -> x * digitToInt c)
                      [1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1]
      $ filter ('-' /=) s
      )
    `mod` 10
    ==    0


-- Zadanie 5 -------------------------------------------------------------------
newtype Natural = Natural { fromNatural :: [Word] } deriving Show

base :: Word
base = 1 + (floor $ sqrt (fromIntegral (maxBound :: Word) :: Double))


-- Zadanie 6 -------------------------------------------------------------------
add :: [Word] -> [Word] -> [Word]
add ns [] = ns
add [] ms = ms
add (n : ns) (m : ms) | n + m < base = n + m : add ns ms
                      | otherwise    = n + m - base : add (add [1] ns) ms

mul :: [Word] -> [Word] -> [Word]
mul []       _  = []
mul _        [] = []
mul (n : ns) ms = case mulW n ms of
  []       -> 0 : mul ns ms
  (x : xs) -> x : xs `add` mul ns ms
 where
  mulW :: Word -> [Word] -> [Word]
  mulW 0 [] = []
  mulW _ [] = []
  mulW n (m : ms) | n * m < base = n * m : mulW n ms
                  | otherwise    = r : [q] `add` mulW n ms
    where (q, r) = (n * m) `divMod` base

normalize :: Natural -> Natural
normalize (Natural n) = Natural $ aux n
 where
  aux [] = []
  aux xs | all (0 ==) xs = []
         | otherwise     = removeZeros n
  removeZeros []       = []
  removeZeros (0 : xs) = case removeZeros xs of
    []  -> []
    xs' -> 0 : xs'
  removeZeros (x : xs) = x : removeZeros xs

sub :: [Word] -> [Word] -> [Word]
sub [] _  = []
sub ns [] = ns
sub ns ms
  | length ns < length ms = []
  | otherwise = case aux ns ms of
    Nothing -> []
    Just xs -> xs
 where
  aux [] [] = Just []
  aux ns [] = Just ns
  aux [] _  = Nothing
  aux (n : ns) (m : ms) | n >= m    = addHead (n - m) $ aux ns ms
                        | otherwise = addHead (base + n - m) $ aux ns (add1 ms)
  addHead x Nothing   = Nothing
  addHead x (Just xs) = Just $ x : xs
  add1 []       = [1]
  add1 (x : xs) = (x + 1) : xs

instance Num Natural where
  (+) (Natural n) (Natural m) = normalize $ Natural $ add n m

  (*) (Natural n) (Natural m) = normalize $ Natural $ mul n m

  (-) (Natural n) (Natural m) = normalize $ Natural $ sub n m

  abs = normalize

  signum n = case normalize n of
    Natural [] -> Natural []
    _          -> Natural [1]

  fromInteger = Natural . aux
   where
    aux :: Integer -> [Word]
    aux x | x <= 0             = []
          | x > toInteger base = fromInteger r : aux q
          | otherwise          = [fromInteger x]
      where (q, r) = x `divMod` toInteger base


-- Zadanie 7 -------------------------------------------------------------------
instance Eq Natural where
  (==) (Natural n) (Natural m) = length n == length m && n == m

instance Ord Natural where
  compare (Natural n) (Natural m)
    | length n == length m = aux (reverse n) (reverse m)
    | otherwise            = compare (length n) (length m)
   where
    aux :: [Word] -> [Word] -> Ordering
    aux [] [] = EQ
    aux [] _  = LT
    aux _  [] = GT
    aux (n : ns) (m : ms) | n > m     = GT
                          | n < m     = LT
                          | otherwise = aux ns ms
