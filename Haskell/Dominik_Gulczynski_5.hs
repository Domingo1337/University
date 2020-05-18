{-|
Module      : Lista_5
Copyright   : Dominik Gulczyński

Kurs Języka Haskell
10.04.2020
-}

{-# LANGUAGE ViewPatterns #-}

module Lista_5 where

import           Control.Applicative
import           Control.Monad

  -- Zadanie 2 -------------------------------------------------------------------
subseqM :: MonadPlus m => [a] -> m [a]
subseqM []       = return []
subseqM (x : xs) = do
  ys <- subseqM xs
  return (x : ys) `mplus` return ys

ipermM :: MonadPlus m => [a] -> m [a]
ipermM []       = return []
ipermM (x : xs) = ipermM xs >>= insert x
 where
  insert x []           = return [x]
  insert x ys@(y : ys') = return (x : ys) `mplus` ((y :) <$> insert x ys')

spermM :: MonadPlus m => [a] -> m [a]
spermM [] = return []
spermM xs = do
  (y, ys) <- select xs
  ys'     <- spermM ys
  return (y : ys')
 where
  select [x     ] = return (x, [])
  select (x : xs) = return (x, xs) `mplus` do
    (y, ys) <- select xs
    return (y, x : ys)

-- ipermM (x:xs) = 

-- Zadanie 6 -------------------------------------------------------------------
data List t a = Cons a (t a) | Nil deriving Show

newtype SimpleList a = SimpleList { fromSimpleList :: List SimpleList a }

class ListView t where
  viewList :: t a -> List t a
  toList :: t a -> [a]
  toList (viewList -> Cons x xs) = x : toList xs
  toList (viewList -> Nil) = []
  cons :: a -> t a -> t a
  nil :: t a

data CList a = CList a :++: CList a | CSingle a | CNil deriving Show

instance ListView CList where
  viewList xs = case pop xs of
    Nothing       -> Nil
    Just (x, xs') -> Cons x xs'
   where
    pop CNil         = Nothing
    pop (CSingle x ) = Just (x, CNil)
    pop (xs :++: ys) = case pop xs of
      Nothing      -> pop ys
      Just (x, xs) -> Just (x, xs :++: ys)

  toList CNil         = []
  toList (CSingle x ) = [x]
  toList (xs :++: ys) = toList xs ++ toList ys

  cons x xs = CSingle x :++: xs

  nil = CNil

instance Functor CList where
  fmap _ CNil         = CNil
  fmap f (CSingle x ) = CSingle (f x)
  fmap f (xs :++: ys) = fmap f xs :++: fmap f ys

instance Applicative CList where
  pure = CSingle

  (<*>) CNil          _  = CNil
  (<*>) (CSingle f  ) xs = fmap f xs
  (<*>) (fs :++: fs') xs = (fs <*> xs) :++: (fs' <*> xs)

instance Monad CList where
  (>>=) CNil         _ = CNil
  (>>=) (CSingle x ) f = f x
  (>>=) (xs :++: ys) f = (xs >>= f) :++: (ys >>= f)


instance Alternative CList where
  (<|>) = mplus
  empty = mzero

instance MonadPlus CList where
  mzero = CNil
  mplus = (:++:)

instance Foldable CList where
  foldr _ acc CNil         = acc
  foldr f acc (CSingle x ) = f x acc
  foldr f acc (xs :++: ys) = foldr f (foldr f acc ys) xs

instance Traversable CList where
  traverse _ CNil         = pure CNil
  traverse f (CSingle x ) = fmap CSingle (f x)
  traverse f (xs :++: ys) = (:++:) <$> traverse f xs <*> traverse f ys


-- Zadanie 7 -------------------------------------------------------------------
newtype DList a = DList { fromDList :: [a] -> [a] }

dappend :: DList a -> DList a -> DList a
dappend (DList xs) (DList ys) = DList $ xs . ys

instance ListView DList where
  nil = DList id
  cons x (DList xs) = DList (\t -> x : xs t)

  viewList (DList xs) = case xs [] of
    []      -> Nil
    (x : _) -> Cons x (DList (tail . xs))

  toList (DList xs) = xs []

instance Functor DList where
  fmap f (DList xs) = DList (\t -> fmap f (xs []) ++ t)

instance Applicative DList where
  pure x = DList (\t -> x : t)

  (<*>) (DList fs) (DList xs) = DList (\t -> (fs [] <*> xs []) ++ t)

instance Monad DList where
  (>>=) (viewList -> Nil      ) f = nil
  (>>=) (viewList -> Cons x xs) f = dappend (f x) (xs >>= f)

instance Alternative DList where
  (<|>) = mplus
  empty = mzero

instance MonadPlus DList where
  mzero = nil
  mplus = dappend

instance Foldable DList where
  foldr f y (DList xs) = foldr f y $ xs []

instance Traversable DList where
  traverse f (DList xs) = fmap (DList . (++)) (traverse f (xs []))
