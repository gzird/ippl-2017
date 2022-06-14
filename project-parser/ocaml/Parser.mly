%{

open Format
open Lexing
open Error
open Parsing
open Printf
open Ast
open Astprint

%}

/* For this parser, next 2 don't need to be tuples since we are reporting the
   problematic string directly, and there are no escape seqs */
%token<(string*string)> T_Char
%token<(string*string)> T_String
%token<string> T_Const
%token<string> T_Float_Const
%token<string> T_Id
%token<string> T_Var

%token T_Protocol
%token T_Extends
%token T_Fun
%token T_Class
%token T_Implements
%token T_Constant
%token T_Static
%token T_Function
%token T_Bool
%token T_PTChar
%token T_PTString
%token T_Int
%token T_Float
%token T_Void
%token T_If
%token T_Else
%token T_While
%token T_For
%token T_Return
%token T_Halt
%token T_New
%token T_Lambda
%token T_Null
%token T_True
%token T_False

/* print funcs */      
%token T_Printline     
%token T_Printbool     
%token T_Printchar     
%token T_Printstring   
%token T_Printint      
%token T_Printfloat    


/* Operators and Other Symbols */
%token T_Arrow
%token T_Set

%token T_Or
%token T_And

%token T_Eq
%token T_Neq
%token T_Le
%token T_Leq
%token T_Ge
%token T_Geq

%token T_Add
%token T_Sub

%token T_Mult
%token T_Div
%token T_Not

%token T_Semicolon
%token T_Colon
%token T_Comma
%token T_LParen
%token T_RParen
%token T_LSq_Bracket
%token T_RSq_Bracket
%token T_LCur_Bracket
%token T_RCur_Bracket

%token T_Dot

%token T_Eof

/* operator precedence */
%left T_Or
%left T_And
%nonassoc T_Eq T_Neq T_Ge T_Geq T_Le T_Leq
%left T_Add T_Sub
%left T_Mult T_Div
%nonassoc T_Not

/* Quirk24 grammar rules */
%start program
%type<Ast.ast_program> program

%%
/**/
program:            protodecs classdecs stm T_Eof {
                        PROGRAM ($1, $2, $3); 
                    };
/*
                 |  error T_Eof {
                        printf "(illegal)";
(*                         fatal "Invalid program."; *)
(*                     raise Terminate *)
                        
                    };
*/                    

/* program:            protodecs classdecs stm T_Eof {""}; */ 
                   
                    
/*    replace typeid with id
protodec:          T_Protocol typeid typevars extends T_LCur_Bracket funprotos 
                   T_RCur_Bracket {""};
*/                   
protodec:          T_Protocol id typevars extends T_LCur_Bracket funprotos 
                   T_RCur_Bracket {
                        PROTODEC ($2, $3, $4, $6);
                   };
                   
                   
typevars:        /* empty */       { TYPEVARS_empty; }
                 | T_Le tvars T_Ge { TYPEVARS_tvars ( $2 ); };
                 
extends:         /* empty */        { EXTENDS_empty; }
                 | T_Extends typeapps {EXTENDS_typeapps ( $2 );};

/*    replace typeid with id                 
typeapp:           typeid                 {""}
                 | typeid T_Le types T_Ge {""}
                 | tvar                   {""};  
*/

typeapp:           id                 { TYPEAPP_typeid($1); }
                 | id T_Le types T_Ge { TYPEAPP_typeid_types($1, $3); }
                 | tvar               { TYPEAPP_tvar($1) };  
                 
                 
funproto:          T_Fun id typevars T_LParen formals T_RParen T_Semicolon {
                        FUNPROTO_1 ($2, $3, $5);
                    }
                 | T_Fun id typevars T_LParen formals T_RParen T_Colon rtype 
                   T_Semicolon {
                        FUNPROTO_2 ($2, $3, $5, $8); 
                    };
                   
classdec:          T_Class id typevars T_Implements typeapps classbody {
                        CLASSDEC($2, $3, $5, $6);
                    };

classbody:         T_LCur_Bracket init bodydecs T_RCur_Bracket {
                        CLASSBODY($2, $3);
                    };

init:              T_LParen formals T_RParen block {
                        INIT($2, $4);
                    };

bodydec:           constdec  { BODYDEC_const($1); }
                 | globaldec { BODYDEC_glob($1);  }
                 | fielddec  { BODYDEC_fld($1);   }
                 | fundec    { BODYDEC_fun($1);   };
                 
constdec:          T_Constant primtype id T_Set literal T_Semicolon {
                        CONSTDEC($2, $3, $5);
                    };

