data BTree a
  = Leaf
  | Node (BTree a)
         a
         (BTree a) deriving (Show)

--  Zadanie 1
dfnum :: BTree a -> BTree Integer
dfnum tree = fst (aux tree 0)
  where
    aux :: BTree a -> Integer -> (BTree Integer, Integer)
    aux Leaf n = (Leaf, n)
    aux (Node l v r) n =
      let (left, ln) = aux l (n + 1)
       in let (right, rn) = aux r ln
           in (Node left (n + 1) right, rn)

bfnum :: Ord a => BTree a -> BTree Integer
bfnum tree = num tree (reverse (bfs [tree] []))
  where
    bfs :: [BTree a] -> [a] -> [a]
    bfs [] vs = vs
    bfs (Leaf:ts) vs = bfs ts vs
    bfs (Node l v r:ts) vs = bfs (ts ++ [l, r]) (v : vs)
    num :: Ord a => BTree a -> [a] -> BTree Integer
    num Leaf _ = Leaf
    num (Node l v r) xs = Node (num l xs) (1 + indexOf v xs) (num r xs)
    indexOf :: Ord a => a -> [a] -> Integer
    indexOf _ [] = -1
    indexOf x ys = aux 0 ys
      where
        aux n [] = -1
        aux n (y:ys) =
          if x == y
            then n
            else aux (n + 1) ys

-- Zadanie 2
data Array a =
  Array (BTree a)
        Integer

instance (Show a) => Show (Array a) where
  show (Array tree size) = "Array[" ++ show size ++ "]:" ++ show tree

aEmpty :: Array a
aEmpty = Array Leaf 0

aSub :: Array a -> Integer -> a
aSub (Array tree size) i =
  if i >= size
    then error "aSub index out of bonds"
    else find tree i
  where
    find (Node l v r) 1 = v
    find (Node l _ r) i =
      if i `mod` 2 == 0
        then find l (i `div` 2)
        else find r (i `div` 2)

aUpdate :: Array a -> Integer -> a -> Array a
aUpdate (Array tree size) i x =
  if i >= size
    then error "aUpdate index out of bonds"
    else Array (set tree i) size
  where
    set (Node l v r) 1 = Node l x r
    set (Node l v r) i =
      if i `mod` 2 == 0
        then Node (set l (i `div` 2)) v r
        else Node l v (set r (i `div` 2))

ahiext :: Array a -> a -> Array a
ahiext (Array tree size) x = Array (ext tree (size + 1)) (size + 1)
  where
    ext Leaf 1 = Node Leaf x Leaf
    ext (Node l v r) i =
      if i `mod` 2 == 0
        then Node (ext l (i `div` 2)) v r
        else Node l v (ext r (i `div` 2))

ahirem :: Array a -> Array a
ahirem (Array _ 0) = error "ahirem of 0-length array"
ahirem (Array tree size) = Array (remove tree size) (size - 1)
  where
    remove :: BTree a -> Integer -> BTree a
    remove (Node l v r) 1 = Leaf
    remove (Node l v r) i =
      if i `mod` 2 == 0
        then Node (remove l (i `div` 2)) v r
        else Node l v (remove r (i `div` 2))

-- Zadanie 3
lit :: String -> (String -> a) -> (String -> a)
lit s cont s' = cont (s' ++ s)

eol :: (String -> a) -> (String -> a)
eol cont s = cont (s ++ "\n")

int :: (String -> a) -> (String -> (Integer -> a))
int cont s i = cont (s ++ show i)

flt :: (String -> a) -> (String -> (Float -> a))
flt cont s f = cont (s ++ show f)

str :: (String -> a) -> (String -> (String -> a))
str cont s s' = cont (s ++ s')

(^^^) = (.)

sprintf dir = dir id ""

printf dir = dir putStr ""

-- Zadanie 4
data Color
  = Red
  | Black deriving (Show)

data RBTree a
  = RBNode Color
           (RBTree a)
           a
           (RBTree a)
  | RBLeaf deriving (Show)

rbnode :: Color -> RBTree a -> a -> RBTree a -> RBTree a
rbnode c l v r = RBNode Black l' v' r'
    where (RBNode _ l' v' r', res) = fix (RBNode c l v r)
          fix (RBNode Black (RBNode Red (RBNode Red a x b) y c) z d) = (RBNode Red (RBNode Black a x b) y (RBNode Black c z d), True)
          fix (RBNode Black (RBNode Red a x (RBNode Red b y c)) z d) = (RBNode Red (RBNode Black a x b) y (RBNode Black c z d), True)
          fix (RBNode Black a x (RBNode Red b y (RBNode Red c z d))) = (RBNode Red (RBNode Black a x b) y (RBNode Black c z d), True)
          fix (RBNode Black a x (RBNode Red (RBNode Red b y c) z d)) = (RBNode Red (RBNode Black a x b) y (RBNode Black c z d), True)
          fix RBLeaf = (RBLeaf, False)
          fix (RBNode c l v r) = if bl || br then fix (RBNode c fl v fr) else (RBNode c l v r, False)
            where (fl, bl) = fix l
                  (fr, br) = fix r

rbinsert :: Ord a => a -> RBTree a -> RBTree a
rbinsert x RBLeaf = RBNode Black RBLeaf x RBLeaf
rbinsert x (RBNode c l v r)
    | x == v = rbnode c l v r
    | x < v  = rbnode c (redinsert x l) v r 
    | otherwise = rbnode c l v (redinsert x r)
    where redinsert x RBLeaf = RBNode Red RBLeaf x RBLeaf
          redinsert x (RBNode c l v r)
            | x == v = RBNode c l v r
            | x < v  = RBNode c (redinsert x l) v r
            | otherwise = RBNode c l v (redinsert x r)

rbtreeFromList :: [a] -> RBTree a
rbtreeFromList [] = RBLeaf
rbtreeFromList [x] = RBNode Black RBLeaf x RBLeaf
rbtreeFromList xs = rbnode Black (build xh) x (build xt)
    where (xh, x:xt) = split xs
          split xs = splitAt (length xs `div` 2) xs   
          build [] = RBLeaf
          build [y] = RBNode Red RBLeaf y RBLeaf
          build ys = RBNode Black (build yh) y (build yt)
            where (yh, y:yt) = split ys
