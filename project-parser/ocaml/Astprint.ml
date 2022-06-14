open Format
open Printf
open List
open Ast

(* to be used for nesting of factor_rest in a recursive manner *)
let depth = ref 0


(*
Most non-terminals have "many arguments", thus printing a list with pattern 
matching would have been tedious, i.e. see PROTODEC comment
*)

let rec ast_print ppf ast_prog = print_prog ppf ast_prog

(* PROGRAM *)
and print_prog ppf ast_prog = 
let PROGRAM(a_protodecs, a_classdecs, a_stm) = ast_prog in
    fprintf ppf "(program ("; 
        print_protodecs ppf a_protodecs;
    fprintf ppf ") (";
        print_classdecs ppf a_classdecs;
    fprintf ppf ") ";
        print_stm ppf a_stm;    
    fprintf ppf ")"

(* ID *)
and print_id ppf a_id = fprintf ppf " %s" a_id

(* TVAR *)
and print_tvar ppf a_tvar = fprintf ppf " %s" a_tvar

(* TYPEID *)
(* and print_typeid ppf a_typeid = fprintf ppf "%s" a_typeid *)


(* PROTODEC, see top comment -- PROTODEC has so many elems, how to code this 
better? same for similar non-terminals *)
and print_protodec ppf a_protodec = 
    let PROTODEC(a_typeid, a_typevars, a_extends, a_funprotos) = a_protodec in
        fprintf ppf "(protoDec %s (" a_typeid;
(*            print_typeid ppf a_typeid; 
        fprintf ppf " (";*)
            print_typevars ppf a_typevars;
        fprintf ppf ") (";
            print_funprotos ppf a_funprotos;    
        fprintf ppf ") (";
            print_extends ppf a_extends;    
        fprintf ppf "))"

        
(* PROTODECS *)
and print_protodecs ppf a_protodecs = 
match a_protodecs with
| []    -> fprintf ppf ""
| [x]   -> print_protodec ppf x
| x::xs -> print_protodec ppf x; fprintf ppf " "; print_protodecs ppf xs
(* map (print_protodec ppf) a_protodecs *)
(* ugly for OCaml code but has spacing *)
(*let n = length (a_protodecs) in
match n with
|   0 -> ()
|   1 -> print_protodec ppf (hd a_protodecs)
|   _ -> 
        for i = 0 to n-2 do 
            print_protodec ppf (nth a_protodecs i);
            fprintf ppf " " (* the reason for this ugly code --
                               could formatters solve this? *)
        done;
        print_protodec ppf (nth a_protodecs (n-1))       *)


(* TYPEVARS *)
and print_typevars ppf a_typevars = 
match a_typevars with
| TYPEVARS_empty           -> ()
| TYPEVARS_tvars (a_tvars) -> print_tvars ppf a_tvars


(* TVARS *)
and print_tvars ppf a_tvars =
match a_tvars with
| []    -> fprintf ppf ""
| [x]   -> fprintf ppf "%s" x
| x::xs -> fprintf ppf "%s " x; print_tvars ppf xs
(*let n = length (a_tvars) in
fprintf ppf "The list length is %d\n" n;
match n with
|   0 -> ()                                         
|   1 -> print_tvar ppf (hd a_tvars)
|   _ -> 
        for i = 0 to n-2 do 
            fprintf ppf "%s " (nth a_tvars i);
        done;
        fprintf ppf "%s" (nth a_tvars (n-1))       *)

        
(* EXTENDS *)
and print_extends ppf a_extends = 
match a_extends with
| EXTENDS_empty                 -> ()
| EXTENDS_typeapps (a_typeapps) -> print_typeapps ppf a_typeapps


(* TYPEAPPS *)
and print_typeapps ppf a_typeapps =
match a_typeapps with
| []    -> fprintf ppf ""
| [x]   -> print_typeapp ppf x
| x::xs -> print_typeapp ppf x; fprintf ppf " "; print_typeapps ppf xs
(*let n = length (a_typeapps) in
match n with
|   0 -> ()
|   1 -> print_typeapp ppf (hd a_typeapps)
|   _ -> 
        for i = 0 to n-2 do 
            print_typeapp ppf (nth a_typeapps i);
            fprintf ppf " " 
        done;
        print_typeapp ppf (nth a_typeapps (n-1))       *)

        
