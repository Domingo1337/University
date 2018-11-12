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
;;
(* List.iter (fun x -> print_float (4. *. x); print_string " ") (take 100 leibnitz_stream) *)


let apply3 (f: 'a -> 'a -> 'a -> 'b) (s: 'a stream) : 'b stream =
  let rec aux x1 x2 x3 s =
    Cons(f x1 x2 x3, fun () -> aux x2 x3 (hd s) (tl s))
  in let x1 = hd s and s = tl s
  in let x2 = hd s and s = tl s
  in let x3 = hd s and s = tl s
  in aux x1 x2 x3 s;;

let euler : float stream =
  apply3 (fun x y z -> z -. (y -. z) *. (y -. z) /. (x -. 2. *. y +. z)) leibnitz_stream

(* Zad 2 *)
(* kolejka do bfs *)
type 'a queue = 'a list * 'a list

let emptyQueue =
  ([],[])

let isEmpty (q: 'a queue) : bool =
  match q with
  | xs, ys -> xs = [] && ys = []

let push (x: 'a) (q: 'a queue) : 'a queue =
  match q with
  | xs, ys -> xs, x::ys

let push_many (l: 'a list) (q: 'a queue) : 'a queue =
  match q with
  | xs, ys -> xs, (List.rev_append l ys)

let rec pop (q: 'a queue) : 'a * 'a queue=
  match q with
  | [], [] -> failwith "empty queue"
  | [], ys -> pop ((List.rev ys), [])
  | [x], ys -> x, ((List.rev ys), [])
  | x::xs, ys -> x, (xs, ys)

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

let n_sols (glasses, volumes) n : (move list) list =
  let s = State(glasses, List.map (fun _ -> 0) glasses)
  and m = moves (List.length glasses)
  and pred = fun (State(_, vs )) -> vs = volumes in
  let rec bfs ((current, lst), que) =
    if (pred current) then lst, que
    else bfs (pop
                (push_many
                   (List.map (fun move -> (apply_move move current), move::lst) m)
                   que)) in
  let rec solution_stream prev =
    let (next, rest) = bfs prev in
    Cons(List.rev next, fun () -> solution_stream (pop rest)) in
  take n (solution_stream ((s, []), emptyQueue))
