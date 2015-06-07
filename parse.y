// Bison file

%{
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <stdarg.h>
#include "node.h"
#include "utility.h"

extern FILE *yyin;
extern yylineno;
char* buffer[1];
char bufferForReadExprssion[20];
typedef enum { false, true } bool;

//Function prototypes
nodeType* opr(int operation, int num_ops, ...);
nodeType* var(char* name);
nodeType* lit(int value);
nodeType* str(char* str);
void freeNode(nodeType *p);

int sym[26];  // Symbol table is size of array 26
%}

%union {
	int iValue; // for integer value
	int bValue; // for boolean value
	char *sString; // for string value
	nodeType *nPtr;  // for node pointer
};

%token <iValue> num
%token <bValue> boollit
%token <iValue> OP2 OP3 OP4
%token <sString> ident
%token LP RP ASGN SC INT BOOL
%token IF THEN ELSE BEGIN_STMT END WHILE DO PROGRAM VAR AS
%token WRITEINT READINT

%type <nPtr> assignment factor expression ifStatement statementSequence elseClause whileStatement simpleExpression term statement program declarations type writeInt
%start program

%%
program:
	PROGRAM declarations BEGIN_STMT statementSequence END { $$ = opr(PROGRAM, 3, $2, $4,str("end"));
	printf("\n-- Generated code -- \n\n");
	printf("#include<stdio.h>\n");
	printf("#include<stdlib.h>\n");
	printf("void main()\n");
	initializeBuffer(buffer);
	printBuffer(buffer);
	execution($$);
	} 
	;
declarations:
	VAR ident AS type SC declarations { $$ = opr(AS, 4, $4,var($2),opr(SC,0),$6); }
	| { $$ = NULL;  }
	;
type:
	INT { $$ = str("int");  }
	| BOOL { $$ = str("bool"); }
	;
statementSequence:
	statement SC statementSequence { $$ = opr(SC, 2, $1, $3);  }
	| { $$ = NULL; }
	;
statement:
	assignment { $$ = $1; }
	| ifStatement { $$ = $1;  }
	| whileStatement { $$ = $1; }
	| writeInt { $$ = $1; }
	;
assignment:
	ident ASGN expression { $$ = opr(ASGN, 2, var($1), $3); }
	| ident ASGN READINT { $$ = opr(ASGN, 2, var($1), opr(READINT,0)); }
	;
ifStatement:
	IF expression THEN statementSequence elseClause END { $$ = opr(IF, 4, $2, $4, $5, str("end"));}
	;
elseClause:
	ELSE statementSequence { $$ = opr(ELSE, 1, $2); }
	| { $$ = NULL; }
	;
whileStatement:
	WHILE expression DO statementSequence END { $$ = opr(WHILE, 3, $2, $4,str("end")); }
	;
writeInt:
	WRITEINT expression { $$ = opr(WRITEINT, 1, $2); }
	;
expression:
	simpleExpression { $$ = $1; }
	| simpleExpression OP4 simpleExpression { $$ = opr($2, 2, $1, $3); }
	;
simpleExpression:
	term OP3 term { $$ = opr($2, 2, $1, $3);}
	| term { $$ = $1; }
	;
term:
	factor OP2 factor { $$ = opr($2, 2, $1, $3); }
	| factor { $$ = $1; }
	;
factor:
	ident { $$ = var($1); }
	| num { $$ = lit($1);
		if(!($1 >=-2147483647 && $1 <= 2147483647)) {
			yyerror("Integer overflow at line number "); }
 		}
	| boollit { $$ = lit($1); }
	| LP expression RP { $$ = $2; }
	;
%%

char* getStringForConstant(int num){
	switch(num){
		case 0:
			return "*";
		case 1:
			return "/";
		case 2:
			return "%";
		case 3:
			return "+";
		case 4:
			return "-";
		case 5:
			return "==";
		case 6:
			return "!=";
		case 7:
			return "<";
		case 8:
			return ">";
		case 9:
			return "<=";
		case 10:
			return ">=";
		case 264 :
			return "(";		
		case 265:
			return ")";		
		case 266:
			return "=";		
		case 267:
			return ";";		
		case 270:
			return "if";		
		case 271:
			return "{";		
		case 272:
			return "else";		
		case 274:
			return "}";		
		case 275:
			return "while";		
		case 276:
			return "{";		
		case 277:
			return "{";		
		case 280:
			return "printf()";		
		case 281:
			return "scanf()";		
		default:
		
			return "";
	
	}
}

void printNode(nodeType* tmpNode){
	switch(tmpNode->type){			
		case typeLit:
			printf("%d ",tmpNode->lit.value);
			break;
		case typeVar:
			printf("%s ",tmpNode->var.name);
			break;
		case typeStr:
			printf("%s ",tmpNode->str.name);
		break;
	}
}