(* TYPEAPP *)
and print_typeapp ppf a_typeapp = 
match a_typeapp with
| TYPEAPP_typeid (a_typeid) ->
        fprintf ppf "(typeApp %s ())" a_typeid
| TYPEAPP_typeid_types (a_typeid, a_types) ->
        fprintf ppf "(typeApp %s (" a_typeid;     
            print_types ppf a_types;        
        fprintf ppf "))"        
| TYPEAPP_tvar (a_tvar) -> 
        fprintf ppf "(tVar %s)" a_tvar;
        

(* TYPES *)
and print_types ppf a_types =
match a_types with
| []    -> fprintf ppf ""
| [x]   -> print_type ppf x
| x::xs -> print_type ppf x; fprintf ppf " "; print_types ppf xs
(*     map (print_type ppf) a_types *)
        
        
(* TYPE *)
and print_type ppf a_type =
match a_type with
| TYPE_prim (a_primtype)       -> print_primtype ppf a_primtype
| TYPE_typeapp (a_typeapp)     -> print_typeapp  ppf a_typeapp
| TYPE_type (a_type')          ->  
                                    fprintf ppf "(arrayOf ";
                                    print_type ppf a_type';
                                    fprintf ppf ")"
| TYPE_fun (a_types, a_rtype)  -> 
                                    fprintf ppf "(funType (";
                                        print_types ppf a_types;
                                    fprintf ppf ") ";                    
                                        print_rtype ppf a_rtype;                
                                    fprintf ppf ")"

      
(* PRIMTYPE *)
and print_primtype ppf a_primtype = 
match a_primtype with
| PT_bool       -> fprintf ppf "(bool)"
| PT_char       -> fprintf ppf "(char)"
| PT_string     -> fprintf ppf "(string)"
| PT_int        -> fprintf ppf "(int)" 
| PT_float      -> fprintf ppf "(float)"


(* RTYPE *)
and print_rtype ppf a_rtype = 
match a_rtype with
| RT_type (a_type)  -> print_type ppf a_type
| RT_void           -> fprintf ppf "(void)"


(* FUNPROTOS *)
and print_funprotos ppf a_funprotos =
match a_funprotos with
| []    -> fprintf ppf ""
| [x]   -> print_funproto ppf x
| x::xs -> print_funproto ppf x; fprintf ppf " "; print_funprotos ppf xs
(*     map (print_funproto ppf) a_funprotos *)


(* FUNPROTO -- code duplication due to AST-type design *)
and print_funproto ppf a_funproto =
match a_funproto with
| FUNPROTO_1 (a_id, a_typevars, a_formals) ->
    fprintf ppf "(funProto %s (" a_id;
        print_typevars ppf a_typevars;
    fprintf ppf ") (";
        print_formals ppf a_formals;    
    fprintf ppf ") (void)"
| FUNPROTO_2 (a_id, a_typevars, a_formals, a_rtype) ->
    fprintf ppf "(funProto %s (" a_id;
        print_typevars ppf a_typevars;
    fprintf ppf ") (";
        print_formals ppf a_formals;    
    fprintf ppf ") (";
        print_rtype ppf a_rtype;    
    fprintf ppf ")"

    
(* FORMALS *)
and print_formals ppf a_formals =
match a_formals with
| []    -> fprintf ppf ""
| [x]   -> print_formal ppf x
| x::xs -> print_formal ppf x; fprintf ppf " "; print_formals ppf xs
(*     map (print_formal ppf) a_formals *)


(* FORMAL *)
and print_formal ppf a_formal =
let FORMAL (a_type, a_id) = a_formal in
    fprintf ppf "(formal ";
        print_type ppf a_type;
    fprintf ppf " %s)" a_id


(* CLASSDECS *)
and print_classdecs ppf a_classdecs = 
match a_classdecs with
| []    -> fprintf ppf ""
| [x]   -> print_classdec ppf x
| x::xs -> print_classdec ppf x; fprintf ppf " "; print_classdecs ppf xs
(*let n = length (a_classdecs) in
match n with
|   0 -> ()
|   1 -> print_protodec ppf (hd a_protodecs)
|   _ -> 
        for i = 0 to n-2 do 
            print_protodec ppf (nth a_protodecs i);
            fprintf ppf " " 
        done;
        print_protodec ppf (nth a_protodecs (n-1))       *)


(* CLASSDEC *)
and print_classdec ppf a_classdec = 
    let CLASSDEC(a_id, a_typevars, a_typeapps, a_classbody) = a_classdec in
        fprintf ppf "(classDec %s (" a_id; 
            print_typevars ppf a_typevars;
        fprintf ppf ") (";
            print_typeapps ppf a_typeapps;    
        fprintf ppf ") ";
            print_classbody ppf a_classbody;    
        fprintf ppf ")"                         (* classDec closes here *)

(* CLASSBODY --> INIT and BODYDECS *)
and print_classbody ppf a_classbody =
    let CLASSBODY (a_init, a_bodydecs) = a_classbody in
        print_init ppf a_init;
        fprintf ppf " (";                       (* bodydecs open here *)
        print_bodydecs ppf a_bodydecs;
        fprintf ppf ")"                         (* bodydecs closes here *)
        

(* INIT *)
and print_init ppf a_init =
    let INIT(a_formals, a_block) = a_init in
        fprintf ppf "(init (";
            print_formals ppf a_formals;
        fprintf ppf ") ";        
            print_block ppf a_block;
        fprintf ppf ")"                         (* init closes here *)

(* BODYDECS *)
and print_bodydecs ppf a_bodydecs =
match a_bodydecs with
| []    -> fprintf ppf ""
| [x]   -> print_bodydec ppf x
| x::xs -> print_bodydec ppf x; fprintf ppf " "; print_bodydecs ppf xs

(* BODYDEC *)
and print_bodydec ppf a_bodydec =
match a_bodydec with
| BODYDEC_const (a_constdec)  -> print_constdec  ppf a_constdec
| BODYDEC_glob  (a_globaldec) -> print_globaldec ppf a_globaldec
| BODYDEC_fld   (a_fielddec)  -> print_fielddec  ppf a_fielddec
| BODYDEC_fun   (a_fundec)    -> print_fundec    ppf a_fundec


(* BODYDEC components *)
(* CONSTDEC *)
and print_constdec ppf a_constdec =
    let CONSTDEC (a_primtype, a_id, a_literal) = a_constdec in
        fprintf ppf "(constant ";
            print_primtype ppf a_primtype;
        fprintf ppf " %s " a_id;
            print_literal ppf a_literal;
        fprintf ppf ")"            

(* GLOBALDEC *)
and print_globaldec ppf a_globaldec =
    let GLOBALDEC (a_primtype, a_id, a_literal) = a_globaldec in
        fprintf ppf "(static (";
            print_primtype ppf a_primtype;
        fprintf ppf " %s " a_id;
            print_literal ppf a_literal;
        fprintf ppf ")"            

(* FIELDDEC *)
and print_fielddec ppf a_fielddec = 
    let FIELDDEC (a_formal) = a_fielddec in
        fprintf ppf "(fieldDec ";
            print_formal ppf a_formal;
        fprintf ppf ")"

(* FUNDEC *)
and print_fundec ppf a_fundec =
match a_fundec with
| FUNDEC_1 (a_id, a_typevars, a_formals, a_block) ->
    fprintf ppf "(funDec %s (" a_id;
        print_typevars ppf a_typevars;
    fprintf ppf ") (";
        print_formals ppf a_formals;
    fprintf ppf ") (void) ";
        print_block ppf a_block;
    fprintf ppf ")"
| FUNDEC_2 (a_id, a_typevars, a_formals, a_rtype, a_block) ->    
    fprintf ppf "(funDec %s (" a_id;
        print_typevars ppf a_typevars;
    fprintf ppf ") (";
        print_formals ppf a_formals;
    fprintf ppf ") ";
        print_rtype ppf a_rtype;
    fprintf ppf " ";        
        print_block ppf a_block;
    fprintf ppf ")"

(* BLOCK *)
and print_block ppf a_block =
    let BLOCK (a_localdecs, a_stms) = a_block in
        fprintf ppf "(block (";
            print_localdecs ppf a_localdecs;
        fprintf ppf ") (";        
            print_stms ppf a_stms;
        fprintf ppf "))";

(* LITERAL *)
and print_literal ppf a_literal = 
match a_literal with
| LIT_null                  ->  fprintf ppf "(null)"
| LIT_true                  ->  fprintf ppf "(true)"
| LIT_false                 ->  fprintf ppf "(false)"
| LIT_char    (a_char)      ->  fprintf ppf "(charLiteral #\\%s)"     a_char
| LIT_string  (a_string)    ->  fprintf ppf "(stringLiteral \"%s\")"  a_string
| LIT_int     (a_int)       ->  fprintf ppf "(intLiteral %s)"         a_int
| LIT_float   (a_float)     ->  fprintf ppf "(floatLiteral %s)"       a_float


(* LOCALDECS *)
and print_localdecs ppf a_localdecs =
match a_localdecs with
| []    -> fprintf ppf ""
| [x]   -> print_localdec ppf x
| x::xs -> print_localdec ppf x; fprintf ppf " "; print_localdecs ppf xs

(* LOCALDEC *)
and print_localdec ppf a_localdec =
match a_localdec with
| LOCALDEC_1 (a_vardec) -> print_vardec ppf a_vardec
| LOCALDEC_2 (a_fundec) -> print_fundec ppf a_fundec

(* VARDEC *)
and print_vardec ppf a_vardec =
    let VARDEC (a_type, a_id, a_exp) = a_vardec in
        fprintf ppf "(varDec ";
            print_type ppf a_type;
        fprintf ppf " %s " a_id;        
            print_exp ppf a_exp;
        fprintf ppf ")";

(* STMS *)
and print_stms ppf a_stms =
match a_stms with
| []    -> fprintf ppf ""
| [x]   -> print_stm ppf x
| x::xs -> print_stm ppf x; fprintf ppf " "; print_stms ppf xs

(* STM *)
and print_stm ppf a_stm =
match a_stm with
| STM_semicolon -> fprintf ppf "(skip)"
| STM_exp        (a_exp) -> 
                            fprintf ppf "(expStm ";
                                print_exp ppf a_exp;
                            fprintf ppf ")"                    
| STM_if         (a_exp, a_stm, a_stm')  -> 
                            fprintf ppf "(if ";
                                print_exp ppf a_exp;
                            fprintf ppf " ";                            
                                print_stm ppf a_stm;
                            fprintf ppf " ";                            
                                print_stm ppf a_stm';
                            fprintf ppf ")"                  
| STM_while      (a_exp, a_stm)  ->
                            fprintf ppf "(while ";
                                print_exp ppf a_exp;
                            fprintf ppf " ";                            
                                print_stm ppf a_stm;
                            fprintf ppf ")"                  

| STM_for        (a_vardec, a_exp, a_exp', a_stm) ->
                            fprintf ppf "(block (";
                                print_vardec ppf a_vardec;
                            fprintf ppf ") ((while ";
                                print_exp ppf a_exp;
                            fprintf ppf "(block () (";
                                print_stm ppf a_stm;
                            fprintf ppf "(expStm ";
                                print_exp ppf a_exp';
                            fprintf ppf "))))))";


| STM_return  -> fprintf ppf "(return0)"
| STM_return_exp (a_exp)    ->
                            fprintf ppf "(return ";
                                print_exp ppf a_exp;
                            fprintf ppf ")"                 
| STM_block      (a_block) -> print_block ppf a_block
| STM_halt       (a_exp)   -> 
                            fprintf ppf "(halt ";
                                print_exp ppf a_exp;
                            fprintf ppf ")"                
| STM_printfun   (a_printfun) -> print_printfun ppf a_printfun


(* PRINTFUN -- need special handling atm *)
and print_printfun ppf a_printfun = 
match a_printfun with
| PRINTFUN_line                 ->
    fprintf ppf "expStm (call printLine ()))"
| PRINTFUN_int      (a_exp)     -> 
    fprintf ppf "expStm (call printInt (";
        print_exp ppf a_exp;
    fprintf ppf ")))"
| PRINTFUN_str      (a_exp)     -> 
    fprintf ppf "expStm (call printString (";
        print_exp ppf a_exp;
    fprintf ppf ")))"
| PRINTFUN_bool     (a_exp)     ->                          
    fprintf ppf "expStm (call printBool (";
        print_exp ppf a_exp;
    fprintf ppf ")))"
| PRINTFUN_float    (a_exp)     ->
    fprintf ppf "expStm (call printFloat (";
        print_exp ppf a_exp;
    fprintf ppf ")))"
| PRINTFUN_char     (a_exp)     ->                                            
    fprintf ppf "expStm (call printChar (";
        print_exp ppf a_exp;
    fprintf ppf ")))"
 


(* EXPS *)
and print_exps ppf a_exps =
match a_exps with
| []    -> fprintf ppf ""
| [x]   -> print_exp ppf x
| x::xs -> print_exp ppf x; fprintf ppf " "; print_exps ppf xs


(* EXP *)
and print_exp ppf a_exp =
match a_exp with
| EXP_lhs  (a_lhs)                   -> print_lhs ppf a_lhs
| EXP_asgn (a_lhs, a_asgn_op, a_exp) ->
                                        fprintf ppf "(assign ";
                                            print_lhs ppf a_lhs;
                                        fprintf ppf " ";
                                            print_exp ppf a_exp;
                                        fprintf ppf ")"
(* LHS *)
and print_lhs ppf a_lhs =
match a_lhs with
| LHS_dis (a_disjunct)                 -> print_disjunct ppf a_disjunct
| LHS_or  (a_disjunct, a_or_op, a_lhs) ->
                                        fprintf ppf "(binOpn or ";
                                            print_disjunct ppf a_disjunct;
                                        fprintf ppf " ";
                                            print_lhs ppf a_lhs;
                                        fprintf ppf ")"
(* DISJUNCT *)
and print_disjunct ppf a_disjunct =
match a_disjunct with
| DISJUNCT_cos (a_conjunct)                    -> print_conjunct ppf a_conjunct
| DISJUNCT_and (a_conjunct, a_and_op, a_disjunct) ->
                                        fprintf ppf "(binOpn and ";
                                            print_conjunct ppf a_conjunct;
                                        fprintf ppf " ";
                                            print_disjunct ppf a_disjunct;
                                        fprintf ppf ")"

(* CONJUNCT *)
and print_conjunct ppf a_conjunct =
match a_conjunct with
| CONJUNCT_sim (a_simple)                     -> print_simple ppf a_simple
| CONJUNCT_relop (a_simple, a_relop_op, a_simple') ->

                                        if (a_relop_op = "==") then
                                            fprintf ppf "(binOpn = "
                                        else
                                           fprintf ppf "(binOpn %s " a_relop_op;

                                            print_simple ppf a_simple;
                                        fprintf ppf " ";
                                            print_simple ppf a_simple';
                                        fprintf ppf ")"

(* SIMPLE *)
and print_simple ppf a_simple =
match a_simple with
| SIMPLE_trm (a_term)                   ->  print_term ppf a_term
| SIMPLE_add (a_simple, a_add_op, a_term) ->
                                        fprintf ppf "(binOpn %s " a_add_op;
                                            print_simple ppf a_simple;
                                        fprintf ppf " ";
                                            print_term ppf a_term;
                                        fprintf ppf ")"
(* TERM *)
and print_term ppf a_term =
match a_term with
| TERM_fac (a_factor)                   -> print_factor ppf a_factor
| TERM_mul (a_term, a_mul_op, a_factor) ->
                                        fprintf ppf "(binOpn %s " a_mul_op;
                                            print_term ppf a_term;
                                        fprintf ppf " ";
                                            print_factor ppf a_factor;
                                        fprintf ppf ")"
(* FACTOR *)
(* factor rest does not work here as is, but there are other issues with
   this project in ocaml *)
and print_factor ppf a_factor =
match a_factor with
| FACTOR_unop (a_unop_op, a_factor') ->
    fprintf ppf "(unOpn %s " a_unop_op;
        print_factor ppf a_factor';
    fprintf ppf ")"
| FACTOR_literal (a_literal, a_factor_rest) ->
    print_literal ppf a_literal;
    print_factor_rest ppf a_factor_rest

(* the two newObject  *)
| FACTOR_new_id_1 (a_id, a_actuals, a_factor_rest) ->
    fprintf ppf "(newObject %s (" a_id;
        print_actuals ppf a_actuals;
    fprintf ppf "))";
        print_factor_rest ppf a_factor_rest
        
| FACTOR_new_id_2 (a_id, a_types, a_actuals, a_factor_rest) ->
    fprintf ppf "(newObject (classApp %s (" a_id;
        print_types ppf a_types;
    fprintf ppf ")) (";
        print_actuals ppf a_actuals;
    fprintf ppf "))";
        print_factor_rest ppf a_factor_rest

| FACTOR_new_id_3 (a_type, a_exp, a_factor_rest) -> 
    fprintf ppf "(newArray ";
        print_type ppf a_type;
    fprintf ppf " ";
        print_exp ppf a_exp;
    fprintf ppf ")";
        print_factor_rest ppf a_factor_rest    

(* following two are lambda  *)
| FACTOR_lambda_1 (a_formals, a_block, a_factor_rest) ->
    fprintf ppf "(lambda (";
        print_formals ppf a_formals;
    fprintf ppf ") (void) ";
            print_block ppf a_block;
    fprintf ppf ")";
        print_factor_rest ppf a_factor_rest

| FACTOR_lambda_2 (a_formals, a_rtype, a_block, a_factor_rest) ->
    fprintf ppf "(lambda (";
        print_formals ppf a_formals;
    fprintf ppf ") ";
        print_rtype ppf a_rtype;
        print_block ppf a_block;
    fprintf ppf ")";
        print_factor_rest ppf a_factor_rest

| FACTOR_exp (a_exp, a_factor_rest) ->
    print_exp ppf a_exp;
    print_factor_rest ppf a_factor_rest


| FACTOR_id  (a_id, a_factor_rest) -> 
    fprintf ppf "%s" a_id;
        print_factor_rest ppf a_factor_rest


(* FACTOR_REST  *)
(* Code incomplete *)
and print_factor_rest ppf a_factor_rest =
match a_factor_rest with
| FACTOR_REST_empty   -> fprintf ppf ""
| FACTOR_REST_actuals (a_actuals, a_factor_rest) ->
                        print_factor_rest ppf a_factor_rest;
                        fprintf ppf "(call ";
                            print_actuals ppf a_actuals;
                        fprintf ppf "))"
                    
| FACTOR_REST_id      (a_id, a_factor_rest) -> 
                        fprintf ppf "(dot ";
                            print_factor_rest ppf a_factor_rest;
                        fprintf ppf " %s)" a_id
| FACTOR_REST_exp     (a_exp, a_factor_rest) ->
                        fprintf ppf "(aref ";
                            print_exp ppf a_exp;
                        fprintf ppf " ";
                            print_factor_rest ppf a_factor_rest;
                        fprintf ppf ")"    


(* ACTUALS  *)
and print_actuals ppf a_actuals = print_exps ppf a_actuals


   
