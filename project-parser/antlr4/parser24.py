#!/usr/bin/env python3

from pprint        import pprint
from antlr4        import  *
import antlr4.tree.Trees as t
from quirk24Lexer  import  quirk24Lexer
from quirk24Parser import  quirk24Parser
from quirk24Ast    import  quirk24Ast


def main(argv):
    qrk24   = FileStream(argv[1])
    lexer   = quirk24Lexer(qrk24)
    stream  = CommonTokenStream(lexer)
    parser  = quirk24Parser(stream)
    tree    = parser.program()

    # # prints the generated parser tree, useful for debugging
    #pprint (t.Trees().toStringTree(tree,None,parser))

    ast = ""
    if (parser._syntaxErrors > 0):
        ast = "(illegal)"
    else:
        ast = quirk24Ast().visit(tree)

    # # prints the AST, useful for debugging    
    # pprint (ast)

    with open(argv[2], "w+") as ast_file:
        ast_file.write(ast)

if __name__ == '__main__':
    import sys
    main(sys.argv)
