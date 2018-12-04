module type VERTEX =
sig
  type t
  type label
  val equal : t -> t -> bool
  val create : label -> t
  val label : t -> label
end

module type EDGE =
sig
  type t
  type label
  type vertex
  val equal : t -> t -> bool
  val label : t -> label
  val create : label -> vertex -> vertex -> t
  val start : t ->  vertex
  val stop : t -> vertex
end

module Vertex : VERTEX with type t = int = 
struct
  type label = int
  type t = int
  let equal = fun v1 -> fun v2 -> v1 = v2
  let create = fun v -> v
  let label = fun v -> v
end

module Edge : EDGE with type vertex = Vertex.t and type t = int * Vertex.t * Vertex.t =
struct
  type t = int * Vertex.t * Vertex.t
  type label = int
  type vertex = Vertex.t
  let label = fun (l, _, _) -> l
  let start = fun (_, e1, _) -> e1
  let stop  = fun (_, _, e2) -> e2
  let create = fun l -> fun e1 -> fun e2 -> (l, e1, e2)
  let equal = fun e1 -> fun e2 -> true
end

module  type GRAPH =
sig
  (* typ  reprezentacji  grafu *)
  type t

  module V : VERTEX 
  type vertex = V.t

  module E : EDGE with type vertex = vertex
  type edge = E.t

  (* funkcje  wyszukiwania *)
  val mem_v : t -> vertex -> bool
  val mem_e : t -> edge -> bool
  val mem_e_v : t -> vertex -> vertex -> bool
  val find_e : t -> vertex -> vertex -> edge 
  val succ : t -> vertex -> vertex  list 
  val pred : t -> vertex -> vertex  list 
  val succ_e : t -> vertex -> edge  list 
  val pred_e : t -> vertex -> edge  list

  (* funkcje  modyfikacji *) 
  val empty : t 
  val add_e : t -> edge -> t 
  val add_v : t -> vertex -> t
  val rem_e : t -> edge -> t
  val rem_v : t -> vertex -> t

  (* iteratory *) 
  val fold_v : (vertex ->'a ->'a) -> t ->'a ->'a 
  val fold_e : (edge ->'a ->'a) -> t ->'a ->'a
end

module Graph : GRAPH with type V.t = Vertex.t and type E.t = Edge.t =
struct
  module V = Vertex
  type vertex = Vertex.t

  module E = Edge
  type edge = Edge.t

  type t = vertex list * edge list

  let mem_v (vs, es) v = List.exists (fun x -> Vertex.equal x v) vs
  let mem_e (vs, es) e = List.exists (fun x -> Edge.equal x e) es
  let mem_e_v (vs, es) v1 v2 = List.exists (fun e -> Vertex.equal (Edge.stop e) v2) (List.filter (fun e -> Vertex.equal (Edge.start e) v1) es)
  let find_e (vs, es) v1 v2 = List.find (fun e -> Vertex.equal (Edge.stop e) v2) (List.filter (fun e -> Vertex.equal (Edge.start e) v1) es)
  let succ (vs, es) v = List.map (fun e -> Edge.stop e) (List.filter (fun e -> Vertex.equal (Edge.start e) v) es)
  let pred (vs, es) v = List.map (fun e -> Edge.start e) (List.filter (fun e -> Vertex.equal (Edge.stop e) v) es)
  let succ_e (vs, es) v = List.filter (fun e -> Vertex.equal (Edge.start e) v) es
  let pred_e (vs, es) v = List.filter (fun e -> Vertex.equal (Edge.stop e) v) es

  let empty = ([], [])
  let add_e (vs, es) e = (vs, e::es)
  let add_v (vs, es) v = (v::vs, es)
  let rem_e (vs, es) e = (vs, List.filter (fun x -> not (Edge.equal x e)) es)
  let rem_v (vs, es) v = (List.filter (fun x -> not (Vertex.equal x v)) vs, es)

  let fold_v f (vs, es) v = List.fold_right f vs v
  let fold_e f (vs, es) e = List.fold_right f es e
end
