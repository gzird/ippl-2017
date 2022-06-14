#!/bin/bash

set -v 
# set -e

rm -f Lexer.ml Parser.ml *.{mli,cmi,cmo} parser24

ocamlc -i Ast.ml > Ast.mli
ocamlc -c Ast.mli
ocamlc -c Ast.ml

ocamlc -i Astprint.ml > Astprint.mli
ocamlc -c Astprint.mli
ocamlc -c Astprint.ml

ocamlc -i Error.ml > Error.mli
ocamlc -c Error.mli
ocamlc -c Error.ml

ocamlc -i Helper.ml > Helper.mli
ocamlc -c Helper.mli
ocamlc -c Helper.ml

ocamllex -o Lexer.ml Lexer.mll

## 
## There are two parser generators for OCaml: ocamlyacc and menhir.
##
ocamlyacc -v Parser.mly
# menhir -v Parser.mly 

ocamlc -c Parser.mli

ocamlc -i Lexer.ml > Lexer.mli
ocamlc -c Lexer.mli
ocamlc -c Lexer.ml

ocamlc -c Parser.ml
ocamlc -c Main.ml

ocamlc -o parser24 Ast.cmo Astprint.cmo Error.cmo Helper.cmo Lexer.cmo \
                   Parser.cmo Main.cmo 
