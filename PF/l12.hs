{-# LANGUAGE FunctionalDependencies, FlexibleContexts, FlexibleInstances #-}

import Data.Char

-- Zadanie 1
class Monad m =>
      StreamTrans m i o | m -> i o where
  readS :: m (Maybe i)
  emitS :: o -> m ()

toLower' :: StreamTrans m Char Char => m Integer
toLower' = loop 0
  where
    loop n = do
      x <- readS
      case x of
        Nothing -> return n
        Just c ->
          if isUpper c
            then do
              emitS (toLower c)
              loop (succ n)
            else do
              emitS c
              loop n

-- Zadanie 2
instance StreamTrans IO Char Char where
  readS = do
    c <- getChar
    return
      (if c == '\n'
         then Nothing
         else Just c)
  emitS = putChar

newtype ListTrans i o a = LT'{ unLT' :: [i] -> ([i], [o], a)}

instance Functor (ListTrans i o) where
  fmap f (LT' g) = LT' (\i ->
    let (gi, go, ga) = g i
     in (gi, go, f ga))

instance Applicative (ListTrans i o) where
  pure a = LT' (\i -> (i, [], a))
  (LT' f) <*> (LT' g) = LT' (\i ->
    let (fi, fo, ff) = f i
     in let (gi, go, ga) = g fi
         in (gi, fo ++ go, ff ga))

instance Monad (ListTrans i o) where
  return = pure
  LT' f >>= g = LT' (\i ->
    let (fi, fo, fa) = f i
     in let (gi, go, gb) = unLT' (g fa) fi
         in (gi, fo ++ go, gb))

instance StreamTrans (ListTrans i o) i o where
  emitS o = LT' (\i -> (i, [o], ()))
  readS = LT' (\i ->
    if null i
      then ([], [], Nothing)
      else (tail i, [], Just $ head i))

transform :: ListTrans i o a -> [i] -> ([o], a)
transform (LT' f) i =
  let (_, fo, fa) = f i
   in (fo, fa)

toLower'' = transform toLower'

-- Zadanie 3
data Token
    = Number Int
    | Var String
    | Binop Char
    | Parens Char
    deriving (Show)
  
isBinop, isParens :: Char -> Bool
isBinop c = c `elem` ['+', '-', '*', '/']

isParens c = c `elem` ['(', ')']

lexer :: StreamTrans m Char Token => m ()
lexer = do
  x <- readS
  case x of
    Nothing -> return ()
    Just c -> process c
  where
    process c
      | isDigit c = readNumber c 0
      | isLetter c = readVar [c]
      | isBinop c = readBinop c
      | isParens c = readParens c
      | otherwise = lexer
    readBinop c = do
      emitS (Binop c)
      lexer
    readParens c = do
      emitS (Parens c)
      lexer
    readNumber c val = do
      x <- readS
      case x of
        Nothing -> emitS (Number val')
        Just c' ->
          if isDigit c'
            then readNumber c' val'
            else do
              emitS (Number val')
              process c'
      where
        val' = 10 * val + digitToInt c
    readVar str = do
      x <- readS
      case x of
        Nothing -> emitS (Var str)
        Just c ->
          if isAlphaNum c
            then readVar $ str ++ [c]
            else do
              emitS (Var str)
              process c

stringLexer :: String -> [Token]
stringLexer str = fst (transform lexer str)


-- Zadanie 4
class Monad m =>
      Random m where
  random :: m Int

newtype RS t = RS { unRS :: Int -> (Int, t)}

withSeed :: RS a -> Int -> a
withSeed rs i = snd $ unRS rs i

next :: Int -> Int
next i =
  let b = 16807 * (i `mod` 127773) - 2836 * (i `div` 127773)
   in if b > 0
        then b
        else b + 2147483647

instance Functor RS where
  fmap f (RS g) = RS (\i ->
    let (gi, gt) = g i
     in (gi, f gt))

instance Applicative RS where
  pure t = RS (\i -> (i, t))
  (RS f) <*> (RS g) = RS (\i ->
    let (fi, ft) = f i
     in let (gi, gt) = g fi
         in (gi, ft gt))

instance Monad RS where
  return = pure
  RS f >>= g = RS (\i ->
    let (fi, ft) = f i
     in unRS (g ft) fi)

instance Random RS where
  random = RS (\i -> (next i, next i))

type Board = [Int]

nim :: IO ()
nim = do
  seed <- readLn :: IO Int
  nim' (nimWithSeed seed) seed
  where
    nim' board seed = do
      nimPut board
      if nimCheck board
        then putStrLn "You lost :("
        else do
          putStrLn "Your move?"
          row <- readLn :: IO Int
          amount <- readLn :: IO Int
          let b = nimMove board (row, amount)
          if nimCheck b
            then putStrLn "You won :)"
            else nim' (nimCpuMove b rand rand') seed'
      where
        rand = withSeed random seed
        rand' = withSeed random rand
        seed' = withSeed random rand
    nimWithSeed seed = map (\x -> 1 + x `mod` 5) $ take 5 $ tail $ iterate (withSeed random) seed
    nimCheck = all (0 ==)
    nimMove board (row, amount) =
      case (board, row) of
        ([], _) -> error "nimMove empty"
        (r:rs, 1) ->
          if amount > r
            then error "nimMove invalid"
            else (r - amount) : rs
        (r:rs, _) -> r : nimMove rs (pred row, amount)
    nimCpuMove board row = aux board (row `mod` possible)
      where
        possible =
          foldl
            (\x acc ->
               if x > 0
                 then acc + 1
                 else acc)
            0
            board
        aux :: Board -> Int -> Int -> Board
        aux (0:rs) row' amount = 0 : aux rs row' amount
        aux (r:rs) 0 amount = r - 1 - amount `mod` r : rs
        aux (r:rs) row' amount = r : aux rs (pred row') amount
    nimPut board = do
      putStrLn "============="
      putLn 1 board
      where
        putLn _ [] = putStrLn "============="
        putLn i (r:rs) = do
          putStr (show i ++ ": ")
          putStrLn (unwords (replicate r "*"))
          putLn (succ i) rs

-- Zadanie 5
data RegExpr
  = Letter Char
  | Alter RegExpr
          RegExpr
  | Concat RegExpr
           RegExpr
  | Star RegExpr
  | Epsilon
  deriving (Show)

class Monad m =>
      Nondet m where
  amb :: m a -> m a -> m a
  fail' :: m a

match :: Nondet m => RegExpr -> String -> m ()
match re str = do
  str' <- matchToString re str
  if str' == ""
    then return ()
    else fail'

matchToString :: Nondet m => RegExpr -> String -> m String
matchToString Epsilon str = return str
matchToString (Letter c) (s:str) =
  if s == c
    then return str
    else fail'
matchToString (Concat re re') str = do
  str' <- matchToString re str
  matchToString re' str'
matchToString (Alter re re') str = amb (matchToString re str) (matchToString re' str)
matchToString (Star (Star re)) str = matchToString (Star re) str
matchToString (Star re) str = matchToString (Alter Epsilon (Concat re (Star re))) str
matchToString _ "" = fail'

-- Zadanie 6
instance Nondet [] where
  amb = (++)
  fail' = []

matchUsingList :: RegExpr -> String -> [()]
matchUsingList = match

instance Nondet Maybe where
  amb Nothing y = y
  amb x _ = x
  fail' = Nothing

matchUsingMaybe :: RegExpr -> String -> Maybe ()
matchUsingMaybe = match
