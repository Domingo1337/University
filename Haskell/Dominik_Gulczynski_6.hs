-- Dominik Gulczyński
-- Kurs Języka Haskell
-- 17.04.2020
-- Lista 6

{-# LANGUAGE ViewPatterns #-}

import           Prelude                 hiding ( foldr
                                                , tail
                                                , reverse
                                                , zip
                                                )

-- Zadanie 1 -------------------------------------------------------------------
natPairs :: [(Integer, Integer)]
natPairs = [ (n, m - n) | m <- [0 ..], n <- [0 .. m] ]

(><) xs ys = walk xs ys []
 where
  walk []       _        _   = []
  walk (x : xs) []       rys = zip (x : xs) rys ++ walk xs [] rys
  walk xs       (y : ys) rys = zip xs (y : rys) ++ walk xs ys (y : rys)

-- Zadanie 2 -------------------------------------------------------------------
class Set s where
  emptyS :: s a
  searchS :: Ord a => a -> s a -> Maybe a
  insertS :: Ord a => a -> s a -> s a
  delMaxS :: Ord a => s a -> Maybe (a, s a)
  deleteS :: Ord a => a -> s a -> s a

class Dictionary d where
  emptyD :: d k v
  searchD :: Ord k => k -> d k v -> Maybe v
  insertD :: Ord k => k -> v -> d k v -> d k v
  deleteD :: Ord k => k -> d k v -> d k v

data KeyValue key value = KeyValue { key :: key, value :: value }

newtype SetToDict s k v = SetToDict (s (KeyValue k v))

instance Eq k => Eq (KeyValue k v) where
  (==) (KeyValue k _) (KeyValue k' _) = k == k'

instance Ord k => Ord (KeyValue k v) where
  (<=) (KeyValue k _) (KeyValue k' _) = k <= k'

instance Set s => Dictionary (SetToDict s) where
  emptyD = SetToDict emptyS
  searchD k (SetToDict s) = value <$> searchS (KeyValue k undefined) s
  insertD k v (SetToDict s) = SetToDict (insertS (KeyValue k v) s)
  deleteD k (SetToDict s) = SetToDict $ deleteS (KeyValue k undefined) s

-- Zadanie 3 -------------------------------------------------------------------
data PrimRec = Zero | Succ | Proj Int Int | Comb PrimRec [PrimRec] | Rec PrimRec PrimRec

arityCheck :: PrimRec -> Maybe Int
arityCheck Zero = Just 1
arityCheck Succ = Just 1
arityCheck (Proj i n)
  | 1 <= i && i <= n = Just n
arityCheck (Comb (arityCheck -> Just m) gs@((arityCheck -> Just n) : gs'))
  | m == length gs && all ((Just n ==) . arityCheck) gs' = Just n
arityCheck (Rec (arityCheck -> Just m) (arityCheck -> Just m2))
  | m2 - m == 2 = Just (m + 1)
arityCheck _ = Nothing

-- Zadanie 4 -------------------------------------------------------------------
evalPrimRec :: PrimRec -> [Integer] -> Integer
evalPrimRec _ xs | any (< 0) xs = error "Negative arguments"
evalPrimRec Zero [n]            = 0
evalPrimRec Succ [n]            = n + 1
evalPrimRec (Proj i n) ns
  | 1 <= i && i <= n && length ns == n = ns !! (i - 1)
evalPrimRec c@(Comb f gs) ns    = evalPrimRec f $ map (evalPrimRec `flip` ns) gs
  -- nie musimy sprawdzać arności c, sprawdzona bedzie w wyw. rekurencyjnych
evalPrimRec r@(Rec g h) ns@(n : ns')
  | arityCheck r == Just (length ns) =
    if n == 0
      then evalPrimRec g ns'
      else evalPrimRec h ((n - 1) : evalPrimRec r (n - 1 : ns') : ns')
evalPrimRec _ _ = error "Invalid arity"


-- Zadanie 5 -------------------------------------------------------------------
data Nat = S Nat | Z

iter :: (a -> a) -> a -> Nat -> a
iter _ g Z     = g
iter f g (S n) = f (iter f g n)

rec :: (Nat -> a -> a) -> a -> Nat -> a
rec f g n = fst (iter (\(res, n) -> (f n res, S n)) (g, Z) n)

-- Zadanie 6 -------------------------------------------------------------------
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr _ c []       = c
foldr f c (x : xs) = f x (foldr f c xs)

tail :: [a] -> [a]
tail = snd . foldr (\x (tl, _) -> (x : tl, tl)) ([], [])

reverse :: [a] -> [a]
reverse = foldr (\x xs -> xs ++ [x]) []

zip :: [a] -> [b] -> [(a, b)]
zip = foldr f (const [])
 where
  f _ _   []       = []
  f x res (y : ys) = (x, y) : res ys
