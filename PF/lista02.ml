(* Zadanie 1 *)
let rec map (f: 'a -> 'b) (l: 'a list) =
  match l with
  | [] -> []
  | h::t -> (f h)::(map f t);;

let rec sublists (l: 'a list) =
  match l with
  | [] -> [[]]
  | h::t -> let tails = sublists t in
            (map (fun lst -> h::lst) tails)@tails;;

(* Zadanie 2  *)
let rec take_nth (l: 'a list) (n: int) =
  match l with
  h::t ->  if n = 0 then h else take_nth t (n-1);; 

let rec length (l: 'a list) = 
  match l with
  | [] -> 0 
  | h::t -> 1 + (length t);; 

(* to jest jakas tragedia ten cycle ale nie wiem jak to lepiej zrobic *)
let rec cycle (l: 'a list) (n:int) =
  let rec len = length l 
      and aux (i: int) = 
        if i < len then (take_nth l ((i-n+len) mod len))::(aux (i+1)) else [] in
  aux 0;;

(* Zadanie 3 *)
let rec merge (cmp: 'a -> 'a -> bool) (l1: 'a list) (l2: 'a list) =
  match l1, l2 with
  | [], lst 
  | lst, [] -> lst
  | (h1::t1), (h2::t2) -> if cmp h1 h2 then h1::(merge cmp t1 l2) else h2::(merge cmp l1 t2);;

let rec merge_t (cmp: 'a -> 'a -> bool) (l1: 'a list) (l2: 'a list) (m: 'a list) =
  match l1, l2 with
  | [], lst
  | lst, [] -> lst
  | (h1::t1), (h2::t2) -> if cmp h1 h2 then merge_t cmp t1 l2 m@[h1] else merge_t cmp l1 t2 m@[h2];;

(* Zadanie 5 *)
let rec input (a :'a) (l: 'a list) =
  match l with
  | [] -> [[a]]
  | h::t -> let tails = input a t in
          (a::h::t)::(map (fun lst -> h::lst) tails);;

let rec append (l: 'a list list) =
  match l with 
  | [] -> []
  | h::t -> h@(append t);; 

let rec perms (l: 'a list) =
  match l with
  | [] -> [[]]
  | h::t -> let tails = perms t in
            append (map (fun lst -> input h lst) tails);;