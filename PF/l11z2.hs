-- Zadanie 2
{-# LANGUAGE KindSignatures, MultiParamTypeClasses,
  FlexibleInstances #-}

import Data.Bool (bool)
import Data.List (unfoldr)

(><) :: (a -> b) -> (a -> c) -> a -> (b, c)
(f >< g) x = (f x, g x)

warbler :: (a -> a -> b) -> a -> b
warbler f x = f x x

class Ord a =>
      Prioq (t :: * -> *) (a :: *)
  where
  empty :: t a
  isEmpty :: t a -> Bool
  single :: a -> t a
  insert :: a -> t a -> t a
  merge :: t a -> t a -> t a
  extractMin :: t a -> (a, t a)
  findMin :: t a -> a
  deleteMin :: t a -> t a
  fromList :: [a] -> t a
  toList :: t a -> [a]
  insert = merge . single
  single = flip insert empty
  extractMin = findMin >< deleteMin
  findMin = fst . extractMin
  deleteMin = snd . extractMin
  fromList = foldr insert empty
  toList = unfoldr . warbler $ bool (Just . extractMin) (const Nothing) . isEmpty

newtype ListPrioq a = LP
  { unLP :: [a]
  } deriving (Show)

instance Ord a => Prioq ListPrioq a where
  empty = LP []

  isEmpty (LP xs) = null xs

  insert elem (LP xs) = LP (ins elem xs)
    where
      ins elem [] = [elem]
      ins elem (x:xs) =
        if elem > x
          then x : ins elem xs
          else elem : (x : xs)

  extractMin (LP (x:xs)) = (x, LP xs)
  extractMin empty = error "extractMin"

  merge (LP xs) (LP ys) = LP (merge' xs ys)
    where
      merge' xs [] = xs
      merge' [] ys = ys
      merge' (x:xs) (y:ys)
        | x < y     = x : merge' xs (y : ys)
        | x > y     = y : merge' (x : xs) ys
        | otherwise = x : merge' xs ys