globaldec:         T_Static primtype id T_Set literal T_Semicolon {
                        GLOBALDEC($2, $3, $5);
                    };
        
fielddec:          formal T_Semicolon { FIELDDEC( $1 ); };

formal:            ttype id { FORMAL($1, $2); };

fundec:            T_Fun id typevars T_LParen formals T_RParen block {
                        FUNDEC_1($2, $3, $5, $7);
                    }
                 | T_Fun id typevars T_LParen formals T_RParen T_Colon rtype 
                   block {
                        FUNDEC_2($2, $3, $5, $8, $9);
                    };

                   
block:             T_LCur_Bracket localdecs stms T_RCur_Bracket {
                        BLOCK($2, $3);
                    };


localdec:          vardec { LOCALDEC_1( $1 ); }
                 | fundec { LOCALDEC_2( $1 ); };
                 
vardec:            ttype id T_Set exp T_Semicolon {
                        VARDEC($1, $2, $4);
                    };

ttype:             primtype { TYPE_prim ( $1 ) }
                 | typeapp  { TYPE_typeapp ( $1 ) }
                 | ttype T_LSq_Bracket T_RSq_Bracket { TYPE_type( $1 ) }
                 | T_Function T_LParen T_LParen types T_RParen T_Arrow rtype
                   T_RParen { TYPE_fun( $4, $7) };                 


primtype:          T_Bool     { PT_bool }
                 | T_PTChar   { PT_char }
                 | T_PTString { PT_string }
                 | T_Int      { PT_int }
                 | T_Float    { PT_float };
                 
rtype:             ttype { RT_type ( $1 ) }
                 | T_Void { RT_void };
                 
stm:               T_Semicolon { STM_semicolon; }
                 | exp T_Semicolon { STM_exp( $1 ); }
                 | T_If T_LParen exp T_RParen stm T_Else stm {
                        STM_if($3, $5, $7);
                    }
                 | T_While T_LParen exp T_RParen stm {
                        STM_while($3, $5);
                    }
                 | T_For T_LParen vardec exp T_Semicolon exp T_RParen stm {
                        STM_for($3, $4, $6, $8);
                    }
                 | T_Return T_Semicolon {
                        STM_return;
                    }
                 | T_Return exp T_Semicolon {
                        STM_return_exp( $2 );
                    }
                 | block {
                        STM_block ( $1 );
                    }
                 | T_Halt T_LParen exp T_RParen T_Semicolon {
                        STM_halt( $3 );
                    }
                 /* add print funcs here                  */
                 | print_funcs { STM_printfun( $1 ); };

                 
exp:               lhs { EXP_lhs ( $1 ); }
                 | lhs assignop exp { EXP_asgn ($1, $2, $3); };
                             
lhs:               disjunct { LHS_dis($1); }
                 | disjunct orop lhs { LHS_or($1, $2, $3) };
               
disjunct:          conjunct { DISJUNCT_cos($1); }
                 | conjunct andop disjunct { DISJUNCT_and($1, $2, $3); };       
          
conjunct:          simple { CONJUNCT_sim ($1); }                 
                   /*   relop needs to be expanded */
                 | simple relop simple {CONJUNCT_relop ($1, $2, $3) };
                 
simple:            term { SIMPLE_trm ($1); }                 
                   /*   addop needs to be expanded */
                 | simple addop term {SIMPLE_add($1, $2, $3)};
                 
term:              factor { TERM_fac($1); }                 
                   /*   mulop needs to be expanded */
                 | term mulop factor { TERM_mul($1, $2, $3); };
                 
                   /*   unop needs to be expanded */ 
factor:            unop factor { FACTOR_unop ($1, $2); }
                 | literal factor_rest { FACTOR_literal ($1, $2); }
                 | T_New id T_LParen actuals T_RParen factor_rest {
                        FACTOR_new_id_1($2, $4, $6);
                    }
                 | T_New id T_Le types T_Ge T_LParen actuals T_RParen 
                   factor_rest {
                        FACTOR_new_id_2($2, $4, $7, $9);
                    }
                 | T_New ttype T_LSq_Bracket exp T_RSq_Bracket factor_rest {
                        FACTOR_new_id_3($2, $4, $6);
                    }
                 | T_Lambda T_LParen formals T_RParen block factor_rest {
                        FACTOR_lambda_1($3, $5, $6);
                    }
                 | T_Lambda T_LParen formals T_RParen T_Colon rtype block 
                   factor_rest {
                        FACTOR_lambda_2($3, $6, $7, $8);
                   }
                 | T_LParen exp T_RParen factor_rest {
                        FACTOR_exp($2, $4); 
                    }
                 | id factor_rest {
                        FACTOR_id($1, $2);
                    };
                 
