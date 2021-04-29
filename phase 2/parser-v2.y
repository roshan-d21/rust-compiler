%{
#include <stdio.h>
#include <stdlib.h>
#include "symbolTable.c"

int g_addr = 100;
int i = 1, lnum1 = 0;
int stack[100],
    index1 = 0,
    end[100],
    arr[10],
    ct, c, b, fl, top=0, fortop = 0,
    label[20], label_num = 0, ltop = 0;

char st1[100][10];
char forvar[100][10];
char temp_count[2] = "0";
int plist[100], flist[100], k = -1, errc = 0, j = 0;
char temp[2]= "t";
char null[2]= " ";

void yyerror(char *s);
int printline();
extern int yylineno;

void print_error()
{
    printf("\033[1;31mError: \033[0m");
}

void print_label()
{
    printf("\033[0;36m");
}

void print_reset()
{
    printf("\033[0m");
}

void scope_start()
{
	stack[index1] = i;
	i++;
	index1++;
	return;
}

void scope_end()
{
	index1--;
	end[stack[index1]] = 1;
	stack[index1] = 0;
	return;
}
void if1()
{
	label_num++;
	strcpy(temp,"t");
	strcat(temp, temp_count);
	printf("\n%s = not %s\n", temp, st1[top]);
 	printf("if %s ", temp);
    print_label();
    printf("goto L%d\n", label_num);
    print_reset();
	temp_count[0]++;
	label[++ltop]=label_num;
}

void if2()
{
	label_num++;
    print_label();
	printf("\ngoto L%d\n", label_num);
	printf("L%d: \n", label[ltop--]);
    print_reset();
	label[++ltop] = label_num;
}

void if3()
{
    print_label();
	printf("\nL%d:\n", label[ltop--]);
    print_reset();
}

void loop1()
{
    label_num++;
    label[++ltop] = label_num;
    print_label();
	printf("\nL%d:\n", label_num);
    print_reset();
}

void loop2()
{
    print_label();
	printf("\ngoto L%d\n", label[ltop--]);
    print_reset();
}

void while1()
{
	label_num++;
	label[++ltop] = label_num;
    print_label();
	printf("\nL%d:\n", label_num);
    print_reset();
}

void while2()
{
	label_num++;
	strcpy(temp, "t");
	strcat(temp, temp_count);
	printf("%s = not %s\n", temp, st1[top--]);
 	printf("\nif %s ", temp);
    print_label();
    printf("goto L%d\n", label_num);
    print_reset();
	temp_count[0]++;
	label[++ltop] = label_num;
}

void while3()
{
	int y = label[ltop--];
    print_label();
	printf("\ngoto L%d\n", label[ltop--]);
	printf("\nL%d:\n",y);
    print_reset();
}

void forin()
{
    printf("\n%s = %s\n", st1[top - 2], st1[top - 1]);
    strcpy(forvar[++fortop], st1[top - 2]);

    label_num++;
	label[++ltop] = label_num;
    print_label();
	printf("\nL%d:\n", label_num);
    print_reset();

    printf("\nt%s = %s < %s\n", temp_count, st1[top - 2], st1[top]);
	temp_count[0]++;
    top -= 2;

    label_num++;
	strcpy(temp, "t");
	strcat(temp, temp_count);
	printf("%s = not %s\n", temp, st1[top]);
 	printf("\nif %s ", temp);
    print_label();
 	printf("goto L%d\n\n", label_num);
    print_reset();
	temp_count[0]++;
	label[++ltop] = label_num;
}

void forinend()
{
    printf("\n%s = %s + 1\n", forvar[fortop], forvar[fortop--]);
    int y = label[ltop--];
    print_label();
	printf("\ngoto L%d\n", label[ltop--]);
	printf("\nL%d:\n",y);
    print_reset();
}

void push(char *a)
{
	strcpy(st1[++top], a);
}

void array1()
{
	strcpy(temp, "t");
	strcat(temp, temp_count);
	printf("\n%s = %s\n", temp, st1[top]);
	strcpy(st1[top], temp);
	temp_count[0]++;
	strcpy(temp, "t");
	strcat(temp, temp_count);
	printf("%s = %s [ %s ] \n", temp, st1[top-1], st1[top]);
	top--;
	strcpy(st1[top], temp);
	temp_count[0]++;
}

void codegen()
{
	strcpy(temp, "t");
	strcat(temp, temp_count);
	printf("\n%s = %s %s %s\n", temp, st1[top-2], st1[top-1], st1[top]);
	top -= 2;
	strcpy(st1[top], temp);
	temp_count[0]++;
}

void codegen_umin()
{
	strcpy(temp, "t");
	strcat(temp, temp_count);
	printf("\n%s = -%s\n", temp, st1[top]);
	top--;
	strcpy(st1[top], temp);
	temp_count[0]++;
}

void codegen_assign()
{
	printf("%s = %s\n", st1[top-2], st1[top]);
	top -= 2;
}

%}

