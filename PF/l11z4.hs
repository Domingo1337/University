-- Zadanie 4
type Row = Int
type Board = [Row]

nim :: Board -> IO ()
nim board = do
  nimPut board
  if nimCheck board
    then putStrLn "You lost :("
    else do
      putStrLn "Your move?"
      row <- readLn :: IO Int
      amount <- readLn :: IO Int
      let b = nimMove board (row, amount)
      nimPut b
      if nimCheck b
        then putStrLn "You won :)"
        else do
          let best = nimBest b
          putStrLn ("CPU plays " ++ show best)
          nim (nimMove b best)
  where
    nimBest :: Board -> (Row, Int)
    nimBest = find 1
      where
        find _ [] = error "nimBest"
        find i (0:xs) = find (succ i) xs
        find i (x:_) = (i, x)
    nimCheck :: Board -> Bool
    nimCheck = all (0 ==)
    nimMove :: Board -> (Row, Int) -> Board
    nimMove board (row, amount) =
      case (board, row) of
        ([], _) -> error "nimMove empty"
        (r:rs, 1) ->
          if amount > r
            then error "nimMove invalid"
            else (r - amount) : rs
        (r:rs, _) -> r : nimMove rs (pred row, amount)
    nimPut :: Board -> IO ()
    nimPut board = do
      putStrLn "============="
      putLn 1 board
      where
        putLn _ [] = putStrLn "============="
        putLn i (r:rs) = do
          putStr (show i ++ ": ")
          putStrLn (unwords (replicate r "*"))
          putLn (succ i) rs
