(* Zadanie 1 *)
let palindrome xs =
  let rec aux xs ys =
    match xs, ys with
    | h::t, [x] -> (true, t)
    | _, [] -> (true, xs)
    | hx::tx, hy1::hy2::ty ->
      let (b, ret) = (aux tx ty)
      in (b && (hx = List.hd ret), (List.tl ret))
    | _,_ -> (true, [])
  in fst (aux xs xs);;


(* Zadanie 2 *)
type 'a btree = Leaf | Node of 'a btree * 'a * 'a btree

let balanced (b: 'a btree) : bool =
  let rec aux_size (b: 'a btree) : int=
    match b with
    | Leaf -> 0
    | Node(l,x,r) ->
      match (aux_size l, aux_size r) with
      | -1, _
      | _, -1 -> -1
      | sl, sr -> if (abs (sl-sr)) > 1 then -1 else sl+sr+1
  in (aux_size b) >= 0;;

let build (l: 'a list) : 'a btree=
  let rec aux l n =
    match l, n with
    | [], _ -> (Leaf, [])
    | l, 0 -> (Leaf, l)
    | h::t, n ->
      let n_2 = (n-1)/2 in
      let (lft, r1) = aux t n_2 in
      let (rgt, r2) = aux r1 (n-n_2-1) in
      ((Node(lft, h, rgt)), r2)
  in fst (aux l (List.length l))


(* Zadanie 3 *)
type 'a mtree = MNode of 'a * 'a forest
and 'a forest = EmptyForest | Forest of 'a mtree * 'a forest

type 'a mtree_lst = MTree of 'a * ('a mtree_lst) list

let flatten_deep (t: 'a mtree_lst) =
  let rec aux xs t =
    let MTree(x,f) = t
    in x::(List.fold_left aux xs f)
  in aux [] t


(* Zadanie 4 *)
type form = Var of char | Neg of form | Conj of form * form | Disj of form * form

let rec toNNF form =
  match form with
  | Var(_) -> form
  | Conj(x,y) -> Conj((toNNF x), (toNNF y))
  | Disj(x,y) -> Disj((toNNF x), (toNNF y))
  | Neg(Neg f) -> f
  | Neg(Var _) -> form
  | Neg(Conj(x,y)) -> Disj((toNNF (Neg x)), (toNNF(Neg y)))
  | Neg(Disj(x,y)) -> Conj((toNNF (Neg x)), (toNNF(Neg y)))


(* Zadanie 5 *)
let rec fact_cps n k =
  if n = 0 then k 1
  else fact_cps (n-1) (fun v -> k (n*v));;

let prod (t: int btree) : int =
  let rec cps t f : int =
    match t with
    | Leaf -> f 1
    | Node(l,x,r) ->
      if x = 0 then 0
      else cps l (fun y -> (cps r (fun z -> f (x*y*z))))
  in cps t (fun x -> x)


(* Zadanie 6 *)
type 'a place = Place of 'a list * 'a list

let findNth (l: 'a list) (n: int) : 'a place =
  let rec aux prev next n =
    if n = 0 then (prev, next)
    else aux ((List.hd next)::prev) (List.tl next) (n-1)
  in let (l1,l2) =  (aux [] l n) in Place(l1,l2)

let rec collapse (p: 'a place) : 'a list =
  match p with
  | Place([], l) -> l
  | Place(h::t, l) -> collapse (Place(t, h::l))

let add (x: 'a) (p: 'a place) : 'a place =
  let Place(y, z) = p
  in Place(y, x::z)

let del (p: 'a place) : 'a place =
  let Place(y, z) = p
  in Place(y, List.tl z)

let next (p: 'a place) : 'a place =
  let Place(y, z) = p
  in Place((List.hd z)::y, List.tl z)

let prev (p: 'a place) : 'a place =
  let Place(y, z) = p
  in Place(List.tl y, (List.hd y)::z)

type 'a btplace = BTPlace of 'a btree * ('a btree * bool * 'a) list

let rec collapse (p: 'a btplace) : 'a btree =
  match p with
  | BTPlace(b, []) -> b
  | BTPlace(b, parent::parents) ->
    let (sibling, isRight, value) = parent in
    let parent = if isRight then Node(sibling, value, b)
      else Node(b, value, sibling)
    in collapse (BTPlace(parent, parents))
