(* Zad 1 *)
let rec f x = f x;;

(* Zad 2 *)
let rec a_rec n = if n = 0 then 0 else 1 + 2 * a_rec(n - 1);;

let a_tail n = 
  let rec aux n acc =if n = 0 then acc else aux (n-1) (1 + 2*acc)
  in aux n 0;;

(* Zad 3 *)
let compose f g = fun x -> f(g x);;

let rec iter f n = 
  if n = 0 then fun x -> x
  else compose f (iter f (n-1));;

let mult a b = (iter ((+) b) a) 0;;

let power a b = (iter (mult a) b) 1;;

(* Zad 5 *)

let ctrue  = fun (p : 'a) (q : 'a) -> p;;

let cfalse = fun (p : 'a) (q : 'a) -> q;;

let cand = fun p q -> p q cfalse;;
let cor  = fun p q -> p ctrue q;;

let cofb b = if b then ctrue else cfalse;;
let bofc c = c true false;;

(* Zad 6 *)
let zero = fun (f : 'a -> 'a) (x : 'a) -> x;;
let one  = fun (f : 'a -> 'a) (x : 'a) -> f x;;

let succ = fun c (f : 'a -> 'a) (x : 'a) -> compose f (c f) x;;

let add = fun c1 c2 f x -> compose (c1 f) (c2 f) x;;
let mul = fun c1 c2 f x -> c1 (c2 f) x;;

let isZero = fun c -> c (ctrue cfalse) ctrue;; 

let iofc c = c ((+) 1) 0;;
let cofi i = (iter succ i) zero;;
