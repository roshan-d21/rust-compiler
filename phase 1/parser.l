
alpha 			[A-Za-z_]
fl			    (f|F)
digit 			[0-9]
hex			    [a-fA-F0-9]
oct			    [0-7]
bin			    [0-1]
exp			    [Ee][+-]?{digit}+

%{
//int yylineno = 1;
char datatype[100] = "dummy";
int tl;
char next;
#include <stdio.h>
#include <string.h> 
%}

%%	
\n            { yylineno++; }
"/*"					{ multicomment(); }
"//"					{ singlecomment(); }

"use std::io;" {}

{digit}+    				              { insertToConstTable(yytext, yylineno, "int"); return CONSTANT; }
({digit}+)\.({digit}+) 			      { insertToConstTable(yytext, yylineno, "float"); return CONSTANT; }

0x{hex}+			                    { insertToConstTable(yytext, yylineno, "int (hex)"); return CONSTANT; }
0o{oct}+			                    { insertToConstTable(yytext, yylineno, "int (octal)"); return CONSTANT; }
0b{bin}+			                    { insertToConstTable(yytext, yylineno, "int (binary)"); return CONSTANT; }

'(\\.|[^\\'])+'				            { insertToConstTable(yytext, yylineno, "char"); return CONSTANT; }

{digit}+{exp}{fl}?			          { insertToConstTable(yytext, yylineno, "float"); return CONSTANT; }
{digit}*"."{digit}+({exp})?{fl}?	{ insertToConstTable(yytext, yylineno, "float"); return CONSTANT; }

{alpha}?\"(\\.|[^\\"])*\"		      { insertToConstTable(yytext, yylineno, "String"); return STRING_LITERAL; } 

"++"			    { return INC_OP; }
"--"			    { return DEC_OP; }
"<<"			    { return LEFT_OP; }
">>"			    { return RIGHT_OP; }
"<="			    { return LE_OP; }
">="			    { return GE_OP; }
"=="			    { return EQ_OP; }
"!="			    { return NE_OP; }
"&&"			    { return AND_OP; }
"||"			    { return OR_OP; }
"+="			    { return ADD_ASSIGN; }
"-="			    { return SUB_ASSIGN; }
".."|"..="    { return RANGE; }

"let"         { strcpy(datatype, "Variable"); tl = yylineno; return LET; }
"const"			  { strcpy(datatype, "Variable (Const)"); tl = yylineno; return CONST; }
"static"      { strcpy(datatype, "Variable (Static)"); tl = yylineno; return STATIC; }

"fn"          { return FN; }
"return"		  { return RETURN; }

"if"			    { return IF; }
"else"			  { return ELSE; }
"loop"        { return LOOP; }
"while"			  { return WHILE; }
"for"			    { strcpy(datatype, "Variable"); tl = yylineno; return FOR; }
"in"          { return IN; }
".iter()"     { return ITER; }
"break"			  { return BREAK; }
"continue"	  { return CONTINUE; }


";"			      {  strcpy(datatype, "dummy"); return(';'); }
("{"|"<%")		{  return('{'); }
("}"|"%>")		{  return('}'); }
","			      {  return(','); }
":"			      {  return(':'); }
"="			      {  return('='); }
"("			      {  return('('); }
")"			      {  return(')'); }
"&"			      {  return('&'); }
"!"			      {  return('!'); }
"-"			      {  return('-'); }
"+"			      {  return('+'); }
"*"			      {  return('*'); }
"/"			      {  return('/'); }
"<"			      {  return('<'); }
">"			      {  return('>'); }


"print!"|"println!"|"io::stdin().read_line"	   { insertToHash(yytext,"Function",yylineno); return IDENTIFIER; }
"main" 			                                   { insertToHash(yytext,"Function",yylineno); return IDENTIFIER; }


{alpha}({alpha}|{digit})*    		{  
                                  if(strcmp(datatype, "dummy")==0)
                                    return IDENTIFIER;
                                  else 
                                  {
                                    insertToHash(yytext,datatype,yylineno);
                                    return IDENTIFIER; 
                                  }
                                }

[ \t\v\n\f]		{  }
.			{ yyerror("Lexical Error"); /* bad characters */ }


