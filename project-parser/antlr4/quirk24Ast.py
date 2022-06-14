from antlr4 import *                                                             
from quirk24Parser import *                                                   
from quirk24Visitor import *                                                    
from antlr4.tree.Tree import TerminalNodeImpl
from pprint        import pprint

class quirk24Ast(quirk24Visitor):
#class quirk24Ast(ParseTreeVisitor):
    # Override default methods to print the ast
    # Visit a parse tree produced by quirk24Parser#tid.
    def visitTid(self, ctx):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#typeid.
    def visitTypeid(self, ctx):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#tvar.
    def visitTvar(self, ctx):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#program.
    def visitProgram(self, ctx):
        ast  = "(program ("
        ast += self.visit(ctx.getChild(0))
        ast += ") ("
        ast += self.visit(ctx.getChild(1))
        ast += ") "            
        ast += self.visit(ctx.getChild(2))
        ast += ")"
        return ast


    # Visit a parse tree produced by quirk24Parser#protodec.
    def visitProtodec(self, ctx):      
        ast  = "(protoDec " + self.visit(ctx.getChild(1)) + " ("
        ast += self.visit(ctx.getChild(2)) 
        ast += ") ("
        ast += self.visit(ctx.getChild(3)) 
        ast += ") ("        
        ast += self.visit(ctx.getChild(5)) 
        ast += "))"        
        return ast


    # Visit a parse tree produced by quirk24Parser#typevars.
    def visitTypevars(self, ctx):
        ast = ""
        # visit tvars
        if ctx.children != None:
            ast = self.visit(ctx.getChild(1))
        
        return ast


    # Visit a parse tree produced by quirk24Parser#extends.
    def visitExtends(self, ctx):
        ast = ""
        # visit typeapps
        if ctx.children != None:
            ast = self.visit(ctx.getChild(1))
        
        return ast


    # Visit a parse tree produced by quirk24Parser#typeapp.
    def visitTypeapp(self, ctx):
        ast = ""
        n   = ctx.getChildCount()
            # typeid types
        if (n > 1):
            ast  = "(typeApp " + self.visit(ctx.getChild(0)) + " ("
            ast +=  self.visit(ctx.getChild(2)) + "))"
        else: 
            # typeid / tvar
            if isinstance(ctx.getChild(0), quirk24Parser.TypeidContext):
                ast = "(typeApp " + self.visit(ctx.getChild(0)) + " ())"
            else:
                ast = "(tVar "    + self.visit(ctx.getChild(0)) + ")"

        return ast


    # Visit a parse tree produced by quirk24Parser#funproto.
    def visitFunproto(self, ctx):
        # id
        ast  = "(funProto " + self.visit(ctx.getChild(1))
        # tvars 
        ast += " (" + self.visit(ctx.getChild(2)) + ")"
        # formals 
        ast += " (" + self.visit(ctx.getChild(4)) + ")"
        
        # if rtype does not exist, return void
        n = ctx.getChildCount()
        if (n == 7):
            ast += " (void))"
        else:
            ast += self.visit(ctx.getChild(7)) + ")"
        
        return ast


    # Visit a parse tree produced by quirk24Parser#classdec.
    def visitClassdec(self, ctx):
        ast =  "(classDec " + self.visit(ctx.getChild(1))           # id
        ast += " (" + self.visit(ctx.getChild(2)) + ") "            # typevars
        ast += " (" + self.visit(ctx.getChild(4)) + ") "            # typeapps 
        ast += self.visit(ctx.getChild(5))                          # classbody 
        ast += ")"
        return ast

    # Visit a parse tree produced by quirk24Parser#classbody.
    def visitClassbody(self, ctx):
        ast =  self.visit(ctx.getChild(1))                          # init
        ast +=  " (" + self.visit(ctx.getChild(2))  + ")"           # bodydecs
        return ast


    # Visit a parse tree produced by quirk24Parser#init.
    def visitInit(self, ctx):
        ast  =  "(init (" + self.visit(ctx.getChild(1))  + ") "      # formals
        ast +=  self.visit(ctx.getChild(3))              + ")"       # block

        return ast

    # Visit a parse tree produced by quirk24Parser#bodydec.
    def visitBodydec(self, ctx):
        return self.visit(ctx.getChild(0))


    # Visit a parse tree produced by quirk24Parser#constdec.
    def visitConstdec(self, ctx):
        ast  = "(constant "
        ast += self.visit(ctx.getChild(1)) + " "
        ast += self.visit(ctx.getChild(2)) + " "
        ast += self.visit(ctx.getChild(4)) + ")"
        return ast


    # Visit a parse tree produced by quirk24Parser#globaldec.
    def visitGlobaldec(self, ctx):
        ast  = "(static "
        ast += self.visit(ctx.getChild(1)) + " "
        ast += self.visit(ctx.getChild(2)) + " "
        ast += self.visit(ctx.getChild(4)) + ")"
        return ast


    # Visit a parse tree produced by quirk24Parser#fielddec.
    def visitFielddec(self, ctx):
        return "(fieldDec " +  self.visit(ctx.getChild(0)) + ")"


    # Visit a parse tree produced by quirk24Parser#formal.
    def visitFormal(self, ctx):
        ast  = "(formal "
        ast += self.visit(ctx.getChild(0)) + " "                    # type
        ast += self.visit(ctx.getChild(1))                          # id
        ast += ")"
        return ast

    # Visit a parse tree produced by quirk24Parser#fundec.
    def visitFundec(self, ctx):
        # id
        ast  = "(funDec " + self.visit(ctx.getChild(1))
        # tvars 
        ast += " (" + self.visit(ctx.getChild(2)) + ")"
        # formals 
        ast += " (" + self.visit(ctx.getChild(4)) + ")"
        
        # if rtype does not exist, return void and block
        n = ctx.getChildCount()
        if (n == 7):
            ast += " (void) "
            ast += self.visit(ctx.getChild(6)) + ")"
        else:
            ast += self.visit(ctx.getChild(7)) + " "
            ast += self.visit(ctx.getChild(8)) + ")"
        
        return ast
        

    # Visit a parse tree produced by quirk24Parser#block.
    def visitBlock(self, ctx):
        ast  = "(block (" + self.visit(ctx.getChild(1)) + ") "
        ast += "(" + self.visit(ctx.getChild(2)) + "))"
        return ast

    # Visit a parse tree produced by quirk24Parser#localdec.
    def visitLocaldec(self, ctx):
        return self.visit(ctx.getChild(0))


    # Visit a parse tree produced by quirk24Parser#vardec.
    def visitVardec(self, ctx):
        ast  = "(varDec " + self.visit(ctx.getChild(0)) + " "
        ast +=  self.visit(ctx.getChild(1)) + " "      
        ast +=  self.visit(ctx.getChild(3)) + ")"
        return ast


    # Visit a parse tree produced by quirk24Parser#ttype.
    def visitTtype(self, ctx):
        ast = ""
        n = ctx.getChildCount()
        if (n == 1):
            ast = self.visit(ctx.getChild(0))
        elif (n == 3):
            ast = "(arrayOf " + self.visit(ctx.getChild(0)) + ")" 
        else:
            ast  = "(funType (" + self.visit(ctx.getChild(3)) + ") "
            ast += self.visit(ctx.getChild(6)) + ")"
        
        return ast
        

    # Visit a parse tree produced by quirk24Parser#primtype.
    def visitPrimtype(self, ctx):
        return "(" + self.visit(ctx.getChild(0)).strip() + ")"


    # Visit a parse tree produced by quirk24Parser#rtype.
    def visitRtype(self, ctx):
        ast = "(void)"
        if not isinstance(ctx.getChild(0), TerminalNodeImpl):
            ast = self.visit(ctx.getChild(0))

        return ast


    # Visit a parse tree produced by quirk24Parser#stm.
    def visitStm(self, ctx):
        n = ctx.getChildCount()
        ast = ""
        if (n == 1):
            if isinstance(ctx.getChild(0), TerminalNodeImpl):         # ;
                ast = "(skip)"
            else:
                ast = self.visit(ctx.getChild(0))                     # block

        elif (n == 2):
            if isinstance(ctx.getChild(0), TerminalNodeImpl):         # return ;
                ast = "(return0)"
            else:
                ast = "(expStm " + self.visit(ctx.getChild(0)) +")"   # exp;

        elif (n == 3):
                ast = "(return " + self.visit(ctx.getChild(1)) +")"   # ret exp

        elif (n == 5):
            t = self.visit(ctx.getChild(0)).strip()
            if (t == "halt"):                                         # halt
                ast = "(halt " + self.visit(ctx.getChild(2)) + ")"
            else:                                                     # while
                ast  = "(while " + self.visit(ctx.getChild(2)) + " "
                ast += self.visit(ctx.getChild(4)) + ")"

        elif (n == 7):                                                # if
            ast  = "(if "
            ast += self.visit(ctx.getChild(2)) + " "
            ast += self.visit(ctx.getChild(4)) + " "
            ast += self.visit(ctx.getChild(6)) + ")"

        elif (n == 8):                                                # for
            ast  = "(block ("
            ast += self.visit(ctx.getChild(2))
            ast += ") ((while "
            ast += self.visit(ctx.getChild(3))
            ast += "(block () ("
            ast += self.visit(ctx.getChild(7))
            ast += "(expStm "
            ast += self.visit(ctx.getChild(5))
            ast += "))))))"
        else:
            return ## shouldn't be here -- raise ex ?

        return ast


    # Visit a parse tree produced by quirk24Parser#exp.
    def visitExp(self, ctx):
        n = ctx.getChildCount()
        ast = ""
        if (n == 1):
            ast = self.visit(ctx.getChild(0))
        else:
            ast  = "(assign " + self.visit(ctx.getChild(0))
            ast += " " + self.visit(ctx.getChild(2)) + ")"
        
        return ast


    # Visit a parse tree produced by quirk24Parser#lhs.
    def visitLhs(self, ctx):
        n = ctx.getChildCount()
        ast = ""
        if (n == 1):
            ast = self.visit(ctx.getChild(0))
        else:
            ast  = "(binOpn or " + self.visit(ctx.getChild(0))
            ast += " " + self.visit(ctx.getChild(2)) + ")"
        
        return ast

    # Visit a parse tree produced by quirk24Parser#disjunct.
    def visitDisjunct(self, ctx):
        n = ctx.getChildCount()
        ast = ""
        if (n == 1):
            ast = self.visit(ctx.getChild(0))
        else:
            ast  = "(binOpn and " + self.visit(ctx.getChild(0))
            ast += " " + self.visit(ctx.getChild(2)) + ")"
        
        return ast


    # Visit a parse tree produced by quirk24Parser#conjunct.
    def visitConjunct(self, ctx):
        n = ctx.getChildCount()
        ast = ""
        if (n == 1):
            ast = self.visit(ctx.getChild(0))
        else:
            relop = self.visit(ctx.getChild(1)).strip()
            if (relop == "=="):
                relop = "="

            ast   = "(binOpn " + relop + " " + self.visit(ctx.getChild(0))
            ast  += " " + self.visit(ctx.getChild(2)) + ")"
        
        return ast


    # Visit a parse tree produced by quirk24Parser#simple.
    def visitSimple(self, ctx):
        n = ctx.getChildCount()
        ast = ""
        if (n == 1):
            ast = self.visit(ctx.getChild(0))
        else:
            addop = self.visit(ctx.getChild(1)).strip()
            ast   = "(binOpn " + addop + " " + self.visit(ctx.getChild(0))
            ast  += " " + self.visit(ctx.getChild(2)) + ")"
        
        return ast


    # Visit a parse tree produced by quirk24Parser#term.
    def visitTerm(self, ctx):
        ast = ""
        n = ctx.getChildCount()
        if (n == 1):
            ast = self.visit(ctx.getChild(0))
        else:
            mulop = self.visit(ctx.getChild(1)).strip()
            ast   = "(binOpn " + mulop + " " + self.visit(ctx.getChild(0))
            ast  += " " + self.visit(ctx.getChild(2)) + ")"
        
        return ast


    # Visit a parse tree produced by quirk24Parser#factor.
    def visitFactor(self, ctx):
        ast = ""
        if isinstance(ctx.getChild(0), TerminalNodeImpl):
            t = self.visit(ctx.getChild(0)).strip()

            if (t == "!" or t == "-"):
                ast = "(unOpn " + t + " " + self.visit(ctx.getChild(1)) + ")"

            elif (t == "new"):
                tmp = self.visit(ctx.getChild(2)).strip()

                if (tmp == "("):                                    # newObject
                    ast  = "(newObject " + self.visit(ctx.getChild(1)) + " ("
                    ast += self.visit(ctx.getChild(3)) + "))"
                elif (tmp == "<"):                                  # newObject
                    ast  = "(newObject (classApp " + self.visit(ctx.getChild(1))
                    ast += " (" + self.visit(ctx.getChild(3)) + ")) "
                    ast += "(" + self.visit(ctx.getChild(6)) + "))"
                elif (tmp == "["):                                  # newArray
                    ast  = "(newArray " + self.visit(ctx.getChild(1)) + " "
                    ast +=  self.visit(ctx.getChild(3)) + ")"
                else:
                    return ## shouldn't reach here

            elif (t == "lambda"):
                if isinstance(ctx.getChild(4), TerminalNodeImpl):   # has rtype
                    ast  = "(lambda (" + self.visit(ctx.getChild(2)) + ") "
                    ast += self.visit(ctx.getChild(5)) + " "
                    ast += self.visit(ctx.getChild(6)) + ")"
                else:                                               # no rtype
                    ast  = "(lambda (" + self.visit(ctx.getChild(2)) + ") "
                    ast += "(void) "
                    ast += self.visit(ctx.getChild(4)) + ")"

            elif (t == "("):                                        # exp
                    ast = self.visit(ctx.getChild(1))

            else:
                return ## shouldn't reach here

        else:                                                       # non-terms
            if isinstance(ctx.getChild(0), quirk24Parser.LiteralContext):
                ast = self.visit(ctx.getChild(0))                   # literal
            elif isinstance(ctx.getChild(0), quirk24Parser.TidContext):
                ast = self.visit(ctx.getChild(0))                   # id
            else:
                return ## shouldn't reach here

        # check if there is a factor_rest
        n    = ctx.getChildCount()
        idx  = 0
        flag = False
        for i in range (0, n):
            if isinstance(ctx.getChild(i), quirk24Parser.Factor_restContext):
                idx  = i
                flag = True
                break

        if (flag == True):
            for i in range (idx, n):
                # Get the first terminal of the factor_rest node
                t = self.visit(ctx.getChild(i).getChild(0)).strip()

                if (t == "("):
                    tmp  = "(call " + ast + " ("
                    tmp += self.visit(ctx.getChild(i).getChild(1)) + "))"
                    ast  = tmp
                elif (t == "."):
                    tmp  = "(dot " + ast + " "
                    tmp += self.visit(ctx.getChild(i).getChild(1)) + ")"
                    ast  = tmp
                elif (t == "["):
                    tmp  = "(aref " + ast + " "
                    tmp += self.visit(ctx.getChild(i).getChild(1)) + ")"
                    ast  = tmp
                else:
                    return ## shouldn't reach here

        return ast



    # Visit a parse tree produced by quirk24Parser#factor_rest.
    def visitFactor_rest(self, ctx):
        #return ""
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#literal.
    def visitLiteral(self, ctx):
        # terminals: null, true, false
        if isinstance(ctx.getChild(0), TerminalNodeImpl):
            ast = "(" +  self.visit(ctx.getChild(0)).strip() + ")"
        else:
            ast = self.visit(ctx.getChild(0))

        return ast


    # Visit a parse tree produced by quirk24Parser#charliteral.
    def visitCharliteral(self, ctx):
        return "(charLiteral #\\" + self.visitChildren(ctx)[1] + ")"


    # Visit a parse tree produced by quirk24Parser#stringliteral.
    def visitStringliteral(self, ctx):
        return "(stringLiteral " +  self.visitChildren(ctx) + ")"


    # Visit a parse tree produced by quirk24Parser#intliteral.
    def visitIntliteral(self, ctx):
        return "(intLiteral " +  self.visitChildren(ctx) + ")"


    # Visit a parse tree produced by quirk24Parser#floatliteral.
    def visitFloatliteral(self, ctx):
        return "(floatLiteral " +  self.visitChildren(ctx) + ")"


    # Visit a parse tree produced by quirk24Parser#tvars.
    def visitTvars(self, ctx):
        ast = self.visit(ctx.getChild(0))  
        n   = ctx.getChildCount()
        if (n > 1):
            ast += " " + self.visit(ctx.getChild(2))

        return ast


    # Visit a parse tree produced by quirk24Parser#protodecs.
    def visitProtodecs(self, ctx):
        ast = ""
        if ctx.children != None:
            n = ctx.getChildCount()
            ast = self.visit(ctx.getChild(0))
            for i in range(1, n):
                ast += " " + self.visit(ctx.getChild(i)) 

        return ast


    # Visit a parse tree produced by quirk24Parser#typeapps.
    def visitTypeapps(self, ctx):
        ast = ""
        if ctx.children != None:
            n = ctx.getChildCount()
            ast = self.visit(ctx.getChild(0))
            # implies n > 1 
            for i in range(2, n, 2):
                ast += " " + self.visit(ctx.getChild(i))

        return ast


    # Visit a parse tree produced by quirk24Parser#funprotos.
    def visitFunprotos(self, ctx):
        ast = ""
        if ctx.children != None:
            n = ctx.getChildCount()
            ast = self.visit(ctx.getChild(0))
            for i in range(1, n):
                ast += " " + self.visit(ctx.getChild(i)) 

        return ast


    # Visit a parse tree produced by quirk24Parser#classdecs.
    def visitClassdecs(self, ctx):
        ast = ""
        if ctx.children != None:
            n = ctx.getChildCount()
            ast = self.visit(ctx.getChild(0))
            for i in range(1, n):
                ast += " " + self.visit(ctx.getChild(i)) 

        return ast


    # Visit a parse tree produced by quirk24Parser#types.
    def visitTypes(self, ctx):
        ast = ""
        if ctx.children != None:
            n = ctx.getChildCount()
            ast = self.visit(ctx.getChild(0))
            # implies n > 1 
            for i in range(2, n, 2):
                ast += " " + self.visit(ctx.getChild(i))
        
        return ast


    # Visit a parse tree produced by quirk24Parser#bodydecs.
    def visitBodydecs(self, ctx):
        ast = ""
        if ctx.children != None:
            n = ctx.getChildCount()
            ast = self.visit(ctx.getChild(0))
            for i in range(1, n):
                ast += " " + self.visit(ctx.getChild(i)) 

        return ast


    # Visit a parse tree produced by quirk24Parser#localdecs.
    def visitLocaldecs(self, ctx):
        ast = ""
        if ctx.children != None:
            n = ctx.getChildCount()
            ast = self.visit(ctx.getChild(0))
            for i in range(1, n):
                ast += " " + self.visit(ctx.getChild(i)) 

        return ast


    # Visit a parse tree produced by quirk24Parser#stms.
    def visitStms(self, ctx):
        ast = ""
        if ctx.children != None:
            n = ctx.getChildCount()
            ast = self.visit(ctx.getChild(0))
            for i in range(1, n):
                ast += " " + self.visit(ctx.getChild(i)) 

        return ast


    # Visit a parse tree produced by quirk24Parser#formals.
    def visitFormals(self, ctx):
        ast = ""
        if ctx.children != None:
            n = ctx.getChildCount()
            ast = self.visit(ctx.getChild(0))
            # implies n > 1 
            for i in range(2, n, 2):
                ast += " " + self.visit(ctx.getChild(i))

        return ast


    # Visit a parse tree produced by quirk24Parser#actuals.
    def visitActuals(self, ctx):
        ast = ""
        if ctx.children != None:
            n = ctx.getChildCount()
            ast = self.visit(ctx.getChild(0))
            # implies n > 1 
            for i in range(2, n, 2):
                ast += " " + self.visit(ctx.getChild(i))

        return ast

    
    # visit a parse tree terminal node
    def visitTerminal(self, node):
        return (node.getText() + " ")


    ## by default we return the empty string
    #def defaultResult(self):
        #pprint ("DEFAULT")
        #return ""

    ## aggregate
    #def aggregateResult(self, aggregate, nextResult):
        #return aggregate + nextResult

