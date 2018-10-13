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
  | [] -> failwith "called with n bigger than l's length"
  | h::t ->  if n = 0 then h else take_nth t (n-1);; 

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


let rec reverse_t (l1: 'a list) (l2: 'a list) = 
  match l1, l2 with
  | [], l2 -> l2;
  | (h1::t1), l2 -> reverse_t t1 (h1::l2);; 

let rec merge_t (cmp: 'a -> 'a -> bool) (l1: 'a list) (l2: 'a list) (m: 'a list) =
  match l1, l2 with
  | [], [] -> reverse_t m []
  | [], (h::t)
  | (h::t), [] -> merge_t cmp [] t (h::m)
  | (h1::t1), (h2::t2) -> if cmp h1 h2 then merge_t cmp t1 l2 (h1::m) else merge_t cmp l1 t2 (h2::m);;

let rec take (l: 'a list) (start: int) (stop: int) =
  match l, stop with
  | _, -1 -> []
  | [], _ -> failwith "empty list"
  | (h::t), _ -> if start = 0 then h::(take t 0 (stop-1)) else take t (start-1) (stop-1);; 

let rec merge_sort (cmp: 'a -> 'a -> bool) (l: 'a list) (n: int) =
  if n = 0 then l else merge_t cmp (merge_sort cmp (take l 0     (n/2)) (n/2))
                                   (merge_sort cmp (take l ((n/2)+1) n) (n-(n/2)-1)) [];;

let rec merge_srt (l: int list) =
  merge_sort (<=) l ((length l) -1);;

let rec merge_rev (cmp: 'a -> 'a -> bool) (l1: 'a list) (l2: 'a list) (m: 'a list) =
  match l1, l2 with
  | [], [] -> m
  | [], (h::t)
  | (h::t), [] -> merge_rev cmp [] t (h::m)
  | (h1::t1), (h2::t2) -> if cmp h1 h2 then merge_rev cmp t1 l2 (h1::m) else merge_rev cmp l1 t2 (h2::m);;

let rec merge_rsort (cmp: 'a -> 'a -> bool) (l: 'a list) (n: int) =
  if n = 0 then l else merge_rev cmp (merge_rsort cmp (take l 0 (n/2)) (n/2)) (merge_rsort cmp (take l ((n/2)+1) n) (n-(n/2)-1)) [];;

let merge_rsrt (l: int list) =
  merge_rsort (<=) l ((length l)-1);;

(* dokleja do acc liczby naturalne od 0 do n w kolejnosci rosnacej*)
let rec ints (n : int) (acc: int list) =
  if n = 0 then n::acc else ints (n-1) (n::acc);;

(* Zadanie 4 *)
let rec partition (pred: 'a -> bool) (l: 'a list) = 
  let rec aux lst passed failed =
    match lst with
    | [] -> (passed, failed)
    | (h::t) -> if pred h then aux t (h::passed) failed else aux t passed (h::failed)
  in aux l [] [];;

let rec quick_sort (cmp: 'a -> 'a -> bool) (l: 'a list) =
  match l with
  | [] -> []
  | (h::t) -> match partition (fun a -> cmp a h) t with (lesser, bigger) -> (quick_sort cmp lesser)@(h::(quick_sort cmp bigger));; 

(* Zadanie 5 *)
let rec input (a :'a) (l: 'a list) =
  match l with
  | [] -> [[a]]
  | h::t -> let tails = input a t in
          (a::h::t)::(map (fun lst -> h::lst) tails);;

let rec concat (l: 'a list list) =
  match l with 
  | [] -> []
  | h::t -> h@(concat t);; 

let rec perms (l: 'a list) =
  match l with
  | [] -> [[]]
  | h::t -> let tails = perms t in
            concat (map (fun lst -> input h lst) tails);;