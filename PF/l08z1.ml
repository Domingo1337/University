(* Zadanie 1 *)
(* 1 *)
module type PQUEUE =
sig
  type priority
  type 'a t
  exception EmptyPQueue
  val empty : 'a t
  val insert : 'a t -> priority -> 'a -> 'a t
  val remove : 'a t -> priority * 'a * 'a t
end

module Pqueue : PQUEUE with type priority = int =
struct
  type priority = int
  type 'a t =  (priority * 'a) list
  exception EmptyPQueue

  let empty = []

  let rec insert (que: 'a t) (p: priority) (elem: 'a) : 'a t =
    match que with
    | []-> [(p,elem)]
    | (h_p, h_e)::rest -> 
      if p >= h_p then (p,elem)::que
      else (h_p, h_e)::(insert rest p elem)

  let remove (que: 'a t) : 'priority * 'a * 'a t =
    match que with
    | [] -> raise EmptyPQueue
    | (p, e)::rest -> (p, e, rest)
end


(* 2 *)
let sort (lst: int list) : int list =
  let rec flatten que acc=
    if que = Pqueue.empty then acc
    else let (_, e, rest) = Pqueue.remove que
      in flatten rest (e::acc)
  in let rec aux lst que =
       match lst with
       | [] -> flatten que []
       | x::xs -> aux xs (Pqueue.insert que x x)
  in aux lst Pqueue.empty


(* 3 *)
module type ORDTYPE =
sig
  type t
  type comparison = LT | EQ | GT
  val compare : t -> t -> comparison
end

module Ordque (Order : ORDTYPE) : PQUEUE with type priority = Order.t =
struct
  type priority = Order.t
  type 'a t = (priority * 'a) list
  exception EmptyPQueue

  let empty = []

  let rec insert (que: 'a t) (p: priority) (elem: 'a) : 'a t =
    match que with
    | [] -> [(p,elem)]
    | (h_p, h_e)::rest -> 
      if Order.compare p h_p = Order.LT then (h_p, h_e)::(insert rest p elem)
      else (p, elem)::que

  let remove (que: 'a t) : 'priority * 'a * 'a t =
    match que with
    | [] -> raise EmptyPQueue
    | (p, e)::rest -> (p, e, rest)
end

module IntOrder : ORDTYPE with type t = int=
struct
  type t = int
  type comparison = LT | EQ | GT
  let compare (x:int) (y: int) =
    if x < y then LT
    else if x = y then EQ
    else GT
end

let sort_f (lst: int list) : int list =
  let module Q = Ordque(IntOrder) in
  let rec flatten que acc =
    if que = Q.empty then acc
    else let (_, e, rest) = Q.remove que
      in flatten rest (e::acc)
  in let rec aux lst que =
       match lst with
       | [] -> flatten que []
       | x::xs -> aux xs (Q.insert que x x)
  in aux lst Q.empty

let sort_fcm (type a) (module Ord : ORDTYPE with type t = a) (lst: a list) : a list =
  let module PQ = Ordque(Ord)
  in let rec flatten que acc =
       if que = PQ.empty then acc
       else let (_, e, rest) = PQ.remove que
         in flatten rest (e::acc)
  in let rec aux lst que =
       match lst with
       | [] -> flatten que []
       | x::xs -> aux xs (PQ.insert que x x)
  in aux lst PQ.empty
