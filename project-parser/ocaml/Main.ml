open Parser
open Error
open Astprint
open Lexing
open Printf

let source = ref ""
let target = ref ""

let usage () = 
    Printf.printf "Usage: ./parser24 file.q24 astfile\n";
    exit 1

let read_args () =
    let argc = Array.length (Sys.argv) in
    if ( argc <> 2) 
(*     if ( argc <> 3)  *)
        then usage ()
    else
        source :=  Sys.argv.(1);
(*         target :=  Sys.argv.(2); *)
        let len   = String.length !source in
            if (len < 4 || (not (String.sub !source (len-4) 4 = ".q24")))  
                    then
                    (
                        Printf.printf "Source code file must end in .q24\n";
                        exit 1
                    )


let main =
    read_args () ;
(*    let in_channel = open_in !source in 
        let out_channel = open_out !target in 
            Printf.fprintf out_channel "mplampla\n";
            close_out out_channel;*)
    let in_channel = open_in !source in             
    let lexbuf = Lexing.from_channel in_channel in

(*        printf "Now parsing file %s\n" !source;
        printf "Now parsing: %s\n"  (Lexing.lexeme lexbuf);
        Parser.program Lexer.lexer lexbuf;        
        exit 0*)
        try
            let prog = (Parser.program Lexer.lexer lexbuf) in
                ast_print stdout prog;
                exit 0
        with Parsing.Parse_error ->
            let pos = lexbuf.Lexing.lex_curr_p in
            let tok = Lexing.lexeme lexbuf in
            error "Syntax error at line %d, position %d, token \"%s\"" 
                  pos.pos_lnum (pos.pos_cnum - pos.pos_bol) tok;
            (* print illegal here  *)
            fprintf stdout "(illegal)\n";
            exit 1

                    


(* Menhir attempt *)
                    
(*let print_position outx lexbuf =
  let pos = lexbuf.lex_curr_p in
  fprintf outx "%s:%d:%d" pos.pos_fname
    pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1)

let parse_with_error lexbuf =
  try Parser.program Lexer.lexer lexbuf with
  | SyntaxError msg ->
    fprintf stderr "%a: %s\n" print_position lexbuf msg;
    None
  | Parser.Error ->
    fprintf stderr "%a: syntax error\n" print_position lexbuf;
    exit (-1)                    
    
let main =
    read_args () ;
let in_channel = open_in !source in             
let lexbuf = Lexing.from_channel in_channel in
    parse_with_error lexbuf
*)

                    
(* not used     *)
(*let main =
    read_args () ;
(*    let in_channel = open_in !source in 
        let out_channel = open_out !target in 
            Printf.fprintf out_channel "mplampla\n";
            close_out out_channel;*)
    let in_channel = open_in !source in             
    let lexbuf = Lexing.from_channel in_channel in
    let code_list = Parser.program Lexer.lexer lexbuf in
    exit 0;*)
    
(*
    let code_list = Parser.program Lexer.lexer lexbuf in
    let len = List.length code_list in
    let code = Array.make len Quad_ret in*)
