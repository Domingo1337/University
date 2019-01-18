{-# LANGUAGE KindSignatures, MultiParamTypeClasses,
FlexibleInstances, Rank2Types #-}
import Data.Bool (bool)
import Data.List (unfoldr)

-- Zadanie 1
ana :: (b -> Maybe (a, b)) -> b -> [a]
ana f st =
  case f st of
    Nothing -> []
    Just (v, st') -> v : ana f st'

zip :: [a] -> [b] -> [(a, b)]
zip xs ys = ana f (xs, ys)
  where
    f ([], _) = Nothing
    f (_, []) = Nothing
    f (x:xs, y:ys) = Just ((x, y), (xs, ys))

iterate :: (a -> a) -> a -> [a]
iterate f = ana g
  where
    g x = Just (y, y)
      where
        y = f x

map :: (a -> b) -> [a] -> [b]
map f = ana g
  where
    g [] = Nothing
    g (x:xs) = Just (f x, xs)

cata :: (a -> b -> b) -> b -> [a] -> b
cata f v [] = v
cata f v (x:xs) = f x (cata f v xs)

length :: [a] -> Int
length = cata (const succ) 0

filter :: (a -> Bool) -> [a] -> [a]
filter pred = cata f []
  where
    f x ys =
      if pred x
        then x : ys
        else ys

map' :: (a -> b) -> [a] -> [b]
map' f = cata f' []
  where
    f' x ys = f x : ys

data Expr a b
  = Number b
  | Var a
  | Plus (Expr a b)
         (Expr a b)

cataExpr :: (b -> c) -> (a -> c) -> (c -> c -> c) -> Expr a b -> c
cataExpr num var plus (Number n) = num n
cataExpr num var plus (Var v) = var v
cataExpr num var plus (Plus a b) = plus (cataExpr num var plus a) (cataExpr num var plus b)

eval env = cataExpr id env (+)

anaExpr :: (c -> Either b (Either a (c, c))) -> c -> Expr a b
anaExpr f x =
  case f x of
    Left b -> Number b
    Right (Left a) -> Var a
    Right (Right (c, c')) -> Plus (anaExpr f c) (anaExpr f c')


-- Zadanie 2
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
        | x < y = x : merge' xs (y : ys)
        | x > y = y : merge' (x : xs) ys
        | otherwise = x : merge' xs ys


-- Zadanie 3
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
  toEnum = (Prelude.iterate succ zero !!)

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


-- Zadanie 4
type Row = Int

type Board = [Row]

nim :: Board -> IO ()
nim board = do
  nimPut board
  if nimCheck board
    then putStrLn "You lost :("
    else do
      putStrLn "Your move?"
      row <- readLn :: IO Int
      amount <- readLn :: IO Int
      let b = nimMove board (row, amount)
      nimPut b
      if nimCheck b
        then putStrLn "You won :)"
        else do
          let best = nimBest b
          putStrLn ("CPU plays " ++ show best)
          nim (nimMove b best)
  where
    nimBest :: Board -> (Row, Int)
    nimBest = find 1
      where
        find _ [] = error "nimBest"
        find i (0:xs) = find (succ i) xs
        find i (x:_) = (i, x)
    nimCheck :: Board -> Bool
    nimCheck = all (0 ==)
    nimMove :: Board -> (Row, Int) -> Board
    nimMove board (row, amount) =
      case (board, row) of
        ([], _) -> error "nimMove empty"
        (r:rs, 1) ->
          if amount > r
            then error "nimMove invalid"
            else (r - amount) : rs
        (r:rs, _) -> r : nimMove rs (pred row, amount)
    nimPut :: Board -> IO ()
    nimPut board = do
      putStrLn "============="
      putLn 1 board
      where
        putLn _ [] = putStrLn "============="
        putLn i (r:rs) = do
          putStr (show i ++ ": ")
          putStrLn (unwords (replicate r "*"))
          putLn (succ i) rs
