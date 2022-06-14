# Generated from quirk24.g4 by ANTLR 4.6
from antlr4 import *
if __name__ is not None and "." in __name__:
    from .quirk24Parser import quirk24Parser
else:
    from quirk24Parser import quirk24Parser

# This class defines a complete generic visitor for a parse tree produced by quirk24Parser.

class quirk24Visitor(ParseTreeVisitor):

    # Visit a parse tree produced by quirk24Parser#tid.
    def visitTid(self, ctx:quirk24Parser.TidContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#typeid.
    def visitTypeid(self, ctx:quirk24Parser.TypeidContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#tvar.
    def visitTvar(self, ctx:quirk24Parser.TvarContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#program.
    def visitProgram(self, ctx:quirk24Parser.ProgramContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#protodec.
    def visitProtodec(self, ctx:quirk24Parser.ProtodecContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#typevars.
    def visitTypevars(self, ctx:quirk24Parser.TypevarsContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#extends.
    def visitExtends(self, ctx:quirk24Parser.ExtendsContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#typeapp.
    def visitTypeapp(self, ctx:quirk24Parser.TypeappContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#funproto.
    def visitFunproto(self, ctx:quirk24Parser.FunprotoContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#classdec.
    def visitClassdec(self, ctx:quirk24Parser.ClassdecContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#classbody.
    def visitClassbody(self, ctx:quirk24Parser.ClassbodyContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#init.
    def visitInit(self, ctx:quirk24Parser.InitContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#bodydec.
    def visitBodydec(self, ctx:quirk24Parser.BodydecContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#constdec.
    def visitConstdec(self, ctx:quirk24Parser.ConstdecContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#globaldec.
    def visitGlobaldec(self, ctx:quirk24Parser.GlobaldecContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#fielddec.
    def visitFielddec(self, ctx:quirk24Parser.FielddecContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#formal.
    def visitFormal(self, ctx:quirk24Parser.FormalContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#fundec.
    def visitFundec(self, ctx:quirk24Parser.FundecContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#block.
    def visitBlock(self, ctx:quirk24Parser.BlockContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#localdec.
    def visitLocaldec(self, ctx:quirk24Parser.LocaldecContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#vardec.
    def visitVardec(self, ctx:quirk24Parser.VardecContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#ttype.
    def visitTtype(self, ctx:quirk24Parser.TtypeContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#primtype.
    def visitPrimtype(self, ctx:quirk24Parser.PrimtypeContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#rtype.
    def visitRtype(self, ctx:quirk24Parser.RtypeContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#stm.
    def visitStm(self, ctx:quirk24Parser.StmContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#exp.
    def visitExp(self, ctx:quirk24Parser.ExpContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#lhs.
    def visitLhs(self, ctx:quirk24Parser.LhsContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#disjunct.
    def visitDisjunct(self, ctx:quirk24Parser.DisjunctContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#conjunct.
    def visitConjunct(self, ctx:quirk24Parser.ConjunctContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#simple.
    def visitSimple(self, ctx:quirk24Parser.SimpleContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#term.
    def visitTerm(self, ctx:quirk24Parser.TermContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#factor.
    def visitFactor(self, ctx:quirk24Parser.FactorContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#factor_rest.
    def visitFactor_rest(self, ctx:quirk24Parser.Factor_restContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#literal.
    def visitLiteral(self, ctx:quirk24Parser.LiteralContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#charliteral.
    def visitCharliteral(self, ctx:quirk24Parser.CharliteralContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#stringliteral.
    def visitStringliteral(self, ctx:quirk24Parser.StringliteralContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#intliteral.
    def visitIntliteral(self, ctx:quirk24Parser.IntliteralContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#floatliteral.
    def visitFloatliteral(self, ctx:quirk24Parser.FloatliteralContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#tvars.
    def visitTvars(self, ctx:quirk24Parser.TvarsContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#protodecs.
    def visitProtodecs(self, ctx:quirk24Parser.ProtodecsContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#typeapps.
    def visitTypeapps(self, ctx:quirk24Parser.TypeappsContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#funprotos.
    def visitFunprotos(self, ctx:quirk24Parser.FunprotosContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#classdecs.
    def visitClassdecs(self, ctx:quirk24Parser.ClassdecsContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#types.
    def visitTypes(self, ctx:quirk24Parser.TypesContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#bodydecs.
    def visitBodydecs(self, ctx:quirk24Parser.BodydecsContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#localdecs.
    def visitLocaldecs(self, ctx:quirk24Parser.LocaldecsContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#stms.
    def visitStms(self, ctx:quirk24Parser.StmsContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#formals.
    def visitFormals(self, ctx:quirk24Parser.FormalsContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by quirk24Parser#actuals.
    def visitActuals(self, ctx:quirk24Parser.ActualsContext):
        return self.visitChildren(ctx)



del quirk24Parser