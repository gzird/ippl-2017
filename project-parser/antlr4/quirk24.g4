grammar quirk24;

/* First define the lexer rules for these literals (all lexer rules in Caps).
 * Remaining lexer rules are at the bottom.
 */
TID:              LCLTR IDCHAR*;
TVAR:             UCLTR IDCHAR*;
NUM:              DIGIT+;
EXPONENT:         'e'('+'|'-')?DIGIT+;
FLOAT:            (DIGIT+'.'EXPONENT? | '.'DIGIT+EXPONENT? | 
                   DIGIT+'.'DIGIT+EXPONENT?);

tid:              TID;                  
typeid:           TID;                  
tvar:             TVAR;

/*
 * Parser Rules.
 * Rewrite the rules can be empty inorder to work with antlr4.
 */

program:          protodecs classdecs stm EOF;
                 
protodec:        'protocol' typeid typevars extends '{' funprotos '}';
                
typevars:        ('<' tvars '>')?;

extends:         ('extends' typeapps)?;

typeapp:           typeid
                 | typeid '<' types '>'
                 | tvar                   
                 ;  
                 
funproto:          'fun' tid typevars '(' formals ')' ';'
                 | 'fun' tid typevars '(' formals ')' ':' rtype ';' 
                 ;
                   
classdec:          'class' tid typevars 'implements' typeapps classbody ;

classbody     :  '{' init bodydecs '}';

init          :  '(' formals ')' block;

bodydec:           constdec 
                 | globaldec 
                 | fielddec  
                 | fundec    
                 ;
                 
constdec:          'constant' primtype tid '=' literal ';' ;

globaldec:         'static'   primtype tid '=' literal ';' ;
        
fielddec:          formal ';' ;

formal:            ttype tid ;

fundec:            'fun' tid typevars '(' formals ')' block 
                 | 'fun' tid typevars '(' formals ')' ':' rtype block 
                 ;
                   
block:             '{' localdecs stms '}' ;

localdec:          vardec 
                 | fundec 
                 ;
                 
vardec:            ttype tid '=' exp ';' ;

ttype:             primtype 
                 | typeapp 
                 | ttype '[' ']' 
                 | 'function' '(' '(' types ')' '->' rtype ')' 
                 ;          
       
                   
primtype:          'bool'     
                 | 'char'   
                 | 'string' 
                 | 'int'      
                 | 'float'    
                 ;
                 
rtype:             ttype 
                 | 'void' ;
                 

stm:               ';' 
                 | exp ';'
                 | 'if' '(' exp ')' stm 'else' stm 
                 | 'while' '(' exp ')' stm
                 | 'for' '(' vardec exp ';' exp ')' stm 
                 | 'return' ';'
                 | 'return' exp ';'
                 | block 
                 | 'halt' '(' exp ')' ';'
                 ;

exp:               lhs ASSIGNOP exp
                 | lhs
                 ;
                             
lhs:               disjunct OROP lhs
                 | disjunct
                 ;
               
disjunct:          conjunct ANDOP disjunct
                 | conjunct
                 ;

                   /* hardcode '>', '<' to avoid confusion with <types> */
conjunct:          simple (RELOP | '<' | '>') simple
                 | simple
                 ;

                   /* hardcode the op to avoid confusion with Uminus */
simple:            simple ('+'|'-') term
                 | term
                 ;
                 
term:              term MULOP factor
/* term:              term ('*'|'/') factor */
                 | factor
                 ;

                   /* UMINUS has the higher order so hardcode it here */ 
factor:            ('!' | '-') factor
                 | literal factor_rest*
                 | 'new' tid '(' actuals ')' factor_rest*
                 | 'new' tid '<' types '>' '(' actuals ')' factor_rest*
                 | 'new' ttype '[' exp ']' factor_rest*
                 | 'lambda' '(' formals ')' block factor_rest*
                 | 'lambda' '(' formals ')' ':' rtype block factor_rest*
                 | '(' exp ')' factor_rest*
                 | tid factor_rest*
                 ;
                 
factor_rest:       '(' actuals ')'
                 | '.' tid
                 | '[' exp ']'
                 ;


literal:           'null'                 
                 | 'true'
                 | 'false'
                 | charliteral
                 | stringliteral
                 | intliteral
                 | floatliteral
                 ;

charliteral:      CHAR;
stringliteral:    STRING;
intliteral:       NUM;
floatliteral:     FLOAT;

tvars:             tvar     
                 | tvar ',' tvars
                 ;

/* rewrite rules that allow empty using regular expressions */
protodecs:       (protodec)*;

typeapps:        typeapp? | typeapp (',' typeapp)+ ;

funprotos:       (funproto)*;
                 
classdecs:       (classdec)*;
                         
types:           ttype? | ttype (',' ttype)+ ;
                
bodydecs:        (bodydec)*;
                            
localdecs:       (localdec)*;            

stms:            (stm)*;
                             
formals:         formal? | formal (',' formal)+ ;
                
actuals:         exp? | exp (',' exp)+ ;


/*
 * Lexer Rules
 */

ASSIGNOP:          '='  ;
OROP:              '||' ;
ANDOP:             '&&' ;

RELOP:             '=='
                 | '!='
                 | '<='
                 | '>='
                 ;

MULOP:             '*'
                 | '/'
                 ;
                 
/* Basic building blocks for regular expressions */
DIGIT              : [0-9];
LCLTR              : [a-z];
UCLTR              : [A-Z];
IDCHAR             : (LCLTR | UCLTR | DIGIT | '_');

PRINTABLE           : ([0-9] | [a-z] | [A-Z] | '_' 
    |  '!'  |  '#'  |  '$'  |  '%'  |  '&'  |  '('  |  ')'
    |  '*'  |  '+'  |  ','  |  '-'  |  '.'  |  '/'  |  ':'  |  ';'  |  '<'
    |  '='  |  '>'  |  '?'  |  '@'  |  '['  |  ']'  |  '^'  |  '{'  |  '}'
    |  '~');
CHAR                : '\'' (' '|PRINTABLE) '\'';
STRING              : '"'  (' '|PRINTABLE+)* '"';  

/* single line comments */
COMMENT             : '//' ~([\n])* -> skip;
WHITE               : [ \r\n]+      -> skip;
