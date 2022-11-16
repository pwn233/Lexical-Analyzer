import java.util.*;
%%
%class Lexer
%public
%unicode
%standalone

%{
    List<String> symTable = new ArrayList<String>();
%}
/* in case you want to create parameter(s).*/


LineTerminator = \r|\n|\r\n
/* \r = ? , \n = ? and \r\n = Windows*/

InputCharacter = [^\r\n]
/* contains string ^somethingbehind = exception of something behind.*/

WhiteSpace = {LineTerminator} | [ \t\f]
/* contains LineTerminator, \t = tab and \f Feed Form(for starting in next page) */

Comment = {TraditionalComment} | {EndOfLineComment}
/* contains Traditional Comment, EndOfLineComment*/

TraditionalComment = "/*" [^*] ~"*/" | "/*" "*"+ "/"
// contains /* something except*/  and /*= 1-n*/ 

EndOfLineComment = "//" {InputCharacter}* {LineTerminator}?
/* contains //something behind(as much as you want) end by LineTerminator.*/

Identifier = [a-zA-Z][a-zA-Z0-9]*
/* start with alphabet(s) (and can be after by alphanumeric characters wether or not). */

Operator = "+"|"-"|"*"|"/"|"%"|"&"|"&&"|"!"|"~"|"^"|"="|">"|">="|"<"|"<="|"=="|"!="|"++"|"--"|"|"|"||"
/* contains operator for logical and arithmetic.*/

Keywords = "if"|"then"|"else"|"endif"|"while"|"do"|"endwhile"|"print"|"newline"|"read"
/* contain keywords.*/

ParenthesisAndSemiColon = "("|")"|";"
/* contains parenthesis and semicolon*/

ZERO = [-]?0
/* contains both normal zero and negative zero(for unexpected case).*/

INT0 = [-]?[1-9][0-9]*
/* contains both positive integer and negative interger (that can be after by bunch of integers.)*/

ZeroValid = [0][0-9]+
/* contains integers that start with zero*/

DecIntegerLiteral = {ZERO} | {INT0}
/* contains zero, postive integer and negative integer.*/

Exponent = [eE]{DecIntegerLiteral}
/* contains e integers and E integers*/

/* \. made for dot readable.*/
/* x stand for integer*/
Float1 = [0-9]* \.[0-9]* {Exponent}?
/*  example :  2.17, 2.17e5, 2.e5(impossible) */
/*  case 1  : [0-9]+ /.[0-9]+ {Exponent}?
    case 2  : /. [0-9]+{Exponent}?
    case 3  : [0-9]+ /.{Exponent}?
*/
Float2 = [0-9]+{Exponent}
/* contains integer with tag e.*/
FloatingPoint = ( {Float1} | {Float2} ) [fFdD]? | [0-9]+ [fFDd]
/* contains all Float Expressions.*/

ThaiUni = [¡-û]+
/* contains all Thai characters.*/

InValidate = {FloatingPoint} | {ThaiUni} | {ZeroValid}
/* contains all invalid case by FloatingPoint, ThaiUni, ZeroValid*/

Passing = {Comment} | {WhiteSpace}
/* contains Comment and WhiteSpace*/

%%

/* one of the rules to create*/
<YYINITIAL>{
    /* Experssion : error */
    {InValidate}
    {
        System.err.println("ERROR: "+yytext());
        System.exit(0);
    }

    /* Experssion : Logical Operator and Arithmetic Operators*/
    {Operator}   
    {
    System.out.println("OPERATOR: "+yytext());
    }

    /* Expression : Parenthesis and Semi Colon*/
    {ParenthesisAndSemiColon}
    {
        if(yytext().equals(";"))
            System.out.println("SEMICOLON: ;");
        else
            System.out.println("PARENTHESE: "+yytext());
    }
    
    /* Expression : Keywords*/
    {Keywords}
    {
        System.out.println("KEYWORDS: "+yytext());
    }

    /* Expression : Zero, Positive Integer and Negative Integer*/
    {DecIntegerLiteral}
    {
        System.out.println("INTEGER: "+yytext());
    }

    /* Expression : Identifier*/
    {Identifier}
    {
        String newIden = yytext();
        /* first */
        if(symTable.isEmpty()) {
            System.out.println("NEW IDENTIFIER: "+newIden);
            symTable.add(newIden);
        } else {
            /* check wether it duplicates or not*/
            if(symTable.contains(newIden))   {
                System.err.println("identifier \""+newIden+"\" already in symbol table");
            } else {
                System.out.println("NEW IDENTIFIER: "+newIden);
                symTable.add(newIden);
            }
        }
    }

    /* Expression : String*/
    \"{InputCharacter}*\"
    {
         System.out.println("String: "+yytext());
    }
    /* Expression : Passing (Comment and WhiteSpace)*/
    {Passing}
    { }

    /* Expression : error for any other exception*/
    /* warning : cut by first character*/
    [^]                              
    { 
        System.err.println("ERROR : "+yytext()); 
        System.exit(0);
    }
}