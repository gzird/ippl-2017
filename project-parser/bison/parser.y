%{
#include <stdio.h>
#include <string>
#include <stdlib.h>
#include <string.h>
#include <list>
using namespace std;

extern long int lineno;
extern int yylex(void);
extern FILE *yyin;
void yyerror(const char* msg);
%}

%union{
    char *s;        /* string literals                  */
    char c;         /* char literals                    */
    long i;         /* integer literals                 */
    float f;       /* float literals                   */
}


%token<c> T_Char
%token<s> T_String
%token<i> T_Const
%token<f> T_Float_Const
%token<s> T_Id
%token<s> T_Var

%token T_Protocol       "protocol"
%token T_Extends        "extends"
%token T_Fun            "fun"
%token T_Class          "class"
%token T_Implements     "implements"
%token T_Constant       "constant"
%token T_Static         "static"
%token T_Function       "function"
%token T_Bool           "bool"
%token T_PTChar         "char"
%token T_PTString       "string"
%token T_Int            "int"
%token T_Float          "float"
%token T_Void           "void"
%token T_If             "if"
%token T_Else           "else"
%token T_While          "while"
%token T_For            "for"
%token T_Return         "return"
%token T_Halt           "halt"
%token T_New            "new"
%token T_Lambda         "lambda"
%token T_Null           "null"
%token T_True           "true"
%token T_False          "false"
 
// %token T_Readint       "readInt"
%token T_Printline     "printLine"
%token T_Printbool     "printBool"
%token T_Printchar     "printChar"
%token T_Printstring   "printString"
%token T_Printint      "printInt"
%token T_Printfloat    "printFloat"


%token T_Arrow         "->"
%token T_Set           "="

%token T_Or            "||"
%token T_And           "&&"

%token T_Eq            "=="
%token T_Neq           "!="
%token T_Le            "<"
%token T_Leq           "<="
%token T_Ge            ">"
%token T_Geq           ">="

%token T_Add           "+"
%token T_Sub           "-"

%token T_Mult          "*"
%token T_Div           "/"
%token T_Not           "!"

%token T_Semicolon     ";"
%token T_Colon         ":"
%token T_Comma         ","
%token T_LParen        "("
%token T_RParen        ")"
%token T_LSq_Bracket   "["
%token T_RSq_Bracket   "]"
%token T_LCur_Bracket  "{"
%token T_RCur_Bracket  "}"
    
%token T_Dot           "."


/* operator precedence */
%left T_Or
%left T_And
%nonassoc T_Eq T_Neq T_Ge T_Geq T_Le T_Leq
%left T_Add T_Sub
%left T_Mult T_Div
%nonassoc T_Not

%left T_Dot

// %nonassoc "then"
// %nonassoc "else"
// %left     "||"
// %left     "&&"
// %left     "==" "!="
// %left     '>' '<' ">=" "<="
// %left     '+' '-'
// %left     '*' '/'           // operators infix
// %left     UNOP              // unary operators (prefix)


%error-verbose

// %define lr.type ielr

%start program

%%
program:            protodecs classdecs stm  {};
                   
                    
// /*    replace typeid with id*/ 
// protodec:          T_Protocol typeid typevars extends T_LCur_Bracket funprotos 
//                    T_RCur_Bracket {};
                  
protodec:          T_Protocol id typevars extends T_LCur_Bracket funprotos 
                   T_RCur_Bracket {};
                   
                   
typevars:        /* empty */     {}
                 | T_Le tvars T_Ge {};
                 
extends:         /* empty */        {}
                 | T_Extends typeapps {};

// /*    replace typeid with id      */           
// typeapp:           typeid                 {}
//                  | typeid T_Le types T_Ge {}
//                  | tvar                   {};  


typeapp:           id                 {}
                 | id T_Le types T_Ge {}
                 | tvar                   {};  
                 
                 
funproto:          T_Fun id typevars T_LParen formals T_RParen T_Semicolon {}
                 | T_Fun id typevars T_LParen formals T_RParen T_Colon rtype 
                   T_Semicolon {};
                   
classdec:          T_Class id typevars T_Implements typeapps classbody {};

classbody:         T_LCur_Bracket init bodydecs T_RCur_Bracket {};

init:              T_LParen formals T_RParen block {};

bodydec:           constdec {}
                 | globaldec {}
                 | fielddec  {}
                 | fundec    {};
                 
constdec:          T_Constant primtype id T_Set literal T_Semicolon {};

globaldec:         T_Static primtype id T_Set literal T_Semicolon {};
        
fielddec:          formal T_Semicolon {};

formal:            ttype id {};

fundec:            T_Fun id typevars T_LParen formals T_RParen block {}
                 | T_Fun id typevars T_LParen formals T_RParen T_Colon rtype 
                   block {};

                   
block:             T_LCur_Bracket localdecs stms T_RCur_Bracket {};


localdec:          vardec {}
                 | fundec {};
                 
vardec:            ttype id T_Set exp T_Semicolon {};

ttype:             primtype {}
                 | typeapp {}
                 | ttype T_LSq_Bracket T_RSq_Bracket {}
                 | T_Function T_LParen T_LParen types T_RParen arrow rtype 
                   T_RParen {};                 
                   
primtype:          T_Bool     {}
                 | T_PTChar   {}
                 | T_PTString {}
                 | T_Int      {}
                 | T_Float    {};
                 
