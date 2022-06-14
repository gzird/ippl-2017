(* At the end, this contains only the AST type - so file needs renaming... *)

type ast_program = PROGRAM of ast_protodecs * ast_classdecs * ast_stm

and ast_protodecs = ast_protodec list
and ast_classdecs = ast_classdec list

and ast_protodec = PROTODEC of ast_typeid * ast_typevars * ast_extends * 
                               ast_funprotos
                              

and ast_stm =   STM_semicolon
              | STM_exp of ast_exp
              | STM_if  of ast_exp * ast_stm * ast_stm
              | STM_while of ast_exp * ast_stm
              | STM_for of ast_vardec * ast_exp * ast_exp * ast_stm
              | STM_return
              | STM_return_exp of ast_exp
              | STM_block of ast_block
              | STM_halt of ast_exp
              | STM_printfun of ast_printfun


and ast_printfun =   PRINTFUN_line 
                   | PRINTFUN_int   of ast_exp
                   | PRINTFUN_str   of ast_exp                   
                   | PRINTFUN_bool  of ast_exp                   
                   | PRINTFUN_float of ast_exp                   
                   | PRINTFUN_char  of ast_exp                                 
  
and ast_typevars =   TYPEVARS_empty
                   | TYPEVARS_tvars of ast_tvars
                   
and ast_extends  =   EXTENDS_empty
                   | EXTENDS_typeapps of ast_typeapps
                  
and ast_typeapp =    TYPEAPP_typeid of ast_typeid
                   | TYPEAPP_typeid_types of ast_typeid * ast_types
                   | TYPEAPP_tvar of ast_tvar

and ast_funproto =   FUNPROTO_1 of ast_id * ast_typevars * ast_formals
                   | FUNPROTO_2 of ast_id * ast_typevars * ast_formals * 
                                   ast_rtype
                   
and ast_classdec = CLASSDEC of ast_id * ast_typevars * ast_typeapps * 
                               ast_classbody

and ast_classbody = CLASSBODY of ast_init * ast_bodydecs

and ast_init = INIT of ast_formals * ast_block

and ast_bodydec =   BODYDEC_const of ast_constdec
                  | BODYDEC_glob of ast_globaldec
                  | BODYDEC_fld of ast_fielddec
                  | BODYDEC_fun of ast_fundec
                  
and ast_constdec = CONSTDEC of ast_primtype * ast_id * ast_literal

and ast_globaldec = GLOBALDEC of ast_primtype * ast_id * ast_literal

and ast_fielddec = FIELDDEC of ast_formal

and ast_formal   = FORMAL of ast_type * ast_id

and ast_fundec  =  FUNDEC_1 of ast_id * ast_typevars * ast_formals * ast_block
                 | FUNDEC_2 of ast_id * ast_typevars * ast_formals * ast_rtype
                               * ast_block
                               
and ast_block   = BLOCK of ast_localdecs * ast_stms

and ast_localdec =   LOCALDEC_1 of ast_vardec 
                   | LOCALDEC_2 of ast_fundec
                   
and ast_vardec   =   VARDEC of ast_type * ast_id * ast_exp

and ast_type     =   TYPE_prim of ast_primtype
                   | TYPE_typeapp of ast_typeapp
                   | TYPE_type of ast_type
                   | TYPE_fun of ast_types * ast_rtype
                   

and ast_primtype =   PT_bool
                   | PT_char
                   | PT_string
                   | PT_int
                   | PT_float
                   
and ast_rtype    =   RT_type of ast_type
                   | RT_void

and ast_exp      =   EXP_lhs of ast_lhs
                   | EXP_asgn of ast_lhs * ast_asgn_op * ast_exp
                   
and ast_lhs      =   LHS_dis of ast_disjunct
                   | LHS_or of ast_disjunct * ast_or_op * ast_lhs
                  
and ast_disjunct =   DISJUNCT_cos of ast_conjunct
                   | DISJUNCT_and of ast_conjunct * ast_and_op * ast_disjunct

and ast_conjunct =   CONJUNCT_sim of ast_simple
                   | CONJUNCT_relop of ast_simple * ast_relop_op * ast_simple
                  
and ast_simple =     SIMPLE_trm of ast_term
                   | SIMPLE_add of ast_simple * ast_add_op * ast_term
                  
and ast_term   =     TERM_fac of ast_factor
                   | TERM_mul of ast_term * ast_mul_op * ast_factor
                   
and ast_factor =     FACTOR_unop of ast_unop_op * ast_factor
                   | FACTOR_literal of ast_literal * ast_factor_rest
                   | FACTOR_new_id_1 of ast_id * ast_actuals * ast_factor_rest
                   | FACTOR_new_id_2 of ast_id * ast_types * ast_actuals * 
                                                             ast_factor_rest
                   | FACTOR_new_id_3 of ast_type * ast_exp * ast_factor_rest
                   | FACTOR_lambda_1 of ast_formals * ast_block * 
                                                                ast_factor_rest  
                   | FACTOR_lambda_2 of ast_formals * ast_rtype * ast_block * 
                                                                ast_factor_rest
                   | FACTOR_exp of ast_exp * ast_factor_rest
                   | FACTOR_id of ast_id * ast_factor_rest
                    
and ast_factor_rest =   FACTOR_REST_empty
                      | FACTOR_REST_actuals of ast_actuals * ast_factor_rest
                      | FACTOR_REST_id of ast_id * ast_factor_rest
                      | FACTOR_REST_exp of ast_exp * ast_factor_rest

and ast_literal     =   LIT_null
                      | LIT_true
                      | LIT_false
                      | LIT_char    of ast_char
                      | LIT_string  of ast_string
                      | LIT_int     of ast_int
                      | LIT_float   of ast_float

(* handle literals *)
and ast_char    = string
and ast_string  = string
and ast_int     = string
and ast_float   = string

(* handle_operators *)
and ast_asgn_op      = string
and ast_or_op        = string
and ast_and_op       = string
and ast_relop_op     = string
and ast_add_op       = string
and ast_mul_op       = string
and ast_unop_op      = string

and ast_id = string

and ast_typeid = ast_id

and ast_tvar = string


(*and ast_tvars        =   TVARS_tvar  of ast_tvar
                       | TVARS_tvars of ast_tvar * ast_tvars list*)
(*and ast_tvars        =   ast_tvar
                       | ast_tvar list*)

and ast_tvars        =   ast_tvar list

(* define at the top of this file *)                       
(* and ast_protodecs =   PROTODECS of ast_protodec list *)

and ast_typeapps         =   ast_typeapp list

(* and ast_typeapps_rest    =   ast_typeapp list *)

and ast_funprotos        =   ast_funproto list

(* define at the top of this file *)
(* and ast_classdecs    =   CLASSDECS of ast_classdec list *)

and ast_types             =   ast_type list
(* and ast_types_rest        =   ast_type list *)

and ast_bodydecs          =   ast_bodydec list

and ast_localdecs         =   ast_localdec list

and ast_stms              =   ast_stm list

and ast_formals           =   ast_formal list
(* and ast_formals_rest      =   ast_formal list *)


and ast_actuals           =   ast_exp list
(* and ast_actuals_rest      =   ast_exp list *)



   
