(* Utilities *)
let rec map (f: 'a -> 'b) (l: 'a list) =
  match l with
  | [] -> []
  | h::t -> (f h)::(map f t);;

let rec length (l: 'a list) =
  match l with
  | [] -> 0
  | h::t -> 1 + (length t);;

let reverse (l: 'a list) =
  let rec iter l1 l2 =
    match l1, l2 with
    | [], l2 -> l2;
    | (h1::t1), l2 -> iter t1 (h1::l2)
  in iter l [];;

(* Zadanie 1 *)
let rec sublists (l: 'a list) =
  match l with
  | [] -> [[]]
  | h::t -> let tails = sublists t
            in (map (fun lst -> h::lst) tails)@tails;;

(* Zadanie 2  *)
let rec take_nth (l: 'a list) (n: int) =
  match l with
  | [] -> failwith "called with n bigger than l's length"
  | h::t ->  if n = 0 then h else take_nth t (n-1);; 

(* jesli b = a n to b[i] = a[i+n mod len(a)] *)
let cycle (l: 'a list) (n:int) =
  let reclen = length l
  in let rec iter (i: int) =
      if i < len then (take_nth l ((i-n+len) mod len))::(iter (i+1))
      else []
     in iter 0;;

(* Zadanie 3 *)
let rec merge (cmp: 'a -> 'a -> bool) (l1: 'a list) (l2: 'a list) =
  match l1, l2 with
  | [], lst 
  | lst, [] -> lst
  | (h1::t1), (h2::t2) -> if cmp h1 h2 then h1::(merge cmp t1 l2) else h2::(merge cmp l1 t2);;

let rec merge_t (cmp: 'a -> 'a -> bool) (l1: 'a list) (l2: 'a list) =
  let rec iter l1 l2 m =
    match l1, l2 with
    | [], lst
    | lst, [] -> (reverse m)@lst
    | (h1::t1), (h2::t2) -> if cmp h1 h2 then iter t1 l2 (h1::m) else iter l1 t2 (h2::m)
  in iter l1 l2 [];;

(* splits list in two lists with indices: 0 to n (reversed) and n+1 to the last *)
let split (l: 'a list) (n: int) =
  let rec iter l1 l2 n =
    match l2, n with
    | [], _
    | _, -1 -> l1, l2
    | (h::t), _ -> iter (h::l1) t (n-1)
  in iter [] l n;;

let rec merge_sort (cmp: 'a -> 'a -> bool) (l: 'a list) (n: int) =
  if n = 0 then l
  else match split l (n/2) with
       | lft, rgt -> merge_t cmp (merge_sort cmp lft (n/2))
                                 (merge_sort cmp rgt (n-(n/2)-1));;

let rec merge_srt (l: int list) =
  merge_sort (<=) l ((length l) -1);;

let rec merge_rev (cmp: 'a -> 'a -> bool) (l1: 'a list) (l2: 'a list) =
  let rec iter l1 l2 m =
    match l1, l2 with
    | [], [] -> m
    | [], (h::t)
    | (h::t), [] -> iter [] t (h::m)
    | (h1::t1), (h2::t2) -> if cmp h1 h2 then iter t1 l2 (h1::m) else iter l1 t2 (h2::m)
  in iter l1 l2 [];;

let rec merge_rsort (cmp: 'a -> 'a -> bool) (l: 'a list) (n: int) =
  if n = 0 then l
  else let invcmp = (fun a b -> not(cmp a b))
       in match split l (n/2) with
          | lft, rgt ->  merge_rev invcmp (merge_rsort invcmp lft (n/2))
                                          (merge_rsort invcmp rgt (n-(n/2)-1));;

let merge_rsrt (l: int list) =
  merge_rsort (<=) l ((length l)-1);;

(* Zadanie 4 *)
let partition (pred: 'a -> bool) (l: 'a list) = 
  let rec iter lst passed failed =
    match lst with
    | [] -> (passed, failed)
    | (h::t) -> if pred h then iter t (h::passed) failed
                          else iter t passed (h::failed)
  in iter l [] [];;

let rec quick_sort (cmp: 'a -> 'a -> bool) (l: 'a list) =
  match l with
  | [] -> []
  | (h::t) -> match partition (fun a -> cmp a h) t with
              | (lesser, bigger) -> (quick_sort cmp lesser)@(h::(quick_sort cmp bigger));; 

(* Zadanie 5 *)
let rec input (a :'a) (l: 'a list) =
  match l with
  | [] -> [[a]]
  | h::t -> let tails = input a t
            in (a::l)::(map (fun lst -> h::lst) tails);;

let rec concat (l: 'a list list) =
  match l with 
  | [] -> []
  | h::t -> h@(concat t);; 

let rec perms (l: 'a list) =
  match l with
  | [] -> [[]]
  | h::t -> let tails = perms t
            in concat (map (fun lst -> input h lst) tails);;

(* Zadanie 6 *)
let prefixes (l: 'a list) =
  let rec iter r acc =
    match r with
    | [] -> r::acc
    | (h::t) ->  iter t ([h]::(map (fun l -> h::l) acc))
  in iter (reverse l) [];;

let suffixes (l: 'a list) =
  let rec iter lst acc =
    match lst with
    | [] -> []::acc
    | (h::t) -> iter t (lst::acc)
  in iter l [];;