rtype:             ttype {}
                 | T_Void {};
                 
arrow:             T_Arrow {};

stm:               T_Semicolon {}
                 | exp T_Semicolon {}
                 | T_If T_LParen exp T_RParen stm T_Else stm {}
                 | T_While T_LParen exp T_RParen stm {}
                 | T_For T_LParen vardec exp T_Semicolon exp T_RParen stm {}
                 | T_Return T_Semicolon {}
                 | T_Return exp T_Semicolon {}
                 | block {}
                 | T_Halt T_LParen exp T_RParen T_Semicolon {}
                 /* add print_funcs here                  */
                 | print_funcs {};

exp:               lhs {}
                 | lhs assignop exp {};
                             
lhs:               disjunct {}
                 | disjunct orop lhs {};
               
disjunct:          conjunct {}
                 | conjunct andop disjunct {};
                 
conjunct:          simple {}                 
                 | simple relop simple {};
                 
simple:            term {}                 
                 | simple addop term {};
                 
term:              factor {}                 
                 | term mulop factor {};
                 
factor:            unop factor {}
                 | literal factor_rest {}
                 | T_New id T_LParen actuals T_RParen factor_rest {}
                 | T_New id T_Le types T_Ge T_LParen actuals T_RParen 
                   factor_rest {}
                 | T_New ttype T_LSq_Bracket exp T_RSq_Bracket factor_rest {}
                 | T_Lambda T_LParen formals T_RParen block factor_rest {}
                 | T_Lambda T_LParen formals T_RParen T_Colon rtype block 
                   factor_rest {}
                 | T_LParen exp T_RParen factor_rest {}
                 | id factor_rest {};
                 
factor_rest:     /* empty */        {}
                 | T_LParen actuals T_RParen factor_rest {}
                 | T_Dot id factor_rest {}
                 | T_LSq_Bracket exp T_RSq_Bracket factor_rest {};
                 
literal:           T_Null {}                 
                 | T_True {}                 
                 | T_False {}                                  
                 | charliteral {}
                 | stringliteral {}
                 | intliteral {}
                 | floatliteral {};

charliteral:       T_Char {};

stringliteral:     T_String {};
                 
intliteral:        T_Const {};
                            
floatliteral:      T_Float_Const {};
                              
                              
tvars:             tvar               {}
                 | tvar T_Comma tvars {};
                 
protodecs:         /* empty */          {}
                 | protodec protodecs   {};
                 
typeapps:         /* empty */              {}
                 | typeapp typeapps_rest   {};
                 
typeapps_rest:    /* empty */                      {}
                 | T_Comma typeapp typeapps_rest   {};
                 
funprotos:        /* empty */           {}
                 | funproto funprotos   {};
                 
classdecs:        /* empty */           {}
                 | classdec classdecs   {};
                          
types:            /* empty */            {}
                 | ttype types_rest      {};
                 
types_rest:       /* empty */                    {}
                 | T_Comma ttype types_rest      {};
                 
bodydecs:         /* empty */           {}
                 | bodydec bodydecs     {};
                               
                               
localdecs:                                {}
                 | localdecs localdec     {};            

stms:                                   {}                
                 |   stm stms           {};
               
                 
formals:          /* empty */           {}                
                 | formal formals_rest  {};
                 
formals_rest:     /* empty */                  {}
                 | T_Comma formal formals_rest {};
                 
actuals:          /* empty */           {}                                
                 | exp actuals_rest     {};
              
actuals_rest:     /* empty */                   {}                              
                 | T_Comma exp actuals_rest     {};

assignop:          T_Set {};
orop:              T_Or  {};
andop:             T_And {};

relop:             T_Eq    {}
                 | T_Neq   {}
                 | T_Le    {}                 
                 | T_Leq   {}                                  
                 | T_Ge    {}                 
                 | T_Geq   {};
                 
addop:             T_Add    {}
                 | T_Sub    {};
                 
mulop:             T_Mult   {}
                 | T_Div    {};
                            
unop:              T_Not    {}
                 | T_Sub    {};
  
                 
id:                T_Id {};

/*typeid:            id {};*/    

tvar:              T_Var {};

/******************************************************************************/
print_funcs:       T_Printline T_LParen T_RParen T_Semicolon {}
                 | T_Printint T_LParen exp T_RParen T_Semicolon {}
                 | T_Printstring T_LParen exp T_RParen T_Semicolon {}          
                 | T_Printbool T_LParen exp T_RParen T_Semicolon {}             
                 | T_Printfloat T_LParen exp T_RParen T_Semicolon {}
                 | T_Printchar T_LParen exp T_RParen T_Semicolon {};
 

%%

void yyerror (const char * msg)
{
    fprintf(stderr, "Line: %ld Error: %s  \n", lineno, msg);
    exit(1);
}

int main (int argc,char **argv)
{
    extern int yydebug;
    int ret = 0;

    yydebug = 0;    
    
//     int ret = yyparse();  //stdin parsing


//     if (argc != 3)
    if (argc != 2)
    {
        fprintf(stderr, "Usage: %s fileQ24 fileQ24ast\n", argv[0]);      
        return -1;
    }
    else
    {   
        yyin = fopen (argv[1], "r");
        if (!yyin)
        {
            perror ("fopen");
            exit (EXIT_FAILURE);
        }
        else
        {
            ret = yyparse();
            fclose(yyin);
        }
    }

    return ret;
}

