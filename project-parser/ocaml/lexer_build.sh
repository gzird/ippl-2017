#!/bin/bash
set -v 

rm -f Lexer.ml Parser.ml *.{mli,cmi,cmo} parser24


ocamlc -i Error.ml > Error.mli
ocamlc -c Error.mli
ocamlc -c Error.ml


ocamlc -i Helper.ml > Helper.mli
ocamlc -c Helper.mli
ocamlc -c Helper.ml

ocamllex -o Lexer.ml Lexer.mll
ocamlyacc -v Parser.mly 

ocamlc -c Parser.mli

ocamlc -i Lexer.ml > Lexer.mli
ocamlc -c Lexer.mli
ocamlc -c Lexer.ml

ocamlc -c Parser.ml

ocamlc -o parser24 Error.cmo Helper.cmo Lexer.cmo Parser.cmo 