factor_rest:     /* empty */        { FACTOR_REST_empty; }
                 | T_LParen actuals T_RParen factor_rest {
                        FACTOR_REST_actuals($2, $4);
                    }
                 | T_Dot id factor_rest {
                        FACTOR_REST_id($2, $3);
                    }
                 | T_LSq_Bracket exp T_RSq_Bracket factor_rest {
                        FACTOR_REST_exp($2, $4);
                    };
                 
literal:           T_Null { LIT_null; }                 
                 | T_True { LIT_true; }                 
                 | T_False { LIT_false; }                             
                 | charliteral { LIT_char($1); }
                 | stringliteral { LIT_string($1); }
                 | intliteral { LIT_int($1); }
                 | floatliteral { LIT_float($1); };              
                 
charliteral:       T_Char { fst $1; };

stringliteral:     T_String { fst $1; };
                 
intliteral:        T_Const { $1; };
                            
floatliteral:      T_Float_Const { $1; };

/*                              
tvars:             tvar {TVARS_tvar ( $1 );}
                 | tvar T_Comma tvars {TVARS_tvars ($1, [$3]) ;};
*/

tvars:             tvar { [$1];}
                 | tvar T_Comma tvars {$1 :: $3;};

                 
protodecs:         /* empty */        {[]}
                 | protodec protodecs   {$1 :: $2};
                 
typeapps:         /* empty */        {[];}
                 | typeapp typeapps_rest   {$1 :: $2;};
                 
typeapps_rest:    /* empty */        {[];}
                 | T_Comma typeapp typeapps_rest   {$2 :: $3};
                 
funprotos:        /* empty */        {[];}
                 | funproto funprotos   {$1 :: $2};
                 
classdecs:        /* empty */         {[];}
                 | classdec classdecs   {$1 :: $2};
                          
types:            /* empty */         {[];}
                 | ttype types_rest      {$1 :: $2};
                 
types_rest:       /* empty */         {[];}
                 | T_Comma ttype types_rest      {$2 :: $3};
                 
bodydecs:         /* empty */         {[];}
                 | bodydec bodydecs     {$1 :: $2};
                               
                            
localdecs:                                {[];}
                 | localdec localdecs     {$1 :: $2};                         

stms:                                   {[];}                
                 | stm stms             {$1 :: $2};
           
                 
formals:          /* empty */         {[];}                
                 | formal formals_rest  {$1 :: $2};
                 
formals_rest:     /* empty */         {[];}                                
                 | T_Comma formal formals_rest {$2 :: $3};
                 
actuals:          /* empty */         {[];}                                
                 | exp actuals_rest     {$1 :: $2};
              
actuals_rest:     /* empty */         {[];}                              
                 | T_Comma exp actuals_rest     {$2 :: $3};

     
assignop:          T_Set {"="};
orop:              T_Or  {"||"};
andop:             T_And {"&&"};

relop:             T_Eq    {"=="}
                 | T_Neq   {"!="}
                 | T_Le    {"<"}                 
                 | T_Leq   {"<="}                                  
                 | T_Ge    {">"}                 
                 | T_Geq   {">="};
                 
addop:             T_Add    {"+"}
                 | T_Sub    {"-"};
                 
mulop:             T_Mult   {"*"}
                 | T_Div    {"/"};
                            
unop:              T_Not    {"!"}
                 | T_Sub    {"-"};

                 
id:                T_Id { $1 };

/* typeid:            id {""}; */

tvar:              T_Var { $1 };

/******************************************************************************/
print_funcs:       T_Printline T_LParen T_RParen T_Semicolon {PRINTFUN_line;}
                 | T_Printint T_LParen exp T_RParen T_Semicolon {
                        PRINTFUN_int( $3 );
                    }
                 | T_Printstring T_LParen exp T_RParen T_Semicolon {
                        PRINTFUN_str( $3 );
                    }        
                 | T_Printbool T_LParen exp T_RParen T_Semicolon {
                        PRINTFUN_bool( $3 );
                    }           
                 | T_Printfloat T_LParen exp T_RParen T_Semicolon {
                        PRINTFUN_float( $3 );
                    }
                 | T_Printchar T_LParen exp T_RParen T_Semicolon {
                        PRINTFUN_char( $3 );
                    };

                    
                    
                    
                    
