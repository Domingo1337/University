-- Dominik Gulczyński
-- Kurs Języka Haskell
-- 24.04.2020
-- Lista 8

{-# LANGUAGE GADTs              #-}
{-# LANGUAGE DataKinds          #-}
{-# LANGUAGE TypeFamilies       #-}
{-# LANGUAGE TypeOperators      #-}
{-# LANGUAGE StandaloneDeriving #-}

import           Prelude                 hiding ( zipWith )

data Nat = Zero | Succ Nat
    deriving Show

type family x + y where
    Zero   + k = k
    n + Zero = n
    Succ n + k = Succ (n + k)
    n + Succ k = Succ (n + k)

data Vec :: * -> Nat -> * where
    VNil ::Vec a Zero
    VCons ::a -> Vec a n -> Vec a (Succ n)
deriving instance Show a => Show (Vec a n)


-- Zadanie 1 -------------------------------------------------------------------
data Tree :: Nat -> * where
    Leaf ::Tree Zero
    Node ::(lsize ~ rsize) => Tree lsize -> Tree rsize -> Tree (Succ lsize)
deriving instance Show (Tree n)

-- Zadanie 2 -------------------------------------------------------------------
newtype Mtx a n m = Mtx (Vec (Vec a n) m) deriving Show

zipWith :: (a -> b -> c) -> Vec a n -> Vec b n -> Vec c n
zipWith _ VNil         VNil         = VNil
zipWith f (VCons x xs) (VCons y ys) = VCons (f x y) (zipWith f xs ys)

add :: Num a => Mtx a n m -> Mtx a n m -> Mtx a n m
add (Mtx xs) (Mtx ys) = Mtx (zipWith (zipWith (+)) xs ys)
