(* Zadanie 1 *)
let rec fix (f: ('a -> 'b) -> 'a -> 'b) (x: 'a) : 'b =
  (f (fix f)) x

let fix_r  (f: ('a -> 'b) -> 'a -> 'b) (x: 'a) : 'b =
  let r = ref (fun x -> failwith "x")
  in  r := f (!r);
  f (!r) x

let fact =
  fix (fun f -> fun n->
      if n = 0 then 1
      else n * (f (n-1)))


(* Zadanie 2 *)
type 'a list_mutable = LMnil | LMCons of 'a * 'a list_mutable ref

let rec concat_copy (xs: 'a list_mutable) (ys: 'a list_mutable) =
  match xs with
  | LMnil -> ys
  | LMCons(x, xs) -> LMCons(x, ref (concat_copy !xs ys))

let rec concat_share (xs: 'a list_mutable ref) (ys: 'a list_mutable ref) : 'a list_mutable ref=
  match !xs with
  | LMnil -> ys
  | LMCons(x, xs) -> ref (LMCons(x, concat_share xs ys))


(* Zadanie 3 *)
type 'a table = 'a list_mutable

let new_table() =
  ref LMnil

let rec find (x: 'a) (table: ('a * 'b) table ref) =
  match !table with
  | LMnil -> None;
  | LMCons((a,b), table) ->
    if x > a then find x table
    else if x = a then Some b
    else None

let rec add (x,y) (table: ('a * 'b) table ref) =
  match !table with
  | LMnil -> table := LMCons((x,y), ref LMnil)
  | LMCons((a,b), rest) ->
    if x > a then add (x,y) rest
    else table := LMCons((x,y), ref (LMCons((a,b), rest)))

let memo =
  let table = new_table()
  in let rec memo f x =
       match find x table with
       | Some y -> y
       | None -> let y = f x
         in add (x, y) table; y
  in memo

let rec fib n =
  if n = 0 then 0
  else if n = 1 then 1
  else (fib (n-1)) + (fib (n-2))

let memoised = memo fib

let fib_memo =
  let table = new_table()
  in add (0,0) table; add (1,1) table;
  let rec fib_memo n =
    match find n table with
    | Some y -> y
    | None -> let fib_n = fib_memo (n-1) + fib_memo (n-2)
      in add (n, fib_n) table ; fib_n
  in fib_memo


(* Zadanie 4 *)
let fresh, reset =
  let k = ref 0 in
  let reset n = k:= n
  and fresh s =
    k := !k+1; s^(string_of_int !k)
  in fresh, reset


(* Zadanie 5 *)
type 'a lnode = {item: 'a; mutable next: 'a lnode}

let mk_circular_list e =
  let rec x = {item=e; next=x}
  in x

let insert_head e l =
  let x = {item=e; next=l.next}
  in l.next <- x; l

let insert_tail e l =
  let x = {item=e; next=l.next}
  in l.next <- x; x

let first ln = (ln.next).item

let last ln = ln.item

let elim_head l = l.next <- (l.next).next; l

let rec jump l n =
  if n <= 0 then l
  else jump (l.next) (n-1)

let len l =
  let start = l.next
  in let rec aux xs n =
       if xs.next == start then n
       else aux (xs.next) (n+1)
  in aux (l.next) 1;;

let jozef xs n =
  let rec aux xs m =
    match xs with
    | {item=e; next=ys} ->
      if ys == xs then [e]
      else if n = 1 || m = n then let x = first xs in x::(aux (elim_head xs) 1)
      else aux ys (m+1)
  in aux (jump xs ((len xs)-1)) 1

let x = mk_circular_list 5;;
insert_tail 4 x;;
insert_tail 3 x;;
insert_tail 2 x;;
insert_tail 1 x;;
