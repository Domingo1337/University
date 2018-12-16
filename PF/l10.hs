data BTree a
  = Leaf
  | Node (BTree a)
         a
         (BTree a)

instance (Show a) => Show (BTree a) where
  show Leaf = "()"
  show (Node l v r) = "(" ++ show l ++ "/" ++ show v ++ "\\" ++ show r ++ ")"

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

{-
dfnum mozna napisac w ten sam sposob, ale trywialna implementacja jest szybsza i nie wymaga Ord a
dfnum tree = num tree (dfs tree [])
  where
    dfs Leaf vs = vs
    dfs (Node l v r) vs = v : dfs l (dfs r vs)
-}

abc = Node (Node Leaf 'a' Leaf) 'b' (Node Leaf 'c' Leaf)

abcdef =
  Node (Node (Node Leaf 'a' Leaf) 'b' (Node Leaf 'c' Leaf)) 'd' (Node (Node Leaf 'e' Leaf) 'f' (Node Leaf 'g' Leaf))
