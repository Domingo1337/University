type 'a mtx = 'a list list
exception Mtx of string

(* Narzedzia *)
let mtx_id (size: int) (zero: 'a) (one: 'a) =
  let rec id_row n j acc =
    if j < size then id_row (n-1) (j+1) ((if n = 0 then one else zero)::acc)
    else acc
  and aux i acc =
    if i < size then aux (i+1) ((id_row i 0 [])::acc)
    else acc
  in aux 0 []


let print_mtx (m: 'a mtx) (print_a: 'a -> unit) =
  List.iter (fun row -> print_string"[";
                        List.iter (fun a -> print_a a; print_string " ") row;
                        print_string "]\n")
            m;
  print_string "\n"

let print_fl_mtx (m: float mtx) =
  print_mtx m print_float

(* Zadanie 8 *)
let mtx_dim (m: 'a mtx)=
  match m with
  | [] -> raise (Mtx "mtx_dim called with empty matrix")
  | m -> List.fold_left (fun (rows, cols) current -> let len = List.length current in
                          if len < 1 then raise (Mtx "mtx_dim encountered empty row")
                          else if cols = -1 then (1, len)
                          else if len==cols then ((rows+1), cols)
                          else raise (Mtx "mtx_dim encountered row of invalid length"))
           (-1,-1)
           m

(* Zadanie 9 *)
let mtx_row (row: int) (m: 'a mtx) =
  let rec aux m i =
    match m with
    | [] -> raise (Mtx "mtx_row called with index bigger than matrix height")
    | r::rs -> if i = 1 then r
               else aux rs (i-1)
  in aux m row

(* funkcja pomocnicza wybierajaca i-ty element listy *)
let rec take (i: int) (lst: 'a list) =
  match lst with
  | [] -> raise (Mtx "take called with i bigger than lst length")
  | h::t -> if i = 1 then h
            else take (i-1) t

let mtx_column (column: int) (m: 'a mtx) =
  List.fold_right (fun row acc-> (take column row)::acc) m []

let rec mtx_elem (column: int) (row: int) (m: 'a mtx) =
  match m with
  | [] -> raise (Mtx "mtx_elem called with row bigger than matrix height")
  | r::rs -> if row = 1 then take column r
             else mtx_elem column (row-1) rs

(* Zadanie 10 *)
let rec transpose (m: 'a mtx) =
  let rec aux m =
    match m with
    | [] -> []
    | h::t -> let (t1, m1) =
                List.fold_right
                  (fun row (t, m) -> match row with
                                     | [] -> (t,m)
                                     | [elem] -> (elem::t, m)
                                     | elem::elems -> (elem::t, elems::m))
                  m ([], [])
              in t1::(aux m1)
  in aux m

(* Zadanie 11 *)
let mtx_map2 (f: 'a -> 'a -> 'b) (m1: 'a mtx) (m2: 'a mtx) =
  List.map2 (fun r1 r2 -> List.map2 (fun a1 a2 -> f a1 a2) r1 r2) m1 m2

let mtx_add =
  mtx_map2 (+)

(* Zadanie 12 *)
type 'a vector = 'a list

let scalar_prod (v1: float vector) (v2: float vector) =
  List.fold_left2 (fun acc f1 f2 -> acc +. f1 *. f2) 0.0 v1 v2

let polynomial (p: float list) (x: 'float) =
  let rec make_xs l =
    match l with
    | [] -> []
    | [_] -> [1.]
    | h::t -> let tail = make_xs t in (x *. (List.hd tail))::tail
  in scalar_prod p (make_xs p);;

(* Zadanie 13 *)
let mtx_apply (m: float mtx) (v: float vector) =
  List.map (scalar_prod v) m

(* mnozenie macierzy m1 m2 to mnozenie m1 przez wektory m2, ktore otrzymujemy jako liste przez transponowanie m2 *)
let mtx_mul (m1: float mtx) (m2: float mtx) =
  List.map (mtx_apply (transpose m2)) m1

(* Zadanie 14 *)

(* funkcja pomocniczna do obliczania minorow *)
(* odrzuca i-ty element listy *)
let rec filter_i_out (l: 'a list) (i: 'int) =
  match l with
  | [] -> []
  | h::t -> if i = 0 then filter_i_out t (-1) else h::(filter_i_out t (i-1))

(* obliczany za pomocą rozwinięcia Laplace'a *)
(* nie warto uruchamiac dla macierzy o rozmiarze > 10 *)
let rec det (m: 'float mtx) =
  match m with
  | [] -> 0.
  | [[x]] -> x
  (* korzystamy z tego że det M == det M^T wiec obliczamy transponowane minory zeby latwo usunac kolumne (wiersz) *)
  | row::rows -> let columns = transpose rows in
    fst (List.fold_left (fun (acc, i) elem -> (elem *. (det (filter_i_out columns i)) +. acc, (i+1)))
           (0.,0)
           row)
