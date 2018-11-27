(* Zadanie 2 *)
type 'a list_mutable = LMnil | LMCons of 'a * 'a list_mutable ref

let rec concat_copy (xs: 'a list_mutable) (ys: 'a list_mutable) =
  match xs, ys with
  | LMnil, zs
  | zs, LMnil -> zs
  | LMCons(x, xs), ys -> LMCons(x, ref (concat_copy !xs ys))

let rec concat_share (xs: 'a list_mutable ref) (ys: 'a list_mutable ref) =
  match !xs, ys with
  | LMnil, ys -> ys
  | LMCons(x, xs), ys -> ref (LMCons(x, concat_share xs ys))