%union {
    int ival;
    char *str;
}
%token<ival> INT FLOAT FN
%token<str> ID NUM REAL
%token IMPORT FUNCTION RETURN STRING ARRAY PRINT IF ELSE LOOP WHILE FOR IN RANGE LE GE EQ AND OR
%left LE GE EQ NEQ AND OR '<' '>'
%right '='
%right UMINUS
%left '+' '-'
%left '*' '/'
%type<str> assignment assignment1 consttype '=' '+' '-' '*' '/' E T F
%type<ival> Type

%%

start : Function start
	| IMPORT start
	| Declaration start
	|
	;

Function : Type ID '('')'  CompoundStmt {
            if (strcmp($2, "main") != 0)
                printf("goto F%d\n", lnum1);

            if ($1 != returntype_func(ct)) {
                print_error();
                printf("Type mismatch : Line %d\n", printline());
            }
            if (!(strcmp($2, "printf") && strcmp($2, "scanf") 
                && strcmp($2, "getc") && strcmp($2, "gets") && strcmp($2, "getchar") 
                && strcmp($2, "puts") && strcmp($2, "putchar") && strcmp($2, "clearerr") 
                && strcmp($2, "getw") && strcmp($2, "putw") && strcmp($2, "putc") 
                && strcmp($2, "rewind") && strcmp($2, "sprint") && strcmp($2, "sscanf") 
                && strcmp($2, "remove") && strcmp($2, "fflush"))) 
            {
                print_error();
                printf("Type mismatch in redeclaration of %s : Line %d\n", $2, printline());
            } else {
                insert($2, FUNCTION);
                insert($2, $1);
                g_addr += 4;
            }
        }
    | Type ID '(' parameter_list ')' CompoundStmt  {
            if ($1 != returntype_func(ct)) {
                print_error();
                printf(" Type mismatch : Line %d\n", printline()); 
                errc++;
            }

            if (!(strcmp($2,"printf") && strcmp($2,"scanf") 
                && strcmp($2,"getc") && strcmp($2,"gets") && strcmp($2,"getchar") 
                && strcmp($2,"puts") && strcmp($2,"putchar") && strcmp($2,"clearerr") 
                && strcmp($2,"getw") && strcmp($2,"putw") && strcmp($2,"putc") 
                && strcmp($2,"rewind") && strcmp($2,"sprint") && strcmp($2,"sscanf") 
                && strcmp($2,"remove") && strcmp($2,"fflush")))
            {
                print_error();
                printf(" Redeclaration of %s : Line %d\n", $2, printline());
                errc++;
            } else {
                insert($2, FUNCTION);
                insert($2, $1);
                for(j = 0; j <= k; j++) {
                    insertp($2, plist[j]);
                }
                k = -1;
            }
        }
	;

parameter_list : parameter_list ',' parameter
	| parameter
	;

