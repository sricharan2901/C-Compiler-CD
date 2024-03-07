%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<ctype.h>
    #include"lex.yy.c"
    
    void yyerror(const char *s);
    int yylex();
    int yywrap();
    void push(char);
    void insert_type();
    int search(char *);
    void insert_type();

    struct dataType {
        char * id_name;
        char * data_type;
        char * type;
        int line_no;
    } symbol_table[40];

    int count=0;
    int q;
    char type[10];
    extern int countn;
%}

%token VOID CHARACTER PRINTFF SCANFF INT FLOAT CHAR FOR IF ELSE TRUE FALSE NUMBER FLOAT_NUM ID LE GE EQ NE GT LT AND OR STR ADD MULTIPLY DIVIDE SUBTRACT UNARY INCLUDE RETURN 

%%

program : headers main '(' ')' '{' body return '}'
;

headers : headers headers
| INCLUDE { push('H'); }
;

main : dtype ID { push('F'); }
;

dtype : INT { insert_type(); }
| FLOAT { insert_type(); }
| CHAR { insert_type(); }
| VOID { insert_type(); }
;

body : FOR { push('K'); } '(' statement ';' condition ';' statement ')' '{' body '}'
| IF { push('K'); } '(' condition ')' '{' body '}' else
| statement ';'
| body body 
| PRINTFF { push('K'); } '(' STR ')' ';'
| SCANFF { push('K'); } '(' STR ',' '&' ID ')' ';'
;

else : ELSE { push('K'); } '{' body '}'
|
;

condition : val aop val 
| TRUE { push('K'); }
| FALSE { push('K'); }
|
;

statement : dtype ID { push('V'); } assgn
| ID '=' expression
| ID aop expression
| ID UNARY
| UNARY ID
;

assgn : '=' val
|
;

expression : expression arithmetic expression
| val
;

arithmetic : ADD 
| SUBTRACT 
| MULTIPLY
| DIVIDE
;

aop : LT
| GT
| LE
| GE
| EQ
| NE
;

val : NUMBER { push('C'); }
| FLOAT_NUM { push('C'); }
| CHARACTER { push('C'); }
| ID
;

return : RETURN { push('K'); } val ';'
|
;

%%

int main() {
  yyparse();
  printf("\n\n");
	printf("\nSYMBOL TABLE ... \n\n");
	printf("\nLEXEME\t\tDATATYPE\t\tSYMBOLTYPE  \n");
	printf("_______________________________________\n\n");
	int i=0;
	for(i=0; i<count; i++) {
		printf("%s\t\t%s\t\t%s\t\t\n", symbol_table[i].id_name, symbol_table[i].data_type, symbol_table[i].type);	//Printing the Symbol Table
	}
/*
	To free the Symbol table created :- 
	
	for(i=0;i<count;i++) {
		free(symbol_table[i].id_name);
		free(symbol_table[i].type);
	}
*/
	printf("\nParsing Completed ...\n\n");
}

int search(char *type) {
	int i;
	for(i=count-1; i>=0; i--) {
		if(strcmp(symbol_table[i].id_name, type)==0) {
			return -1;
			break;
		}
	}
	return 0;
}

void push(char c) {
  q=search(yytext); //Checking whether the symbol is already pushed to the symbol table or not.
  if(!q) {	//If not, then check for type
    		if(c == 'H') {						//Check if Header
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup(type);
			symbol_table[count].line_no=countn;
			symbol_table[count++].type=strdup("Header");
		}
		else if(c == 'K') {					//Check if Keyword
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup("N/A");
			symbol_table[count].line_no=countn;
			symbol_table[count++].type=strdup("Keyword\t");
		}
		else if(c == 'V') {					//Check if Variable
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup(type);
			symbol_table[count].line_no=countn;
			symbol_table[count++].type=strdup("Variable");
		}
		else if(c == 'C') {					//Check if Constant
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup("CONST");
			symbol_table[count].line_no=countn;
			symbol_table[count++].type=strdup("Constant");
		}
		else if(c == 'F') {					//Check if function
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup(type);
			symbol_table[count].line_no=countn;
			symbol_table[count++].type=strdup("Function");
		}
	}
}

void insert_type() {
	strcpy(type, yytext);		//Adding the Datatype
}

void yyerror(const char* msg) {		//Error message if Parsing not succesful
	printf("\nError!\n");
	fprintf(stderr, "%s\n", msg);
}
