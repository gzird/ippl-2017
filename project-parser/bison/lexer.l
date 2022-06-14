%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "parser.hpp"

#define T_Eof      0

long int lineno = 1;
%}


%option nounput
%option noinput
%option noyywrap

digit  [0-9]
lcltr  [a-z]
ucltr  [A-Z]
idchar [a-zA-Z0-9_]
white  [ \r]
printable [a-zA-Z0-9_ !\#$%&()*+,\-./:;<=>?@\[\]^{}~]
exponent e(\+|\-)?{digit}+

%%

"protocol"    {return T_Protocol;}
"extends"     {return T_Extends;}
"fun"         {return T_Fun;}
"class"       {return T_Class;}
"implements"  {return T_Implements;}
"constant"    {return T_Constant;}
"static"      {return T_Static;}
"function"    {return T_Function;}
"bool"        {return T_Bool;}
"char"        {return T_PTChar;}
"string"      {return T_PTString;}
"int"         {return T_Int;}
"float"       {return T_Float;}
"void"        {return T_Void;}    
"if"          {return T_If;}      
"else"        {return T_Else;}        
"while"       {return T_While;}      
"for"         {return T_For;}     
"return"      {return T_Return;}      
"halt"        {return T_Halt;}      
"new"         {return T_New;}        
"lambda"      {return T_Lambda;}
"null"        {return T_Null;}
"true"        {return T_True;}          
"false"       {return T_False;}

"printLine"   {return T_Printline;}
"printBool"   {return T_Printbool;}
"printChar"   {return T_Printchar;}
"printString" {return T_Printstring;}
"printInt"    {return T_Printint;}
"printFloat"  {return T_Printfloat;}


\'{printable}\'                 { yylval.c = yytext[1]; return T_Char; }

\"([^\"\n]|{printable}*)\"      { yylval.s = strdup(yytext+1);             
                                  yylval.s[strlen(yylval.s)-1] = '\0';
                                  return T_String; }

({lcltr})({idchar})*            { yylval.s = strdup(yytext);
                                  return T_Id; }

({ucltr})({idchar})*            { yylval.s = strdup(yytext);               
                                  return T_Var; }

({digit}+\.{digit}+|{digit}+\.|\.{digit}+){1}(exponent)? {
                                    /* should read floats as strings */
                                     sscanf(yytext, "%f", &yylval.f);      
                                    //    yylval.f = strdup(yytext);
                                        return T_Float_Const; 
                                    }                      
                                
{digit}+                        { yylval.i = atol(yytext); return T_Const; }


                                    
                                    

"->"       {return T_Arrow;}
"="        {return T_Set;}

"||"       {return T_Or;}
"&&"       {return T_And;}

"=="       {return T_Eq;}
"!="       {return T_Neq;}
"<"        {return T_Le;}
"<="       {return T_Leq;}
">"        {return T_Ge;}
">="       {return T_Geq;}

"+"        {return T_Add;}
"-"        {return T_Sub;}
 
"*"        {return T_Mult;}
"/"        {return T_Div;}

"!"        {return T_Not;}  
  
";"        {return T_Semicolon;}
":"        {return T_Colon;}
","        {return T_Comma;}
"("        {return T_LParen;}
")"        {return T_RParen;}
"["        {return T_LSq_Bracket;}
"]"        {return T_RSq_Bracket;}
"{"        {return T_LCur_Bracket;}
"}"        {return T_RCur_Bracket;}

"."        {return T_Dot;}


\/\/.*                       { /* single line comment */ }
{white}+                     { /* whitespace */ }
\n                           { lineno++; }
<<EOF>>                      { return T_Eof; }
.                            { fprintf(stderr, "Line %ld: Lexical error. \
                                                Unknown character.\n",   
                                                lineno); 
                                                exit(1); }

%%
