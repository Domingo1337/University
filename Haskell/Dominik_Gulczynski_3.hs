-- Dominik Gulczyński
-- Kurs Języka Haskell
-- 27.03.2020
-- Lista 3

{-# LANGUAGE FlexibleInstances, IncoherentInstances, UndecidableInstances, ViewPatterns #-}

data BTree t a
  = Node (t a) a (t a)
  | Leaf

class BT t where
  toTree :: t a -> BTree t a

data UTree a
  = UNode (UTree a) a (UTree a)
  | ULeaf

-- Zadanie 1 -------------------------------------------------------------------
treeSize :: BT t => t a -> Int
treeSize (toTree -> Leaf      ) = 1
treeSize (toTree -> Node l _ r) = treeSize l + 1 + treeSize r

treeLabels :: BT t => t a -> [a]
treeLabels = flip aux []
 where
  aux (toTree -> Leaf      ) acc = []
  aux (toTree -> Node l x r) acc = aux l (x : aux r acc)

treeFold :: BT t => (b -> a -> b -> b) -> b -> t a -> b
treeFold _ e (toTree -> Leaf      ) = e
treeFold n e (toTree -> Node l x r) = n (treeFold n e l) x (treeFold n e r)

instance BT UTree where
  toTree ULeaf         = Leaf
  toTree (UNode l x r) = Node l x r

newtype Unbalanced a = Unbalanced { fromUnbalanced :: BTree Unbalanced a}

instance BT Unbalanced where
  toTree = fromUnbalanced

-- Zadanie 2 -------------------------------------------------------------------
searchBT :: (Ord a, BT t) => a -> t a -> Maybe a
searchBT _ (toTree -> Leaf) = Nothing
searchBT s (toTree -> Node l x r) | s < x     = searchBT s l
                                  | s == x    = Just x
                                  | otherwise = searchBT s r

toUTree :: BT t => t a -> UTree a
toUTree (toTree -> Leaf      ) = ULeaf
toUTree (toTree -> Node l x r) = UNode (toUTree l) x (toUTree r)

toUnbalanced :: BT t => t a -> Unbalanced a
toUnbalanced (toTree -> Leaf) = Unbalanced Leaf
toUnbalanced (toTree -> Node l x r) =
  Unbalanced $ Node (toUnbalanced l) x (toUnbalanced r)

-- Zadanie 3 -------------------------------------------------------------------
instance (BT t, Show a) => Show (t a) where
  show (toTree -> Leaf      ) = "─"
  show (toTree -> Node l x r) = aux l ++ " " ++ show x ++ " " ++ aux r
   where
    aux (toTree -> Node l x r) =
      "(" ++ aux l ++ " " ++ show x ++ " " ++ aux r ++ ")"
    aux leaf = show leaf

-- Zadanie 4 -------------------------------------------------------------------
treeBoxDrawing :: (BT t, Show a) => t a -> String
treeBoxDrawing (toTree -> Leaf) = "─"
treeBoxDrawing t                = concat $ aux " " "─" " " t
 where
  aux _ _ _ (toTree -> Leaf) = []
  aux prel prem prer (toTree -> Node l x r) =
    (map (prer ++) $ aux "│" "┌" " " r)
      ++ [prem ++ show x ++ "\n"]
      ++ (map (prel ++) $ aux " " "└" "│" l)

-- Zadanie 6 -------------------------------------------------------------------
class BT t =>
      BST t
  where
  node :: t a -> a -> t a -> t a
  leaf :: t a

instance BST UTree where
  node = UNode
  leaf = ULeaf

instance BST Unbalanced where
  node l x r = Unbalanced $ Node l x r
  leaf = Unbalanced Leaf

class Set s where
  empty :: s a
  search :: Ord a => a -> s a -> Maybe a
  insert :: Ord a => a -> s a -> s a
  delMax :: Ord a => s a -> Maybe (a, s a)
  delete :: Ord a => a -> s a -> s a

instance BST s => Set s where
  empty  = leaf

  search = searchBT

  insert e (toTree -> Leaf) = node leaf e leaf
  insert e t@(toTree -> Node l x r) | x < e     = node (insert e l) x r
                                    | x == e    = t
                                    | otherwise = node l x (insert e r)

  delMax (toTree -> Leaf      ) = Nothing
  delMax (toTree -> Node l x r) = case delMax r of
    Nothing      -> Just (x, l)
    Just (d, r') -> Just (d, node l x r')

  delete e t@(toTree -> Leaf) = t
  delete e (toTree -> Node l x r)
    | e < x = node (delete e l) x r
    | e == x = case delMax l of
      Nothing       -> r
      Just (x', l') -> node l' x' r
    | otherwise = node l x (delete e r)

-- Zadanie 7 -------------------------------------------------------------------
data WBTree a
  = WBNode (WBTree a) a Int (WBTree a)
  | WBLeaf

wbsize :: WBTree a -> Int
wbsize (WBNode _ _ n _) = n
wbsize WBLeaf           = 0

instance BT WBTree where
  toTree WBLeaf           = Leaf
  toTree (WBNode l x n r) = Node l x r

instance BST WBTree where
  leaf = WBLeaf
  node l x r = balance l x r
   where
    ln    = wbsize l
    rn    = wbsize r
    omega = 5
    node' l x r = WBNode l x (wbsize l + 1 + wbsize r) r
    balance l x r | ln + rn <= 1    = node' l x r
                  | rn > omega * ln = rotL l x r
                  | ln > omega * rn = rotR l x r
                  | otherwise       = node' l x r
     where
      rotL l x (toTree -> Node rl rx rr)
        | wbsize rl < wbsize rr = node' (node' l x rl) rx rr
        | otherwise = case toTree rl of
          Node rll rlx rlr -> node' (node' l x rll) rlx (node' rlr rx rr)

      rotR (toTree -> Node ll lx lr) x r
        | wbsize lr < wbsize ll = node' ll lx (node' lr x r)
        | otherwise = case toTree lr of
          Node lrl lrx lrr -> node' (node' ll lx lrl) lrx (node' lrr x r)

-- Zadanie 8 -------------------------------------------------------------------
data HBTree a = HBNode (HBTree a) a Int (HBTree a) | HBLeaf

hbheight :: HBTree a -> Int
hbheight (HBNode _ _ h _) = h
hbheight HBLeaf           = 0

instance BT HBTree where
  toTree HBLeaf           = Leaf
  toTree (HBNode l x h r) = Node l x r

instance BST HBTree where
  leaf = HBLeaf
  node l x r = balance l x r
   where
    lh    = hbheight l
    rh    = hbheight r
    delta = 1
    node' l x r = HBNode l x (succ $ max (hbheight l) (hbheight r)) r
    balance l x r | abs (lh - rh) <= delta = node' l x r
                  | rh > lh                = rotL l x r
                  | otherwise              = rotR l x r
     where
      rotL l x (toTree -> Node rl rx rr)
        | hbheight rl < hbheight rr = node' (node' l x rl) rx rr
        | otherwise = case toTree rl of
          Node rll rlx rlr -> node' (node' l x rll) rlx (node' rlr rx rr)

      rotR (toTree -> Node ll lx lr) x r
        | hbheight lr < hbheight ll = node' ll lx (node' lr x r)
        | otherwise = case toTree lr of
          Node lrl lrx lrr -> node' (node' ll lx lrl) lrx (node' lrr x r)
