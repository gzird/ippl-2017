{
open Helper
open Lexing
open Error
open Parser



(* Function to increase line count in lexbuf *)
let line_inc lexbuf =
  let pos = lexbuf.Lexing.lex_curr_p in
  lexbuf.Lexing.lex_curr_p <- {
    pos with 
      Lexing.pos_lnum = pos.Lexing.pos_lnum +1;
      Lexing.pos_bol = pos.Lexing.pos_cnum;
  }
  
(* Creation of the keywords hashtable *)
let create_hashtable size init =
  let tbl = Hashtbl.create size in
  List.iter (fun (key,data) -> Hashtbl.add tbl key data) init;
  (tbl)


let keywords = create_hashtable 31 [
  ("protocol",    T_Protocol);
  ("extends",     T_Extends);
  ("fun",         T_Fun);
  ("class",       T_Class);
  ("implements",  T_Implements);
  ("constant",    T_Constant);  
  ("static",      T_Static);  
  ("function",    T_Function);    
  ("bool",        T_Bool);      
  ("char",        T_PTChar);      
  ("string",      T_PTString);        
  ("int",         T_Int);          
  ("float",       T_Float);  
  ("void",        T_Void);    
  ("if",          T_If);      
  ("else",        T_Else);        
  ("while",       T_While);      
  ("for",         T_For);      
  ("return",      T_Return);      
  ("halt",        T_Halt);      
  ("new",         T_New);        
  ("lambda",      T_Lambda);
  ("null",        T_Null);
  ("true",        T_True);          
  ("false",       T_False);
  (* double check this *)
  ("->",          T_Arrow);

  (* print funcs *)
  ("printLine",       T_Printline);
  ("printInt",        T_Printint);  
  ("printString",     T_Printfloat);
  ("printFloat",      T_Printstring);  
  ("printBool",       T_Printbool);    
]

}
  

let digit      = ['0'-'9']
let lcltr      = ['a'-'z']
let ucltr      = ['A'-'Z']
let id_char    = ['a'-'z' 'A'-'Z' '0'-'9' '_']
let white      = [' ' '\r']
let exponent   = 'e'('+'|'-')?digit+

(* Parsing *)
rule lexer = parse

  (* Ints are passed as strings *)
  |digit+ as num
              {T_Const(num)}

  (* Floats are passed as strings *)
  | digit+'.'exponent?
  | '.'digit+exponent?  
  | digit+'.'digit+exponent? as num 
                                {T_Float_Const(num)}    
          
              
  (* We search for identifiers in the keyword hashtable.
   * If found then the keyword is returned, else the 
   * identifier is returned as a string *)
  |lcltr id_char* as id
              {
                try 
                    Hashtbl.find keywords id
                with 
                    Not_found -> T_Id(id)              
              }

  |ucltr id_char* as id
              { T_Var(id) }
              

  (* Eat whitespace *)
  |white      {lexer lexbuf}
  (* Increase the line count *)
  |'\n'       {line_inc lexbuf; lexer lexbuf}
  
  (* Handle comments seperately *)
  |"//"       {singleline_comment lexbuf}
  
 
  (* Operators and the rest of the symbols *)
  |"->"       {T_Arrow}
  |"="        {T_Set}
  
  |"||"       {T_Or}
  |"&&"       {T_And}

  |"=="       {T_Eq}
  |"!="       {T_Neq}
  |"<"        {T_Le}
  |"<="       {T_Leq}
  |">"        {T_Ge}
  |">="       {T_Geq}

  |'+'        {T_Add}
  |'-'        {T_Sub}
  
  |'*'        {T_Mult}
  |'/'        {T_Div}

  |'!'        {T_Not}  
  
  |';'        {T_Semicolon}
  |':'        {T_Colon}
  |','        {T_Comma}
  |'('        {T_LParen}
  |')'        {T_RParen}
  |'['        {T_LSq_Bracket}
  |']'        {T_RSq_Bracket}
  |'{'        {T_LCur_Bracket}
  |'}'        {T_RCur_Bracket}

  |'.'        {T_Dot}

 
  (* Strings and chars have their own handlers *)
  |"\""       {parse_string [] lexbuf}
  |"\'"       {parse_char lexbuf}  
  
  (* EOF *)  
  |eof        {T_Eof}
  
  (* Any other character is invalid - raise error *)
  |_ as c     {
                let pos = lexbuf.Lexing.lex_curr_p in
                error "Invalid character '%c' at line %d, position %d." 
                  c pos.pos_lnum (pos.pos_cnum - pos.pos_bol);
                lexer lexbuf
              }

(* String handler *)
and parse_string acc = parse
  (* Line feeds and eofs are invalid characters *)
  |'\n'       {
                let pos = lexbuf.Lexing.lex_curr_p in
                error "Multiline string at line %d" 
                  pos.pos_lnum;
                dispose_multiline_string lexbuf
              }
  |eof        {fatal "Unterminated string"; T_Eof}
  
  (* When the string is read, check for correctness *)
  |"\""       {
                let pos = lexbuf.Lexing.lex_curr_p in                
                let str = implode (List.rev acc) in 
                T_String(str, printable_str pos str)
              }
  
  (* Any other character is added to the acc *)
  |_ as c     {parse_string (c::acc) lexbuf}

(* When line feed is found in the middle of the string:
 * 1 - It is unterminated and so we reach eof or another string 
 * 2 - It is deliberately multiline and so we notify the 
       programmer and parse to the next '"'                  *)
and dispose_multiline_string = parse
  |eof        { fatal "Unterminated string"; T_Eof }
  |"\""       { T_String ("","")}
  |_          { dispose_multiline_string lexbuf }

  
(* Handle escaped characters in chars *)
and parse_char = parse
  |eof                {
                        fatal "Unterminated character at line: %d." 
                          lexbuf.lex_curr_p.pos_lnum; 
                        T_Eof
                      }
  |_ '\'' as c        {let pos = lexbuf.Lexing.lex_curr_p in
                        let ch = implode [c.[0]] in T_Char(ch, 
                                                        printable_str pos ch)}
  
  (* Anything else is invalid *)
  |_          {
                let pos = lexbuf.Lexing.lex_curr_p in
                error "Invalid character at line %d, position %d." 
                  pos.pos_lnum (pos.pos_cnum - pos.pos_bol);
                lexer lexbuf
              }
  
(* Single line comment handler *)
and singleline_comment = parse
  |'\n'       {line_inc lexbuf; lexer lexbuf}
  |eof        {T_Eof}
  |_          {singleline_comment lexbuf}
  


(* Use this to only test the lexer *)
(*
{
  let main =
    Printf.printf "Starting Lexing\n";
    let lexbuf = Lexing.from_channel stdin in
    let rec loop () =
      let token = lexer lexbuf in
(*
      Printf.printf "token=%s, lexeme=\"%s\"\n"
        (string_of_token token) (Lexing.lexeme lexbuf);
*)
      Printf.printf "lexeme=\"%s\"\n" (Lexing.lexeme lexbuf);
        if token <> T_Eof then loop () in
    loop ()
}*)
