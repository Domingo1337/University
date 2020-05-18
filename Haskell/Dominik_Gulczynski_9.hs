-- Dominik Gulczyński
-- Kurs Języka Haskell
-- 19.05.2020
-- Lista 9

{-# LANGUAGE TupleSections      #-}

import           Data.Foldable           hiding ( find )
import           Control.Parallel               ( par )
import           Control.Monad.ST
import           Data.Array.ST
import           Data.Function                  ( on )
import           Data.Array
import           Control.Monad                  ( when )
import           Data.List                      ( sortBy )

nthPrime :: Int -> Int
nthPrime x = startFrom 2 x
 where
  isPrime n = all (\k -> n `mod` k /= 0) $ takeWhile (\k -> k * k <= n) small
  small = 2 : [ n | n <- [3, 5 ..], isPrime n ]
  startFrom n 0 | isPrime n = n
                | otherwise = startFrom (n + 1) 0
  startFrom n k = startFrom (n + 1) $ if isPrime n then k - 1 else k

-- Zadanie 2 -------------------------------------------------------------------
bucketSort :: [(Int, a)] -> [(Int, a)]
bucketSort xs = runST $ do
  arr <- create xs
  forM_ xs $ \(i, x) -> do
    ys <- readArray arr i
    writeArray arr i (x : ys)

  lst <- getAssocs arr
  return $ concatMap (\(i, ys) -> map (i, ) ys) lst
 where
  create :: [(Int, a)] -> ST s (STArray s Int [a])
  create xs = newArray (minimum fxs, maximum fxs) [] where fxs = map fst xs


-- Zadanie 3 -------------------------------------------------------------------

-- Struktura Union-Find oparta o tablicę
type UnionFind s i = STArray s i i

createUF :: Enum i => Ix i => (i, i) -> ST s (UnionFind s i)
createUF (imin, imax) = newListArray (imin, imax) [imin .. imax]

find :: Ix i => UnionFind s i -> i -> ST s i
find arr v = do
  v' <- readArray arr v
  v' <- readArray arr v
  if v == v'
    then return v'
    else do
      v' <- find arr v'
      writeArray arr v v'
      return v'

union :: Ix i => UnionFind s i -> i -> i -> ST s ()
union arr v u = do
  v' <- find arr v
  u' <- find arr u
  writeArray arr v' u'


-- Graf jako tablica indeksowana wierzchołkami, przechowuje listy (sąsiad, waga krawędzi)
type Graph = Array Vertex [(Vertex, Weight)]
type STGraph s = STArray s Vertex [(Vertex, Weight)]
type Weight = Int
type Vertex = Int

toEdges :: Graph -> [(Vertex, Vertex, Weight)]
toEdges graph =
  sortBy (compare `on` trd)
    $ concatMap (\(v, vs) -> map (\(v', w) -> (v, v', w)) vs)
    $ assocs graph
  where trd (_, _, x) = x

addEdge :: STGraph s -> (Vertex, Vertex, Weight) -> ST s ()
addEdge arr (v, u, w) = do
  vedges <- readArray arr v
  writeArray arr v $ (u, w) : vedges
  uedges <- readArray arr u
  writeArray arr u $ (v, w) : uedges
  return ()

createSTGraph :: (Vertex, Vertex) -> ST s (STGraph s)
createSTGraph bounds = newArray bounds []

minimalSpanningTree :: Graph -> Graph
minimalSpanningTree graph = runSTArray $ do
  uf       <- createUF (bounds graph)
  newgraph <- createSTGraph (bounds graph)

  forM_ (toEdges graph) $ \edge@(v, u, w) -> do
    v' <- find uf v
    u' <- find uf u
    when (u' /= v') $ do
      union uf u' v'
      addEdge newgraph edge

  return newgraph

createGraph :: (Vertex, Vertex) -> [(Vertex, Vertex, Weight)] -> Graph
createGraph bounds edges = runSTArray $ do
  graph <- newArray bounds []
  forM_ edges (addEdge graph)
  return graph

g = createGraph
  (0, 6)
  [ (0, 2, 1)
  , (0, 1, 5)
  , (2, 3, 3)
  , (0, 3, 4)
  , (1, 5, 6)
  , (3, 5, 8)
  , (5, 4, 7)
  , (2, 4, 2)
  , (4, 6, 9)
  ]
