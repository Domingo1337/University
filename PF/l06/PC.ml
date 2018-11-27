open Syntax

(* Zadanie 1 *)
let checkt (proof: string pt) =
  let rec aux proof axioms =
    match proof with
    | Ax (prop) -> (prop, List.mem prop axioms)
    | TopI -> (Top, true)
    | ConjI (pt1, pt2) ->
      let p1, b1 = aux pt1 axioms and p2, b2 = aux pt2 axioms
      in Conj(p1, p2), b1 && b2
    | DisjIL (pt, prop) ->
      let p, b = aux pt axioms in Disj(p, prop), b
    | DisjIR (prop, pt) ->
      let p, b = aux pt axioms in Disj(prop, p), b
    | ImplI(prop, pt) ->
      let p, b = aux pt (prop::axioms) in Impl(prop, p), b
    | BotE (prop) -> prop, true
    | ConjEL(pt) ->
      (match aux pt axioms with
       | Conj(x, _), b -> x, b
       | x, _ -> x, false)
    | ConjER(pt) ->
      (match aux pt axioms with
       | Conj(_, x), b -> x, b
       | x, _ -> x, false)
    |DisjE(pt0, (prop1, pt1), (prop2, pt2)) ->
      (match aux pt0 axioms, aux pt1 (prop1::axioms), aux pt2 (prop2::axioms)  with
       | (Disj(x,y), b0), (z, b1), (w, b2) -> z, z = w && b1 && b2
       | (z, _), _, _-> z, false)
    | ImplE(pt1, pt2) ->
      (match aux pt1 axioms, aux pt2 axioms with
       | (x, b1), (Impl(y, z), b2) -> z, x = y && b1 && b2
       | (x, _), (y,_) -> Impl(x,y), false)
  in aux proof []

(* Zadanie 2 *)
let checks (proof: string ps) =
  let rec deduce = function
    | Disj(x,y), proven -> List.mem x proven || List.mem y proven
    | current, proven ->
      let find_impls p = (List.filter (function Impl(_,x) -> x = p | _ -> false) proven) in
      let impls = find_impls current in
      List.exists
        (function
          | Conj(x,y) -> x = current || y = current
          | _ -> false) proven ||
      List.exists (function Impl(y, _) -> List.mem y proven | _ -> false) impls ||
      List.exists (function Disj(x,y) -> List.exists (function Impl(z,_) -> x = z | _ -> false) (find_impls current) ||
                                         List.exists (function Impl(z,_) -> y = z | _ -> false) (find_impls current)
                          | _ -> false) proven
  in let rec aux current proven =
       match current with
       | PDone(prop) -> (prop, List.mem prop proven || deduce (prop, proven))
       | PConc(prop, ps) ->
         if List.mem prop proven then aux ps proven
         else if deduce (prop,proven) then aux ps (prop::proven)
         else (Bot, false)
       | PHyp((prop, ps), rest) ->
         let p, b = aux ps (prop::proven) in
         if b then aux rest ((Impl(prop, p))::proven)
         else (Bot, false)
  in aux proof []

let check_thing thing =
  match thing with
  | TGoal(s, prop, pt) -> let p, b = checkt pt in if b && prop = p then s^": T" else s^": F"
  | SGoal(s, prop, ps) -> let p, b = checks ps in if b && prop = p then s^": T" else s^": F"

let _ =
  let lexbuf = Lexing.from_channel stdin in
  let proofs = Parser.file Lexer.token lexbuf
  (* powyższe wiersze wczytują listę dowodów ze standardowego wejścia
     i parsują ją do postaci zdefiniowanej w module Syntax *)
  in List.iter (fun t -> print_string (check_thing t); print_newline ()) proofs; print_newline ()
