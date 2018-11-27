(* Zad 1 *)
fun f x -> f x;;
fun f g x -> f (g x);;

(* Zad 2 *)
let rec a_rec n = if n = 0 then 0 else 1 + 2 * a_rec(n - 1);;

let a_tail n = 
  let rec aux n acc = if n = 0 then acc else aux (n-1) (1 + 2*acc)
  in aux n 0;;

(* Zad 3 *)
let compose f g = fun x -> f(g x);;

let rec iter f n = 
  if n = 0 then fun x -> x
  else compose f (iter f (n-1));;

let mul a b = iter ((+) b) a 0;;

let pow a b = iter (mul a) b 1;;

(* Zad 4 *)
let head (s: int -> 'a) = s 0;;
let tail (s: int -> 'a) = fun (x: int) -> s (x+1);;

let add (s: int -> 'a) (c: 'a) = fun (x: int) -> (s x) + c;;

let map  (f: 'a -> 'a) (s: int -> 'a) = fun (x: int) -> f (s x);;

let map2 (f: 'a -> 'a -> 'a) (s1: int -> 'a)  (s2: int -> 'a) = fun (x: int) -> f (s1 x) (s2 x);;

let replace (n: int) (a: 'a) (s: int -> 'a) = fun (x: int) -> if x mod n = 0 then a else s x;;

let take (n: int) (s: int -> 'a) = fun (x: int) -> s (x*n);;

let rec scan (f: 'a -> 'b -> 'a) (a: 'a) (s: int -> 'b) x =
  if x = 0 then f a (s x) else f (scan f a s (x-1)) (s x);;

let rec tabulate = fun (s: int -> 'a) (start: int) (stop: int) -> if start = stop then [s stop] else [(s start)] @ (tabulate s (start+1) stop);;

(* Zad 5 *)
let ctrue  = fun (t: 'a) (f: 'a) -> t;;

let cfalse = fun (t: 'a) (f: 'a) -> f;;

let cand = fun p q -> p q cfalse;;
let cor  = fun p q -> p ctrue q;;

let cofb b = if b then ctrue else cfalse;;
let bofc c = c true false;;

(* Zad 6 *)
let zero = fun (f: 'a -> 'a) (x: 'a) -> x;;
let one  = fun (f: 'a -> 'a) (x: 'a) -> f x;;

let succ = fun c (f: 'a -> 'a) (x: 'a) -> f (c f) x;;

let add = fun c1 c2 f x -> c1 f (c2 f x);;
let mul = fun c1 c2 f x -> c1 (c2 f) x;;

let isZero = fun c -> c (ctrue cfalse) ctrue;; 

let iofc c = c ((+) 1) 0;;
let cofi i = (iter succ i) zero;;
