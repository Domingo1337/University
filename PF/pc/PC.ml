open Syntax

let _ =
  let lexbuf = Lexing.from_channel stdin in
  let proofs = Parser.file Lexer.token lexbuf
  (* powyższe wiersze wczytują listę dowodów ze standardowego wejścia
     i parsują ją do postaci zdefiniowanej w module Syntax *)
  in print_int (List.length proofs); print_newline ()