parameter : Type ID { 
            plist[++k] = $1;
            insert($2, $1);
            insertscope($2, i);
        }
	;

Type : INT
	| FLOAT
	| FN
	;

CompoundStmt : '{' StmtList '}'
	;

StmtList : StmtList stmt
	|
	;

stmt : Declaration
	| if
	| ID '(' ')' ';'
    | loop
	| while
	| for
	| RETURN consttype ';' {
            if (!(strspn($2, "0123456789") == strlen($2)))
                storereturn(ct, FLOAT);
            else
                storereturn(ct, INT); ct++;
		}
	| RETURN ';' { storereturn(ct, FN); ct++; }
	| RETURN ID ';' {
            int sct = returnscope($2, stack[top - 1]);	//stack[top-1] - current scope
		    int type = returntype($2, sct);
            if (type == 259) storereturn(ct, FLOAT);
            else storereturn(ct, INT);
            ct++;
        }
	| ';'
	| PRINT '(' STRING ')' ';'
	| CompoundStmt
	;

if  : IF E { if1(); } CompoundStmt { if2(); } else
	;

else : ELSE CompoundStmt {if3();}
	|
	;

loop : LOOP { loop1(); } CompoundStmt { loop2(); } 

while : WHILE { while1(); }  E  { while2(); } CompoundStmt { while3(); }
	;

for : FOR ID { push($2); } IN F RANGE F { forin(); } CompoundStmt { forinend(); }
    /* | FOR '(' E { for1(); } ';' E { for2(); }';' E { for3(); } ')' CompoundStmt { for4(); } */
    ;


assignment : ID '=' consttype
	| ID '+' assignment
	| ID ',' assignment
	| consttype ',' assignment
	| ID
	| consttype
	;

assignment1 : ID { push($1); } '=' { strcpy(st1[++top], "="); } E { codegen_assign(); }
        {
            int sct = returnscope($1, stack[index1 - 1]);
            int type = returntype($1, sct);
            if ((!(strspn($5, "0123456789") == strlen($5))) && type == 258 && fl == 0) {
                print_error();
                printf("Type Mismatch : Line %d\n", printline());
            }
            if (!lookup($1))
            {
                int currscope = stack[index1 - 1];
                int scope = returnscope($1, currscope);
                if ((scope <= currscope && end[scope] == 0) && !(scope == 0))
                {
                    check_scope_update($1,$5,currscope);
                }
            }
        }
	| ID ',' assignment1    {
            if (lookup($1))
                print_error();
                printf("\nUndeclared Variable %s : Line %d\n",$1,printline());
        }
	| consttype ',' assignment1
	| ID  {
            if (lookup($1))
                print_error();
                printf("\nUndeclared Variable %s : Line %d\n",$1,printline());
		}
	| consttype
	;


consttype : NUM
	| REAL
	;

