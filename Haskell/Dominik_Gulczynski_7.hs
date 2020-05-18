-- Dominik Gulczyński
-- Kurs Języka Haskell
-- 24.04.2020
-- Lista 7

{-# LANGUAGE GADTs      #-}
{-# LANGUAGE Rank2Types #-}

import           Prelude                 hiding ( succ
                                                , pred
                                                )

-- Zadanie 3 -------------------------------------------------------------------
data Expr a
    where
        C ::a -> Expr a
        P ::(Expr a, Expr b) -> Expr (a,b)
        Not ::Expr Bool -> Expr Bool
        (:+), (:-), (:*) ::Expr Integer -> Expr Integer -> Expr Integer
        (:/) ::Expr Integer -> Expr Integer -> Expr (Integer,Integer)
        (:<), (:>), (:<=), (:>=), (:!=), (:==)
            ::Expr Integer -> Expr Integer -> Expr Bool
        (:&&), (:||) ::Expr Bool -> Expr Bool -> Expr Bool
        (:?) ::Expr Bool -> Expr a -> Expr a -> Expr a
        Fst ::Expr (a,b) -> Expr a
        Snd ::Expr (a,b) -> Expr b

infixl 6 :*, :/
infixl 5 :+, :-
infixl 4 :<, :>, :<=, :>=, :!=, :==
infixl 3 :&&
infixl 2 :||
infixl 1 :?

eval :: Expr a -> a
eval (C   c        ) = c
eval (P   (e1, e2) ) = (eval e1, eval e2)
eval (Not e        ) = not (eval e)
eval (e1 :+  e2    ) = eval e1 + eval e2
eval (e1 :-  e2    ) = eval e1 - eval e2
eval (e1 :*  e2    ) = eval e1 * eval e2
eval (e1 :/  e2    ) = eval e1 `divMod` eval e2
eval (e1 :<  e2    ) = eval e1 < eval e2
eval (e1 :>  e2    ) = eval e1 > eval e2
eval (e1 :<= e2    ) = eval e1 <= eval e2
eval (e1 :>= e2    ) = eval e1 >= eval e2
eval (e1 :!= e2    ) = eval e1 /= eval e2
eval (e1 :== e2    ) = eval e1 == eval e2
eval (e1 :&& e2    ) = eval e1 && eval e2
eval (e1 :|| e2    ) = eval e1 || eval e2
eval ((:?) e1 e2 e3) = if eval e1 then eval e2 else eval e3
eval (Fst e        ) = fst $ eval e
eval (Snd e        ) = snd $ eval e

-- Zadanie 6 -------------------------------------------------------------------
newtype Church = Church (forall a. (a -> a) -> (a -> a))

zero :: Church
zero = Church $ \f x -> x
one :: Church
one = Church $ \f x -> f x
two :: Church
two = Church $ \f x -> f (f x)
succ :: Church -> Church
succ (Church n) = Church $ \f -> f . n f
add :: Church -> Church -> Church
add (Church n) (Church m) = Church $ \f -> n f . m f
mul :: Church -> Church -> Church
mul (Church n) (Church m) = Church $ n . m
exp :: Church -> Church -> Church
exp (Church n) (Church m) = Church $ m n

pred :: Church -> Church
pred (Church n) = snd $ n (\(p, _) -> (succ p, p)) (zero, zero)

isZero :: Church -> Bool
isZero (Church n) = n (const False) True

fromChurch :: Church -> Integer
fromChurch (Church n) = n (1 +) 0

instance Eq Church where
    (==) c1 c2 = c1 <= c2 && c1 >= c2

instance Ord Church where
    (<=) c1 c2 = isZero $ c1 - c2
    (>=) = flip (<=)

instance Num Church where
    (+) = add
    (-) n (Church m) = m pred n
    (*) = mul
    abs = id
    signum (Church n) = n (const one) zero
    fromInteger 0 = zero
    fromInteger n = succ $ fromInteger (n - 1)

instance Show Church where
    show = show . fromChurch

-- Zadanie 7 -------------------------------------------------------------------
class List t  where
    empty :: t x
    cons :: x -> t x -> t x
    append :: t x -> t x -> t x
    fromList :: [x] -> t x
    fromList = foldr cons empty
    toList :: t x -> [x]

newtype CList x = CList (forall a. (x -> a -> a) -> a -> a)

instance List CList where
    empty = CList (\_ xs -> xs)

    cons x (CList xs) = CList (\f a -> f x (xs f a))

    append (CList xs) ys = xs cons ys

    toList (CList xs) = xs (:) []

-- Zadanie 8 -------------------------------------------------------------------
newtype MList x = MList (forall m. Monoid m => (x -> m) -> m)

instance List MList where
    empty = MList (const mempty)

    cons x (MList xs) = MList (\f -> f x <> xs f)

    append (MList xs) (MList ys) = MList (\f -> xs f <> ys f)

    toList (MList xs) = xs (: [])
