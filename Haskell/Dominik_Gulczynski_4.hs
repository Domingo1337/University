-- Dominik Gulczyński
-- Kurs Języka Haskell
-- 03.04.2020
-- Lista 4

data BTree a
  = BNode (BTree a) a (BTree a)
  | BLeaf
  deriving Show

-- Zadanie 1 -------------------------------------------------------------------
flatten :: BTree a -> [a]
flatten = flatten_aux [] where
  flatten_aux acc BLeaf         = acc
  flatten_aux acc (BNode l x r) = flatten_aux (x : flatten_aux acc r) l

qsort :: Ord a => [a] -> [a]
qsort = qsort_aux [] where
  qsort_aux acc [] = acc
  qsort_aux acc (x : xs) =
    qsort_aux (x : qsort_aux acc [ y | y <- xs, y >= x ]) [ y | y <- xs, y < x ]

-- Zadanie 2 -------------------------------------------------------------------
queens :: Int -> [[Int]]
queens n = queens' n
 where
  queens' 0 = [[]]
  queens' k = [ q : qs | q <- [1 .. n], qs <- qss, check q qs 1 ]
    where qss = queens' (k - 1)
  check _  []       _ = True
  check q' (q : qs) m = q' /= q && abs (q' - q) /= m && check q' qs (m + 1)

-- Zadanie 3 -------------------------------------------------------------------
binTree :: Int -> BinTree
binTree n | rest == 1 = let t = binTree q in t :/\: t
          | otherwise = let (l, r) = aux q in l :/\: r
 where
  (q, rest) = n `divMod` 2
  aux 0 = (BinTreeLeaf, BinTreeLeaf :/\: BinTreeLeaf)
  aux m | m `mod` 2 == 0 = (l :/\: r, r :/\: r)
        | otherwise      = (l :/\: l, l :/\: r)
    where (l, r) = aux ((m - 1) `div` 2)

-- Zadanie 4 -------------------------------------------------------------------
data BinTree = BinTree :/\: BinTree | BinTreeLeaf deriving Show

binTreeLeaves :: Int -> BinTree
binTreeLeaves n = aux BinTreeLeaf BinTreeLeaf (n - 1) where
  aux t acc 0 = acc
  aux t acc 1 = t :/\: acc
  aux t acc n = aux (t :/\: t) (if r == 1 then t :/\: acc else acc) q
    where (q, r) = n `divMod` 2

-- Zadanie 5 -------------------------------------------------------------------
class Queue q where
  emptyQ :: q a
  isEmptyQ :: q a -> Bool
  put :: a -> q a -> q a
  get :: q a -> (a, q a)
  get q = (top q, pop q)
  top :: q a -> a
  top = fst . get
  pop :: q a -> q a
  pop = snd . get

data SimpleQueue a = SimpleQueue { front :: [a], rear :: [a] } deriving Show

instance Queue SimpleQueue where
  emptyQ = SimpleQueue [] []

  isEmptyQ SimpleQueue { front = [] } = True
  isEmptyQ _                          = False

  put x SimpleQueue { front = [] }            = SimpleQueue [x] []
  put x SimpleQueue { front = fs, rear = rs } = SimpleQueue fs (x : rs)

  get SimpleQueue { front = [f], rear = rs } = (f, SimpleQueue (reverse rs) [])
  get SimpleQueue { front = f : fs, rear = rs } = (f, SimpleQueue fs rs)

  top SimpleQueue { front = f : fs } = f

  pop SimpleQueue { front = [f], rear = rs }    = SimpleQueue (reverse rs) []
  pop SimpleQueue { front = f : fs, rear = rs } = SimpleQueue fs rs

-- Zadanie 6 -------------------------------------------------------------------
primes :: [Integer]
primes =
  2
    : [ p
      | p <- [3 ..]
      , and
        [ p `mod` q /= 0 | q <- (takeWhile (\q -> q * q <= p) primes), q /= p ]
      ]

-- Zadanie 7 -------------------------------------------------------------------
fib :: [Integer]
fib = 1 : 1 : zipWith (+) fib (tail fib)

-- Zadanie 8 -------------------------------------------------------------------
(<+>) :: Ord a => [a] -> [a] -> [a]
[] <+> ys = ys
xs <+> [] = xs
xs@(x : xs') <+> ys@(y : ys') | x < y     = x : xs' <+> ys
                              | x == y    = x : xs' <+> ys'
                              | otherwise = y : xs <+> ys'

d235 :: [Integer]
d235 = 1 : map (2 *) d235 <+> map (3 *) d235 <+> map (5 *) d235

-- Zadanie 9 -------------------------------------------------------------------
natTree :: BTree Int
natTree = BNode (treeMap ((1 +) . (2 *)) natTree) 1 (treeMap (2 *) natTree)

treeMap :: (a -> b) -> BTree a -> BTree b
treeMap f (BNode l x r) = BNode (treeMap f l) (f x) (treeMap f r)
treeMap _ BLeaf         = BLeaf

-- Zadanie 10 ------------------------------------------------------------------
binOne :: BTree Int
binOne = BNode binOne 1 binOne

data RoseTree a = RNode a [RoseTree a]

roseOne :: RoseTree Int
roseOne = RNode 1 roses where roses = roseOne : roses

-- Zadanie 11 ------------------------------------------------------------------
showFragList :: Show a => Int -> [a] -> String
showFragList n xs = '[' : aux n xs
 where
  aux _ []       = "]"
  aux 0 _        = "…]"
  aux n [x     ] = show x ++ "]"
  aux n (x : xs) = show x ++ "," ++ aux (n - 1) xs


showFragTree :: Show a => Int -> BTree a -> String
showFragTree 0 _     = "…"
showFragTree _ BLeaf = "_"
showFragTree n (BNode l x r) =
  "(BNode "
    ++ showFragTree (n - 1) l
    ++ " "
    ++ show x
    ++ " "
    ++ showFragTree (n - 1) r
    ++ ")"

-- Próbowałem usunąć zbędne znaki, takie jak \" albo \\, ale nie udało mi się
showFragRose :: Show a => Int -> RoseTree a -> String
showFragRose 0 _               = "…"
showFragRose n (RNode x roses) = "RNode " ++ show x ++ " " ++ showFragList
  (n - 1)
  (map (showFragRose (n - 1)) roses)

-- Zadanie 12 ------------------------------------------------------------------
data Cyclist a = Elem (Cyclist a) a (Cyclist a) deriving Show

fromList :: [a] -> Cyclist a
fromList [   x      ] = cl where cl = Elem cl x cl
fromList xs@(x : xs') = cl
 where
  cl = Elem last x next where (last, next) = aux cl xs'
  aux prev [x     ] = (ys, ys) where ys = Elem prev x cl
  aux prev (x : xs) = (last, t)
   where
    t            = Elem prev x last
    (last, next) = aux t xs

forward, backward :: Cyclist a -> Cyclist a
forward (Elem _ _ next) = next
backward (Elem prev _ _) = prev

label :: Cyclist a -> a
label (Elem _ x _) = x

-- Zadanie 13 ------------------------------------------------------------------
enumInts :: Cyclist Integer
enumInts = enum 0 where enum n = Elem (enum (n - 1)) n (enum (n + 1))