Declaration : Type ID { push($2); } '=' { strcpy(st1[++top], "="); } E { codegen_assign(); } ';'
        {
            if ( (!(strspn($6, "0123456789") == strlen($6))) && $1 == 258 && (fl == 0))
            {
                print_error();
                printf("Type Mismatch : Line %d\n", printline());
                fl = 1;
            }
            if (!lookup($2))
            {
                int currscope = stack[index1 - 1];
                int previous_scope = returnscope($2, currscope);
                if (currscope == previous_scope) {
                    print_error();
                    printf("Redeclaration of %s : Line %d\n", $2, printline());
                } else {
                    insert_dup($2, $1, currscope);
                    check_scope_update($2, $6, stack[index1 - 1]);
                    int sg = returnscope($2, stack[index1 - 1]);
                    g_addr += 4;
                }
            }
            else
            {
                int scope = stack[index1 - 1];
                insert($2, $1);
                insertscope($2, scope);
                check_scope_update($2, $6, stack[index1 - 1]);
                g_addr += 4;
            }
        }
	| assignment1 ';'  {
            if (!lookup($1))
            {
                int currscope = stack[index1 - 1];
                int scope = returnscope($1,currscope);
                if (!(scope <= currscope && end[scope] == 0) || scope == 0) {
                    print_error();
                    printf("Variable %s out of scope : Line %d\n", $1, printline());
                }
            }
            else {
                print_error();
                printf("Undeclared Variable %s : Line %d\n", $1, printline());
            }
        }
	| Type ID '[' assignment ']' ';' {
			int itype;

			if (!(strspn($4, "0123456789") == strlen($4)))
                itype=259;
            else 
                itype = 258;

			if (itype!=258) {
			    print_error();
                printf("Array index must be of type int : Line %d\n", printline());
                errc++;
            }

			if (atoi($4)<=0) { 
                print_error();
                printf("Array index must be of type int > 0 : Line %d\n", printline());
                errc++;
            }

			if (!lookup($2)) {
				int currscope = stack[top - 1];
				int previous_scope = returnscope($2, currscope);
				if (currscope == previous_scope) {
                    print_error();
                    printf("Redeclaration of %s : Line %d\n", $2, printline());
                    errc++;
                } else {
					insert_dup($2, ARRAY, currscope);
				    insert_by_scope($2, $1, currscope);	//to insert type to the correct identifier in case of multiple entries of the identifier by using scope
					if (itype == 258) {
                        insert_index($2, $4);
                    }
				}
			} else {
				int scope = stack[top - 1];
				insert($2, ARRAY);
				insert($2, $1);
				insertscope($2, scope);
				if (itype == 258) {
                    insert_index($2, $4);
                }
			}
		}
	| ID '[' assignment1 ']' ';'
	| error
	;

array : ID  { push($1); } '[' E ']'
	;

E   : E  '+' { strcpy(st1[++top], "+"); }  T  { codegen(); }
    | E  '-' { strcpy(st1[++top], "-"); }  T  { codegen(); }
    | T
    | ID  { push($1); }  LE   { strcpy(st1[++top], "<="); }  E  { codegen(); }
    | ID  { push($1); }  GE   { strcpy(st1[++top], ">="); }  E  { codegen(); }
    | ID  { push($1); }  EQ   { strcpy(st1[++top], "=="); }  E  { codegen(); }
    | ID  { push($1); }  NEQ  { strcpy(st1[++top], "!="); }  E  { codegen(); }
    | ID  { push($1); }  AND  { strcpy(st1[++top], "&&"); }  E  { codegen(); }
    | ID  { push($1); }  OR   { strcpy(st1[++top], "||"); }  E  { codegen(); }
    | ID  { push($1); }  '<'  { strcpy(st1[++top],  "<"); }  E  { codegen(); }
    | ID  { push($1); }  '>'  { strcpy(st1[++top],  ">"); }  E  { codegen(); }
    | ID  { push($1); }  '='  { strcpy(st1[++top],  "="); }  E  { codegen_assign(); }
    | array {array1();}
    ;

T   : T  '*' { strcpy(st1[++top], "*"); }  F  { codegen(); }
    | T  '/' { strcpy(st1[++top], "/"); }  F  { codegen(); }
    | F
    ;

F   : '(' E ')'     { $$ = $2; }
    | '-'           { strcpy(st1[++top], "-"); }  F  { codegen_umin(); } %prec UMINUS
    | ID            { push($1); fl = 1; }
    | consttype     { push($1); }
    ;

%%

#include "lex.yy.c"
#include <ctype.h>


int main(int argc, char *argv[]) {
	yyin = fopen(argv[1], "r");
	yyparse();
	if (!yyparse()) {
		printf("Parsing done\n");
		print();
	} else {
		printf("Error\n");
	}
	fclose(yyin);
	return 0;
}

void yyerror(char *s) {
    print_error();
	printf("\nLine %d : %s %s\n", yylineno, s, yytext);
}

int printline() {
	return yylineno;
}
