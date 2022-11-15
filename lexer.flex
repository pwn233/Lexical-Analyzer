import java.util.*;
%%
%class Lexer
%public
%unicode
%standalone

%{
    List<String> symTable = new ArrayList<String>();
%}



LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace = {LineTerminator} | [ \t\f]
Comment = {TraditionalComment} | {EndOfLineComment}
TraditionalComment = "/*" [^*] ~"*/" | "/*" "*"+ "/"
EndOfLineComment = "//" {InputCharacter}* {LineTerminator}?
Identifier = [a-zA-Z][a-zA-Z0-9]*
ZERO = [-]?0
INT0 = [-]?[1-9][0-9]*
ZeroValid = [0][0-9]+
DecIntegerLiteral = {ZERO} | {INT0}
Exponent = [eE]{DecIntegerLiteral}
Float1 = [0-9]+ \.[0-9]+ {Exponent}?
Float2 = \. [0-9]+{Exponent}?
Float3 = [0-9]+ \.{Exponent}?
Float4 = [0-9]+{Exponent}
FloatingPoint = ( {Float1} | {Float2} | {Float3} | {Float4} ) [fFdD]? | [0-9]+ [fFDd]
ThaiUni = [¡-û]+
InValidate = {FloatingPoint} | {ThaiUni} | {ZeroValid}
Passing = {Comment} | {WhiteSpace}
%%

<YYINITIAL>{

    {InValidate}
    {
        System.err.println("ERROR: "+yytext());
        System.exit(0);
    }

    "+"|"-"|"*"|"/"|"%"|"&"|"&&"|"!"|"~"|"^"|"="|">"|">="|"<"|"<="|"=="|"!="|"++"|"--"|"|"|"||"      
    {
    System.out.println("OPERATOR: "+yytext());
    }

    "("|")"|";"
    {
        if(yytext().equals(";"))
            System.out.println("SEMICOLON: ;");
        else
            System.out.println("PARENTHESE: "+yytext());
    }

    "if"|"then"|"else"|"endif"|"while"|"do"|"endwhile"|"print"|"newline"|"read"
    {
        System.out.println("KEYWORDS: "+yytext());
    }

    {DecIntegerLiteral}
    {
        System.out.println("INTEGER: "+yytext());
    }

    {Identifier}
    {
        String newIden = yytext();
        if(symTable.isEmpty()) {
            System.out.println("NEW IDENTIFIER: "+newIden);
            symTable.add(newIden);
        } else {
            if(symTable.contains(newIden))   {
                System.err.println("identifier \""+newIden+"\" already in symbol table");
            } else {
                System.out.println("NEW IDENTIFIER: "+newIden);
                symTable.add(newIden);
            }
        }
    }

    \"{InputCharacter}*\"
    {
         System.out.println("String: "+yytext());
    }

    {Passing}
    { }

    [^]                              
    { 
        System.err.println("ERROR : "+yytext()); 
        System.exit(0);
    }
}