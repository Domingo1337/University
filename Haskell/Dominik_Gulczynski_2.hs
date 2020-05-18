-- Dominik Gulczyński
-- Kurs Języka Haskell
-- 20.02.2020
-- Lista 2

{-# LANGUAGE ParallelListComp #-}

-- Zadanie 1 -------------------------------------------------------------------
subseqC :: [a] -> [[a]]
subseqC []       = [[]]
subseqC (x : xs) = [ x : ys | ys <- yss ] ++ yss where yss = subseqC xs

ipermC :: [a] -> [[a]]
ipermC []       = [[]]
ipermC (x : xs) = concat [ insert ys | ys <- ipermC xs ]
 where
  insert []           = [[x]]
  insert ys'@(y : ys) = (x : ys') : [ y : zs | zs <- insert ys ]

spermC :: [a] -> [[a]]
spermC [] = [[]]
spermC xs = concat [ [ y : z | z <- spermC ys ] | (y, ys) <- select xs ]
 where
  select [y     ] = [(y, [])]
  select (y : ys) = (y, ys) : [ (z, y : zs) | (z, zs) <- select ys ]

qsortC :: Ord a => [a] -> [a]
qsortC [] = []
qsortC (x : xs) =
  qsortC [ y | y <- xs, y < x ] ++ [x] ++ qsortC [ y | y <- xs, y >= x ]

zipC :: [a] -> [b] -> [(a, b)]
zipC as bs = [ (a, b) | a <- as | b <- bs ]

-- Zadanie 3 -------------------------------------------------------------------
data Combinator
  = S
  | K
  | Combinator :$ Combinator

infixl :$

instance Show Combinator where
  show K         = "K"
  show S         = "S"
  show (c :$ K ) = show c ++ "K"
  show (c :$ S ) = show c ++ "S"
  show (c :$ c') = show c ++ "(" ++ show c' ++ ")"

-- Zadanie 4 -------------------------------------------------------------------
evalC :: Combinator -> Combinator
evalC (K      :$ x :$ _) = evalC x
evalC (S :$ x :$ y :$ z) = evalC (x :$ z :$ (y :$ z))
evalC c                  = c

-- Zadanie 5 -------------------------------------------------------------------
data BST a
  = NodeBST (BST a) a (BST a)
  | EmptyBST
  deriving Show

searchBST :: Ord a => a -> BST a -> Maybe a
searchBST _ EmptyBST = Nothing
searchBST e (NodeBST l v r)
  | e == v = Just v
  | otherwise = case searchBST e l of
    Just v  -> Just v
    Nothing -> searchBST e r

insertBST :: Ord a => a -> BST a -> BST a
insertBST e EmptyBST = NodeBST EmptyBST e EmptyBST
insertBST e t@(NodeBST l v r) | e == v    = t
                              | e < v     = NodeBST (insertBST e l) v r
                              | otherwise = NodeBST l v (insertBST e r)

-- Zadanie 6 -------------------------------------------------------------------
deleteMaxBST :: Ord a => BST a -> (BST a, a)
deleteMaxBST EmptyBST               = error "deleteMaxBST on empty tree"
deleteMaxBST (NodeBST l v EmptyBST) = (l, v)
deleteMaxBST (NodeBST l v r       ) = (NodeBST l v r', rmax)
  where (r', rmax) = deleteMaxBST r

deleteBST :: Ord a => a -> BST a -> BST a
deleteBST _ EmptyBST = EmptyBST
deleteBST e (NodeBST l v r)
  | e < v = NodeBST (deleteBST e l) v r
  | e > v = NodeBST l v (deleteBST e r)
  | otherwise = case l of
    EmptyBST -> r
    _        -> let (l', v') = deleteMaxBST l in NodeBST l' v' r

-- Zadanie 7 -------------------------------------------------------------------
data Tree23 a = Node2 (Tree23 a) a (Tree23 a)
    | Node3 (Tree23 a) a (Tree23 a) a (Tree23 a)
    | Empty23

search23 :: Ord a => a -> Tree23 a -> Maybe a
search23 _ Empty23 = Nothing
search23 e (Node2 l v r) | e < v     = search23 e l
                         | e == v    = Just v
                         | otherwise = search23 e r
search23 e (Node3 l v m u r) | e < v     = search23 e l
                             | e == v    = Just v
                             | e < u     = search23 e m
                             | e == u    = Just u
                             | otherwise = search23 e r

-- Zadanie 8 -------------------------------------------------------------------
data InsResult a = BalancedIns (Tree23 a) | Grown (Tree23 a) a (Tree23 a)

insert23 :: Ord a => a -> Tree23 a -> Tree23 a
insert23 e t = case ins e t of
  BalancedIns t -> t
  Grown l v r   -> Node2 l v r

ins :: Ord a => a -> Tree23 a -> InsResult a
ins e Empty23 = Grown Empty23 e Empty23
ins e t@(Node2 l v r)
  | e < v = case ins e l of
    BalancedIns l' -> BalancedIns $ Node2 l' v r
    Grown l' v' r' -> BalancedIns $ Node3 l' v' r' v r
  | e > v = case ins e r of
    BalancedIns r' -> BalancedIns $ Node2 l v r'
    Grown l' v' r' -> BalancedIns $ Node3 l v l' v' r'
  | otherwise = BalancedIns t
ins e t@(Node3 l v m u r)
  | e < v = case ins e l of
    BalancedIns l' -> BalancedIns $ Node3 l' v m u r
    Grown l' v' r' -> Grown (Node2 l' v' r') v (Node2 m u r)
  | e == v = BalancedIns t
  | e < u = case ins e m of
    BalancedIns m' -> BalancedIns $ Node3 l v m' u r
    Grown l' v' r' -> Grown (Node2 l v l') v' (Node2 r' u r)
  | e == u = BalancedIns t
  | otherwise = case ins e r of
    BalancedIns r' -> BalancedIns $ Node3 l v m u r'
    Grown l' v' r' -> Grown (Node2 l v r) u (Node2 l' v' r')
