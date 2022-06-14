open Format
open Lexing
open Error

(* String explode and implode functions *)
let explode s =
  let rec expl i l =
    if i < 0 then l else
    expl (i - 1) (s.[i] :: l) in
  expl (String.length s - 1) []

let implode l =
  let result = String.create (List.length l) in
  let rec imp i = function
  | [] -> result
  | c :: l -> result.[i] <- c; imp (i + 1) l in
  imp 0 l

  
(* Checks if a string is valid *)  
let printable_char c = 
    match c with 
      'a' .. 'z' 
    | 'A' .. 'Z'
    | '0' .. '9'
    | '_'   | ' '
    |  '!'  |  '#'  |  '$'  |  '%'  |  '&'  |  '('  |  ')'
    |  '*'  |  '+'  |  ','  |  '-'  |  '.'  |  '/'  |  ':'  |  ';'  |  '<'
    |  '='  |  '>'  |  '?'  |  '@'  |  '['  |  ']'  |  '^'  |  '{'  |  '}'
    |  '~' -> true
    | _    -> false
  
  
(* Checks if a string is valid *)
let printable_str pos str = 
  let length = String.length str in
  let rec loop i acc=
    if (i < length)
    then (
      if printable_char str.[i]
      then
        loop (i+1) (str.[i]::acc)
      else (
        error "Invalid character a line: %d, position: %d" pos.pos_lnum
                                                (pos.pos_cnum - pos.pos_bol);
        loop (i+1) (str.[i]::acc)
      )
    )
    else implode (List.rev acc)
  in loop 0 []  

  
