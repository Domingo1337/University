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

anaExpr :: (c -> Either b (Either a (c,c))) -> c -> Expr a b
anaExpr f x =
    case f x of
        Left b -> Number b
        Right (Left a) -> Var a
        Right (Right (c, c')) -> Plus (anaExpr f c) (anaExpr f c')
