(* lazy lists *)
type 'a llist = LNil | LCons of 'a * 'a llist Lazy.t

let lhd  = function
  | LNil -> failwith "lhd"
  | LCons(x, _) -> x

let ltl = function
  | LNil -> failwith "ltl"
  | LCons(_, lazy xs) -> xs

let rec ltake n ll =
  match n, ll with
  |  0, _ -> []
  | _, LNil -> []
  | n, LCons(x,lazy xs) -> x::(ltake (n-1) xs)

let rec toLazyList = function
    [] -> LNil
  | x::xs -> LCons(x, lazy (toLazyList xs))

let rec (@$) ll1 ll2 =
  match ll1 with
    LNil -> ll2
  | LCons(x, lazy xs) -> LCons(x, lazy (xs @$ ll2))

let rec lmap f ll =
  match ll with
  | LNil -> LNil
  | LCons(x, lazy xs) -> LCons(f x, lazy(lmap f xs))

(* streams *)
(* source: https://www.cs.cornell.edu/courses/cs3110/2017fa/l/12-streams/notes.html *)
type 'a stream = Cons of 'a * (unit -> 'a stream)

(* [hd s] is the head of [s] *)
let hd (Cons (h, _)) = h

(* [tl s] is the tail of [s] *)
let tl (Cons (_, tf)) = tf ()

(* [take n s] is the list of the first [n] elements of [s] *)
let rec take n s =
  if n=0 then []
  else hd s :: take (n-1) (tl s)

(* [drop n s] is all but the first [n] elements of [s] *)
let rec drop n s =
  if n = 0 then s
  else drop (n-1) (tl s)


(* Zadanie 1 *)
let leibnitz_stream : float stream =
  let rec aux n sgn acc =
    let acc = acc +. (sgn /. n)
    in Cons(acc, fun () -> aux (n +. 2.) (-. sgn) acc)
  in aux 1. 1. 0.

let apply3 (f: 'a -> 'a -> 'a -> 'b) (s: 'a stream) : 'b stream =
  let rec aux x1 x2 x3 s =
    Cons(f x1 x2 x3, fun () -> aux x2 x3 (hd s) (tl s))
  in let x1 = hd s and s = tl s
  in let x2 = hd s and s = tl s
  in let x3 = hd s and s = tl s
  in aux x1 x2 x3 s

let euler : float stream =
  apply3 (fun x y z -> z -. (y -. z) *. (y -. z) /. (x -. 2. *. y +. z)) leibnitz_stream

(* Lazy module *)
let lazy_leibnitz : float llist =
  let rec aux n sgn acc =
    let acc = acc +. (sgn /. n)
    in LCons(acc, lazy (aux (n+.2.) (-. sgn) acc))
  in aux 1. 1. 0.


let lazy_apply3 (f: 'a -> 'a -> 'a -> 'b) (ll: 'a llist) : 'b llist =
  let rec aux x1 x2 x3 ll=
    LCons( f x1 x2 x3, lazy (aux x2 x3 (lhd ll) (ltl ll)))
  in let x1 = lhd ll and ll = ltl ll
  in let x2 = lhd ll and ll = ltl ll
  in let x3 = lhd ll and ll = ltl ll
  in aux x1 x2 x3 ll

let lazy_euler : float llist =
  lazy_apply3 (fun x y z -> z -. (y -. z) *. (y -. z) /. (x -. 2. *. y +. z)) lazy_leibnitz


(* Zad 2 *)
(* sets  x(1|2) on pos(1|2) of xs and revappends rxs*)
let rec change pos1 x1 pos2 x2 xs rxs =
  match xs with
  | [] -> List.rev rxs
  | h::t ->
    match pos1, pos2 with
    | -1, -1 -> List.rev_append rxs xs
    | 0, _ -> change (-1) x1 (pos2-1) x2 t (x1::rxs)
    | _, 0 -> change (pos1-1) x1 (-1) x2 t (x2::rxs)
    | _, _ -> change (pos1-1) x1 (pos2-1) x2 t (h::rxs)

type move = FILL of int | DRAIN of int | TRANSFER of int * int
type state = State of int list * int list

let rec apply_move (m: move) (s: state) : state =
  match s with
  | State([], _)
  | State(_, []) -> failwith "empty state"
  | State(glasses, vol::volumes) ->
    match m with
    | FILL n ->
      if n = 0 then State(glasses, (List.hd glasses)::volumes)
      else let State(_, vols) = apply_move (FILL (n-1)) (State((List.tl glasses), volumes))
        in State(glasses, vol::vols)
    | DRAIN n ->
      if n = 0 then State(glasses, 0::volumes)
      else let State(_, vols) = apply_move (DRAIN (n-1)) (State(glasses, volumes))
        in State(glasses, vol::vols)
    | TRANSFER (from ,_to) ->
      if from = _to then s else
        let from_vol = List.nth (vol::volumes) from
        and to_vol = List.nth (vol::volumes) _to
        and to_gls = List.nth glasses _to in
        let new_from = max 0 (from_vol - (to_gls - to_vol))
        and new_to = min (from_vol+to_vol) to_gls in
        State(glasses,
              change from new_from _to new_to (vol::volumes) [])

let concatmap (f: 'a -> 'b list) (xs: 'a list) : 'b list =
  List.concat (List.map f xs)

let product (xs: 'a list) (ys: 'b list) : ('a * 'b) list =
  concatmap (fun y -> List.map (fun x-> x,y) xs) ys

let moves (len: int) =
  let rec ints_from n m =
    if n = m then []
    else m::(ints_from n (m+1)) in
  let positions = ints_from len 0 in
  (List.map (fun m -> FILL m) positions) @
  (List.map (fun m -> DRAIN m) positions) @
  (List.map (fun (m,n) -> TRANSFER(m,n)) (product positions positions))

let n_sols (glasses, volume) =
  let s = State(glasses, List.map (fun _ -> 0) glasses)
  and m = toLazyList(moves (List.length glasses))
  and pred = fun (State(_, vs )) -> List.mem volume vs in
  let rec bfs =
    function
    | LNil -> LNil
    | (LCons((current, lst), lazy que)) ->
      if (pred current) then LCons(List.rev lst, lazy (bfs que))
      else bfs (que @$ (lmap (fun move -> (apply_move move current), move::lst) m))
  in fun n -> ltake n (bfs (LCons((s,[]), lazy LNil)))


(* Zadanie 3 *)
type expression =
  | BOOL of bool
  | LIT  of bool * char
  | AND  of expression * expression
  | OR   of expression * expression
  | IMPL of expression * expression

type proof =
  | EXP of expression
  | FRAME of expression * proof
  | PROOF of proof list


(* Zadanie 4 *)
(* list of positive literals * list of negative literals *)
type varlist = VARS of char list * char list

let negate_vars (VARS(p,n)) : varlist =
  VARS(n,p)

let merge_vars (VARS(p1,n1)) (VARS(p2,n2)) : varlist =
  let rec merge l1 l2 =
    match l1, l2 with
    | [], lst
    | lst, [] -> lst
    | (h1::t1), (h2::t2) ->
      if h1 < h2 then h1::(merge t1 l2)
      else if h1 = h2 then  h2::(merge t1 t2)
      else h2::(merge l1 t2) in
  VARS(merge p1 p2, merge n1 n2)

let rec vars_of_e (e: expression) : varlist =
  match e with
  | BOOL _ -> VARS([],[])
  | LIT (b, c) -> if b then VARS([c],[]) else VARS([],[c])
  | AND (e1, e2)
  | OR  (e1, e2) -> merge_vars (vars_of_e e1) (vars_of_e e2)
  | IMPL(e1, e2) -> merge_vars (negate_vars (vars_of_e e1)) (vars_of_e e2)

let rec vars_of_p (p: proof) : varlist =
  match p with
  | EXP  (e) -> vars_of_e e
  | FRAME(e, p) -> merge_vars (negate_vars (vars_of_e e)) (vars_of_p p)
  | PROOF(ps) -> List.fold_left (fun acc p -> merge_vars (vars_of_p p) acc) (VARS([], [])) ps;;




(* printing *)
let rec print_e = function
  | BOOL b -> if b then print_string "T" else print_string "F"
  | LIT (b, c) -> if b then () else print_string "¬" ; print_char c
  | AND (p, q) -> print_e p ; print_string " ∧ "; print_e q
  | OR  (p, q) -> print_e p ; print_string " ∨ "; print_e q
  | IMPL(p, q) -> print_string "(" ; print_e p ; print_string " ⇒ "; print_e q; print_string ")";;

let rec print_p =
  function
  | EXP  (e) -> print_e e
  | FRAME(e, p) -> print_string "["; print_e e; print_string ":\n" ; print_p p; print_string "]"
  | PROOF(ps) -> List.iter (fun p -> print_p p; print_string ";\n" ) ps;;

let print_vars (VARS(p,n)) =
  print_string "pos:[";
  List.iter (fun v -> print_char v; print_string "; ") p;
  print_string "]\nneg:[";
  List.iter (fun v -> print_char v; print_string "; ") n;
  print_string "]\n";;



let frame = PROOF([FRAME(AND(LIT(true, 'p'), IMPL(LIT(true, 'p'), LIT(true, 'q'))),
                         PROOF([EXP(LIT(true, 'p'));
                                EXP(IMPL(LIT(true, 'p'), LIT(true, 'q')));
                                EXP(LIT(true, 'q'))]));
                   EXP(IMPL((AND(LIT(true, 'p'), IMPL(LIT(true, 'p'), LIT(true, 'q')))), LIT(true, 'q')))])

;;
(* print_p frame;; *)
(* print_vars (vars_of_p frame);; *)
