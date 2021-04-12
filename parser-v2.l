%{
int yylineno;
%}

alpha [A-Za-z]
digit [0-9]

%%
[ \t] ;
\n	          { yylineno++; }
"{"	          { scope_start(); return '{'; }
"}"	          { scope_end(); return '}'; }
";"	          { return(';'); }
","	          { return(','); }
":"	          { return(':'); }
"="	          { return('='); }
"("	          { return('('); }
")"	          { return(')'); }
("[") 	      { return('['); }
("]")         { return(']'); }
"."	          { return('.'); }
"&"	          { return('&'); }
"!"	          { return('!'); }
"~"	          { return('~'); }
"-"	          { return('-'); }
"+"	          { return('+'); }
"*"	          { return('*'); }
"/"	          { return('/'); }
"%"	          { return('%'); }
"<"	          { return('<'); }
">"	          { return('>'); }
"^"	          { return('^'); }
"|"	          { return('|'); }
"?"	          { return('?'); }

int	              { yylval.ival = INT; return INT; }
float	            { yylval.ival = FLOAT; return FLOAT; }
fn                { yylval.ival = FN; return FN; }

if	              { return IF; }
else	            { return ELSE; }
while	            { return WHILE; }
loop              { return LOOP; }
for	              { return FOR; }
in                { return IN; }
".."              { return RANGE; }

return 	          { return RETURN; }
^"use ".+	        { return IMPORT; }
println!	          { return PRINT; }

{alpha}({alpha}|{digit})*     { yylval.str=strdup(yytext); return ID; }
{digit}+	                    { yylval.str=strdup(yytext); return NUM; }
{digit}+\.{digit}+ 	          { yylval.str=strdup(yytext); return REAL; }

"<="		          { return LE; }
">="		          { return GE; }
"=="		          { return EQ; }
"!="		          { return NEQ; }
"&&"		          { return AND; }
"||"		          { return OR; }
\/\/.* ;
\/\*(.*\n)*.*\*\/ ;

\".*\"	          { return STRING; }
.	                { return yytext[0]; }
%%
