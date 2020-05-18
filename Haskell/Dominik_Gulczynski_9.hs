-- Dominik Gulczyński
-- Kurs Języka Haskell
-- 19.05.2020
-- Lista 9

{-# LANGUAGE DataKinds          #-}
{-# LANGUAGE GADTs              #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TupleSections      #-}
{-# LANGUAGE TypeFamilies       #-}
{-# LANGUAGE TypeOperators      #-}



import           Prelude                 hiding ( zipWith )
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
  create xs =
    newArray (minimum fxs, maximum fxs) [] :: ST s (STArray s Int [a])
    where fxs = map fst xs


-- Zadanie 3 -------------------------------------------------------------------
type Weight = Int
type Vertex = Int
type Graph = Array Vertex [(Vertex, Weight)]
type STGraph s = STArray s Vertex [(Vertex, Weight)]

createUF :: (Vertex, Vertex) -> ST s (STArray s Vertex Vertex)
createUF (vmin, vmax) = newListArray (vmin, vmax) [vmin .. vmax]

find :: STArray s Vertex Vertex -> Vertex -> ST s Vertex
find arr v = do
  v' <- readArray arr v
  v' <- readArray arr v
  if v == v'
    then return v'
    else do
      v' <- find arr v'
      writeArray arr v v'
      return v'

union :: STArray s Vertex Vertex -> Vertex -> Vertex -> ST s ()
union arr v u = do
  v' <- find arr v
  u' <- find arr u
  writeArray arr v' u'

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

minimalSpanningTree :: Graph -> Graph
minimalSpanningTree graph = runSTArray $ do
  uf       <- createUF (bounds graph)
  newgraph <- newArray (bounds graph) [] :: ST s (STGraph s)

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
