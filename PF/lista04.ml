type 'a mtx = 'a list list
exception Mtx of string

let mtx_id (size: int) (zero: 'a) (one: 'a) =
  let rec id_row n j acc =
    if j < size then id_row (n-1) (j+1) ((if n = 0 then one else zero)::acc)
                else acc
  and aux i acc =
    if i < size then aux (i+1) ((id_row i 0 [])::acc) else acc
  in aux 0 [];;

(* Zadanie 1 *)
let mtx_dim (m: 'a mtx)=
  match m with
  | [] -> raise (Mtx "Pusta macierz")
  | m -> List.fold_left (fun (rows, cols) current -> let len = List.length current in
                                              if len < 1 then raise (Mtx "Macierz ma pusty wiersz")
                                              else if cols = -1 then (1, len)
                                              else if len==cols then ((rows+1), cols)
                                              else raise (Mtx "Macierz ma wiersz o niepoprawnej długości"))
                        (-1,-1)
                        m;;

(* Zadanie 2 *)
let mtx_row (row: int) (m: 'a mtx) = 
  let rec aux m i =
    match m with
    | [] -> raise (Mtx "Nie ma takiego wiersza")
    | r::rs -> if i = 1 then r else aux rs (i-1)
  in aux m row;;

let rec take (elem: int) (row: 'a list) =
  match row with
  | [] -> raise (Mtx "Pusty wiersz!")
  | r::rs -> if elem = 1 then r else take (elem-1) rs;;

let mtx_column (column: int) (m: 'a mtx) =
  List.fold_right (fun row acc-> (take column row)::acc) m [];;

let rec mtx_elem (column: int) (row: int) (m: 'a mtx) =
  match m with
  | [] -> raise (Mtx "Nie ma takiego wiersza")
  | r::rs -> if row = 1 then take column r
             else mtx_elem column (row-1) rs;;

let rec transpose (m: 'a mtx) =
  let rec aux t m =
    match m with
    | [] -> t
    | m -> let (t1, m1) = List.fold_right (fun row (t, m) -> match row with 
                                                   |[] -> (t,m)
                                                   |elem::elems -> (elem::t, elems::m)) 
                                          m ([], [])
           in aux t1 m1
  in aux [] m;;