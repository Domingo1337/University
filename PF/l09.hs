-- Zadanie 1
f :: [Integer] -> [Integer]
f [] = []
f (x:xs) = [y | y <- xs, y `mod` x /= 0]

primes = map head (iterate f [2 ..])

-- Zadanie 2
primes' = 2 : [x | x <- [3 ..], all (\y -> x `mod` y /= 0) (takeWhile (\y -> y * y <= x) primes')]

-- Zadanie 3
fib = 1 : 1 : zipWith (+) fib (tail fib)

-- Zadanie 4
iperm :: [a] -> [[a]]
iperm [] = [[]]
iperm (x:xs) = concatMap (insEv x) (iperm xs)
  where
    insEv :: a -> [a] -> [[a]]
    insEv x [] = [[x]]
    insEv x (y:ys) = (x : y : ys) : map (y :) (insEv x ys)

-- iperm (x:xs) = [p' | p' <- insEv x p, p <- iperm xs]
sperm :: [a] -> [[a]]
sperm [] = [[]]
sperm xs = [x : p | (x, rest) <- mixhead xs [], p <- sperm rest]
  where
    mixhead :: [a] -> [a] -> [(a, [a])]
    mixhead [] _ = []
    mixhead (x:xs) rxs = (x, reverse rxs ++ xs) : mixhead xs (x : rxs)

-- Zadanie 5
sublist :: [a] -> [[a]]
sublist [] = [[]]
sublist (x:xs) =
  let rest = sublist xs
   in map (x :) rest ++ rest

-- Zadanie 6
(><) :: [a] -> [b] -> [(a, b)]
(><) xs ys = walk xs ys []
  where
    walk :: [a] -> [b] -> [b] -> [(a, b)]
    walk [] _ _ = []
    walk (x:xs) [] rys = zip xs rys ++ walk xs [] rys
    walk xs (y:ys) rys = zip xs (y : rys) ++ walk xs ys (y : rys)

    -- Zadanie 7
data Tree a
  = Node (Tree a)
         a
         (Tree a)
  | Leaf

data Set a
  = Fin (Tree a)
  | Cofin (Tree a)

instance (Show a) => Show (Tree a) where
  show Leaf = "Leaf"
  show (Node l v r) = "(" ++ show l ++ "/" ++ show v ++ "\\" ++ show r ++ ")"

instance (Show a) => Show (Set a) where
  show (Fin f) = "Fin:" ++ show f
  show (Cofin f) = "Cofin:" ++ show f

smallestOf :: Ord a => Tree a -> a
smallestOf (Node Leaf v _) = v
smallestOf (Node l _ _) = smallestOf l

insert, delete :: Ord a => a -> Tree a -> Tree a
insert x Leaf = Node Leaf x Leaf
insert x (Node l v r)
  | x == v = Node l v r
  | x < v = Node (insert x l) v r
  | otherwise = Node l v (insert x r)

delete _ Leaf = Leaf
delete x (Node Leaf v r)
  | x == v = r
  | otherwise = Node Leaf v (delete x r)
delete x (Node l v Leaf)
  | x == v = l
  | otherwise = Node (delete x l) v Leaf
delete x (Node l v r)
  | x == v =
    let vr = smallestOf r
          where
            smallestOf (Node Leaf v _) = v
            smallestOf (Node l _ _) = smallestOf l
     in Node l vr (delete vr r)
  | x < v = Node (delete x l) v r
  | otherwise = Node l v (delete x r)

foldTree :: Ord a => (a -> b -> b) -> Tree a -> b -> b
foldTree _ Leaf acc = acc
foldTree f (Node l v r) acc = foldTree f l (f v (foldTree f r acc))

intersecTree :: Ord a => Tree a -> Tree a -> Tree a
intersecTree x y = foldTree delete (foldTree delete x y) y

findTree :: Ord a => a -> Tree a -> Bool
findTree x Leaf = False
findTree x (Node l v r)
  | x == v = True
  | x < v = findTree x l
  | otherwise = findTree x r

setFromList :: Ord a => [a] -> Set a
setFromList xs = Fin (foldr insert Leaf xs)

setEmpty, setFull :: Ord a => Set a
setEmpty = Fin Leaf

setFull = setComplement setEmpty

setUnion, setIntersection :: Ord a => Set a -> Set a -> Set a
setUnion (Fin x) (Fin y) = Fin (foldTree insert x y)
setUnion (Fin f) (Cofin c) = Cofin (foldTree delete c f)
setUnion (Cofin c) (Fin f) = Cofin (foldTree delete c f)
setUnion (Cofin x) (Cofin y) = Cofin (intersecTree x y)

setIntersection (Fin x) (Fin y) = Fin (intersecTree x y)
setIntersection (Cofin c) (Fin f) = Fin (foldTree delete f c)
setIntersection (Fin f) (Cofin c) = Fin (foldTree delete f c)
setIntersection (Cofin x) (Cofin y) = Cofin (foldTree insert x y)

setComplement :: Ord a => Set a -> Set a
setComplement (Fin x) = Cofin x
setComplement (Cofin x) = Fin x

setMember :: Ord a => a -> Set a -> Bool
setMember x (Fin f) = findTree x f
setMember x (Cofin c) = not (setMember x (Fin c))