%%

struct cnode
{
	char num[50];
	char type[20];
};
struct cnode ctable[100];
int ccount = 0;

void insertToConstTable(char *num, int l, char *type)
{
	strcpy(ctable[ccount].num, num);
	strcpy(ctable[ccount].type, type);
	ccount++;
}

void disp()
{
	int i;
	printf("\n\n------------------------------Constant Table------------------------------\n");
	printf("--------------------------------------------------------------------------\n");
	printf("Value \t\t|\tData Type\t\t\n");
	printf("--------------------------------------------------------------------------\n");
	for(i=0;i<ccount;i++)
	{
		printf("%s\t\t\t", ctable[i].num);
		printf("%s\t\t\t\n", ctable[i].type);
		//printf("\t%d\t\n", ctable[i].lno);
	}
	printf("\n\n");
}

struct node
{
	char token[100];
    char attr[100];
    int line_count;
	struct node *next;
};

struct hash
{
	struct node *head;
	int hash_count;
};

struct hash hashTable[1000];
int eleCount = 1000;

struct node * createNode(char *token, char *attr, int l)
{
	struct node *newnode;
	newnode = (struct node *) malloc(sizeof(struct node));
	strcpy(newnode->token, token);
	strcpy(newnode->attr, attr);
	newnode->line_count = 1; 
	newnode->next = NULL;
	return newnode;
}

int hashIndex(char *token)
{
	int hi=0;
	int l,i;
	for(i=0;token[i]!='\0';i++)
	{
		hi = hi + (int)token[i];
	}
	hi = hi%eleCount;
	return hi;
}

void insertToHash(char *token, char *attr, int l)
{
	int flag=0;
	int hi;
	hi = hashIndex(token);
	struct node *newnode = createNode(token, attr, l);
	/* head of list for the bucket with index "hashIndex" */
	if (hashTable[hi].head==NULL)
	{
		hashTable[hi].head = newnode;
	        hashTable[hi].hash_count = 1;
	        return;
	}
	struct node *myNode;
    	myNode = hashTable[hi].head;
	while (myNode != NULL)
    	{
        	if (strcmp(myNode->token, token)==0)
        	{
            		flag = 1;
            		//myNode->line[(myNode->line_count)++] = l;
            		if(strcmp(myNode->attr, attr)!=0)
            		{
            			strcpy(myNode->attr, attr);
            		}
            		break;
        	}
        	myNode = myNode->next;
    	}
	if(!flag)
	{
		//adding new node to the list
		newnode->next = (hashTable[hi].head);
		//update the head of the list and no of nodes in the current bucket
		hashTable[hi].head = newnode;
		hashTable[hi].hash_count++;
	}
	return;
}

void display()
{
    	struct node *myNode;
    	int i,j, k=1;
    	printf("\n-----------------------------------------Symbol Table---------------------------------------------\n");
    	printf("--------------------------------------------------------------------------------------------------");
    	printf("\nToken \t\t|\tToken Type \t\t\t\t\t \n");
        printf("--------------------------------------------------------------------------------------------------\n");
    	for (i = 0; i < eleCount; i++)
    	{
        	if (hashTable[i].hash_count == 0)
            		continue;
        	myNode = hashTable[i].head;
        	if (!myNode)
            		continue;
        	while (myNode != NULL)
        	{
            		//printf("%d\t\t", k++);
            		printf("%s\t\t\t", myNode->token);
            		printf("%s\t\t\t", myNode->attr);
            		/*for(j=0;j<(myNode->line_count);j++)
            			printf("%d  ",myNode->line[j]);*/
            		printf("\n");
            		myNode = myNode->next;
        	}
	}
	printf("--------------------------------------------------------------------------------------------------\n");
   	return;
}

yywrap()
{
	return(1);
}
multicomment()
{
	char c, c1;
	while ((c = input()) != '*' && c != 0);
	c1=input();
	if(c=='*' && c1=='/')
	{
		c=0;
	}
	if (c != 0)
		putchar(c1);
}
singlecomment()
{
	char c;
	while(c=input()!='\n');
	if(c=='\n')
		c=0;
	if(c!=0)
		putchar(c);
}