char* readExpr(nodeType* p){
	switch(p->type){
		case typeVar:
			return p->var.name;
			break;
		case typeLit:{
			sprintf(bufferForReadExprssion,"%d",p->lit.value);
			char* temp = malloc(sizeof(bufferForReadExprssion));
			strcpy(temp,bufferForReadExprssion);
		 	return temp; 
			break;
			}
		case typeOp:{
			char *part1,*part2,*part3;
			part2 = getStringForConstant(p->op.operation);
			part1 = readExpr(p->op.operands[0]);
			part3 = readExpr(p->op.operands[1]);
			if(part1!=NULL && part3!=NULL){
			}
		 	strcat(part1,part2);
			strcat(part1,part3);
			return part1;
			break;
		}
	}
}

int execution(nodeType *p){
	if(!p){
	
		return 1;
	}	

	switch(p->type){
		case typeLit:
			printf("%d ",p->lit.value);
			break;
		case typeVar:
			printf("%s; ",p->var.name);
			break;
		case typeStr:{
			if(strcmp(p->str.name,"end")==0)
				printf("\n}\n");
			else
				printf("%s ",p->str.name);
			break;
			}
		case typeOp:{
		       	switch(p->op.operation){
				case 280:
					{
						char* child = readExpr(p->op.operands[0]);
						printf("\nprintf(\"%s\",%s);","%d",child);
					}
					break;
				case 274:// printing }
					printf("}\n");
					break;
				case 277: // printing {
					printf("{\n");
					break;				
				case 267: // add semicolon
					addToBuffer(buffer,getStringForConstant(p->op.operation));
					break;
				case 266: // add equals
					{					
				
						char *lhs, *rhs;
						lhs = readExpr(p->op.operands[0]);
					 	nodeType* node= p->op.operands[1];
						// in case second child is "scanf"
						if(node->op.operation == 281 )
						{	
							rhs = getStringForConstant(node->op.operation);
							char ampercentAndVariable[] = "&";
							strcat(ampercentAndVariable, lhs);
							printf("\nscanf(\"%s\",%s);","%d",ampercentAndVariable);
						}
						else
						{							
							rhs = readExpr(p->op.operands[1]);
							printf("\n%s = %s;",lhs,rhs);
						}						
					}	
					initializeBuffer(buffer);
					break;

			 	case 270: {// if case 
					nodeType* condition = p->op.operands[0];
					printf("\nif (%s %s %s){",readExpr(condition->op.operands[0]),getStringForConstant(condition->op.operation),
						readExpr(condition->op.operands[1]));
					}
					break;
				case 275: {// while case
					nodeType* condition1 = p->op.operands[0];
					printf("\nwhile (%s %s %s){",
					readExpr(condition1->op.operands[0]),getStringForConstant(condition1->op.operation),
						readExpr(condition1->op.operands[1]));

					}
					break;
				case 272: // else case
					printf("\n}else{\n");
					p = p->op.operands[0];
					break;
				}	

			int count = 0;	
			while(count<p->op.num_ops){
				nodeType* tmpNode = p->op.operands[count];
				count += 1;
				if(p->op.operation==270  && count == 1)
					continue;
				
				if(p->op.operation==275  && count == 1)
					continue;
				
				if(p->op.operation==266)
					break;
				if(p->op.operation==280)
					break;
				execution(tmpNode);
			}
			break;
			}
		default:
			printf("\n -----  Default case ----- \n");
	}
}

nodeType* lit(int value) { // For literals
	nodeType* pntr;

	if ((pntr = malloc(sizeof(nodeType))) == NULL) // memory not available
		yyerror("Memory out of bound!");
	pntr->type = typeLit;
	pntr->lit.value = value;

	return pntr;
}

nodeType* str(char* str) {
	nodeType* pntr;

	if ((pntr = malloc(sizeof(nodeType))) == NULL)  // memory not available
		yyerror("Memory out of bound!");
	
	pntr->type = typeStr;
	pntr->str.name = str;

	return pntr;
}

nodeType* var(char* name) {  // For variables
	nodeType* pntr;
	
	if ((pntr = malloc(sizeof(nodeType))) == NULL) // memory not available
		yyerror("Memory out of bound!");

	pntr->type = typeVar;
	pntr->var.name = name;

	return pntr;
}

nodeType* opr(int operation, int num_ops, ...) { // For operators
	va_list ap;
	nodeType* pntr;
	int i;
        	
	if ((pntr = malloc(sizeof(nodeType))) == NULL)  // memory not available
		yyerror("Memory out f bound!");

	if ((pntr->op.operands = malloc(num_ops * sizeof(nodeType*))) == NULL) // memory not available
		yyerror("Memory out of bound!");

	pntr->type = typeOp;
	pntr->op.operation = operation;
	pntr->op.num_ops = num_ops;
	va_start(ap, num_ops);
	for (i = 0; i < num_ops; i++)
		pntr->op.operands[i] = va_arg(ap, nodeType*);
		
	va_end(ap);
	return pntr;
}

int yyerror (char *s) {
	//printf("%s\n", s);
	printf("Error: %s : %d\n",s,yylineno);
	printf("Input is not accepted\n\n");
}

int main(int argc, char** argv) { // main function
	++argv, --argc;
	if (argc > 0)
		yyin = fopen(argv[0], "r"); // Open file
	else
		yyin = stdin;
	do {
		yyparse();
	} while (!feof(yyin));
	printf("Input is accepted\n\n");
}
