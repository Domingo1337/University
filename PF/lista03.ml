(* Zadanie 1 *)
let atoi_a (xs: char list) =
  let rec aux xs acc = 
    match xs with
    | [] -> acc
    | x::xs -> aux xs (10*acc + (int_of_char x) - 48)
  in aux xs 0;;

let atoi_b (xs: char list) =
  List.fold_left (fun acc c -> 10*acc + (int_of_char c) - 48) 0 xs;;

(* Zadanie 2 *)
let polynomial_a (p: float list) (x: float) =
  let rec aux p acc =
    match p with 
    | [] -> acc
    | [h] -> acc +. h
    | h::t -> aux t ((acc+.h) *. x)
  in aux p 0.0;; 

let polynomial_b (p: float list) (x: float) =
  List.fold_left (fun acc h -> acc*.x +. h) 0. p;;

(* Zadanie 3 *)
let rec fold_right_a (f: 'a -> 'b -> 'b) (xs: 'a list) (c: 'b) =
  match xs with
  | [] -> c
  | x::xs -> f x (fold_right_a f xs c);;

let rec fold_right_b (f: 'a -> 'b -> 'b) (xs: 'a list) (c: 'b) =
  List.fold_left (fun b a -> f a b) c (List.rev xs);;

(* Zadanie 4 *)
(* jawna rekursja *)
let rec input (y: 'a) (xs: 'a list) =
  match xs with
  | [] -> [[y]]
  | h::t -> (y::xs)::(List.map (fun xs -> h::xs) (input y t));;

(* jawna rekursja ogonowa *)
let input_t (y: 'a) (xs: 'a list) =
  let rec aux xs acc =
    match xs with
    | [] -> List.map List.rev (fst acc) (* przy liczeniu permutacji rev chyba nie będzie potrzebny *)
    | h::t -> let xs = h::(snd acc)
              in aux t ((y::xs)::(List.map (fun ys -> h::ys) (fst acc)), xs)
  in aux xs ([[y]], []);;

(* fold na podstawie ogonowej *) (* Wyniki sa odwrocone ale to nas nie boli przy liczeniu permutacji*) 
let ins_everywhere_a (y: 'a) (xs: 'a list) =
  fst (List.fold_right (fun h acc-> let xs = h::(snd acc)
                                    in ((y::xs)::(List.map (fun ys -> h::ys) (fst acc)), xs))
                       xs 
                       ([[y]], []))

let ins_everywhere_b (y: 'a) (xs: 'a list) =
  fst (List.fold_left (fun acc h-> let xs = h::(snd acc) 
                                   in ((y::xs)::(List.map (fun ys -> h::ys) (fst acc)), xs))
                      ([[y]], [])
                      xs)

(* Zadanie 5 *)
let rec polynomial_a (p: float list) (x: float) =
  match p with
  | [] -> 0.
  | h::t -> h+.x*.(polynomial_5a t x);;

let polynomial_b (p: float list) (x: float) =
  List.fold_right (fun h acc -> h+.x*.acc) p 0.;;

let polynomial_c (p: float list) (x: float) =
  let rec aux p y acc =
    match p with
    | [] -> acc
    | h::t -> aux t (x*.y) (acc +. y*.h)
  in aux p 1. 0.;;

let polynomial_d (p: float list) (x: float) =
  List.fold_left (fun acc h -> h+.x*.acc) 0. p;;

(* Zadanie 6 *)
let perms_a (xs: 'a list) =
  List.fold_left (fun acc x -> List.concat (List.map (ins_everywhere_a x) acc)) [[]] xs;;

let perms_b (xs: 'a list) =
  List.fold_right (fun x acc -> List.concat (List.map (ins_everywhere_a x) acc)) xs [[]];;
