-- Zadanie 3
{-# LANGUAGE Rank2Types #-}

omega :: (forall a. a) -> b
omega f = f f

newtype Church =
  Church (forall a. (a -> a) -> (a -> a))
  
zero :: Church
zero = Church (\f x -> x)

isZero :: Church -> Bool
isZero (Church c) = c (const False) True

instance Show Church where
  show (Church c) = show (c succ 0)

instance Eq Church where
  c == c' = c <= c' && c' <= c

instance Ord Church where
  c <= c' = isZero (c - c')

instance Enum Church where
  succ (Church c) = Church (\f x -> f (c f x))

  pred (Church c) = snd (c (\(x, y) -> (succ x, x)) (zero, zero))

  fromEnum (Church c) = c succ 0

  toEnum = (iterate succ zero !!)

instance Num Church where
  abs = id

  signum c = 1

  fromInteger n
    | n == 0 = zero
    | otherwise = succ (fromInteger (pred n))

  (Church c) + (Church c') = Church (\f x -> c f (c' f x))

  (Church c) * (Church c') = Church (c . c')

  c - c'
    | isZero c = zero
    | isZero c' = c
    | otherwise = pred c - pred c'
