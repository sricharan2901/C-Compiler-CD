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
    void printtree(struct node*);
    void printInorder(struct node *);
    
    struct node* mknode(struct node *left, struct node *right, char *token);

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
    struct node *head;
    
//Creating a struct for the tree
    struct node { 
	struct node *left; 
	struct node *right; 
	char *token; 
    };
%}

%union { 
	struct var_name { 
		char name[100]; 
		struct node* nd;
	} nd_obj; 
} 

%token VOID 
%token <nd_obj> CHARACTER PRINTFF SCANFF INT FLOAT CHAR FOR IF ELSE TRUE FALSE NUMBER FLOAT_NUM ID LE GE EQ NE GT LT AND OR STR ADD MULTIPLY DIVIDE SUBTRACT UNARY INCLUDE RETURN 
%type <nd_obj> headers main body return dtype expression statement assgn val arithmetic aop program condition else

%%

program : headers main '(' ')' '{' body return '}' {
							 $2.nd = mknode($6.nd, $7.nd, "main"); 
							 $$.nd = mknode($1.nd, $2.nd, "program"); 
							 head = $$.nd; 
						   } 
;

headers : headers headers { 
				$$.nd = mknode($1.nd, $2.nd, "headers");
			  }
| INCLUDE 	{ 
			push('H'); 
			$$.nd = mknode(NULL, NULL, $1.name); 
		}
;

main : dtype ID { push('K'); }
;

dtype : INT { insert_type(); }
| FLOAT { insert_type(); }
| CHAR { insert_type(); }
| VOID { insert_type(); }
;

body : FOR { push('K'); } '(' statement ';' condition ';' statement ')' '{' body '}' { 
												struct node *temp = mknode($6.nd, $8.nd, "CONDITION"); 
												struct node *temp2 = mknode($4.nd, temp, "CONDITION"); 
												$$.nd = mknode(temp2, $11.nd, $1.name); 
										     }
| IF { push('K'); } '(' condition ')' '{' body '}' else { 
								struct node *iff = mknode($4.nd, $7.nd, $1.name); 	
								$$.nd = mknode(iff, $9.nd, "if-else"); 
							}
| statement ';' { $$.nd = $1.nd; }
| body body { 
			$$.nd = mknode($1.nd, $2.nd, "statements"); 
	     }
| PRINTFF { push('K'); } '(' STR ')' ';' { 
						$$.nd = mknode(NULL, NULL, "printf"); 
					 }
| SCANFF { push('K'); } '(' STR ',' '&' ID ')' ';' { 
							$$.nd = mknode(NULL, NULL, "scanf"); 
						   }
;

else : ELSE { push('K'); } '{' body '}' { $$.nd = mknode(NULL, $4.nd, $1.name); }
| { $$.nd = NULL; }
;

condition : val aop val { 
				$$.nd = mknode($1.nd, $3.nd, $2.name); 
			}
| TRUE  	{ 
			push('K'); 
			$$.nd = NULL; 
		}
| FALSE 	{ 
			push('K'); 
			$$.nd = NULL; 
		}
| { $$.nd = NULL; }
;

statement: dtype ID { push('V'); } assgn 	{ 
							$2.nd = mknode(NULL, NULL, $2.name); 
							$$.nd = mknode($2.nd, $4.nd, "declaration"); 
						}
						
| ID '=' expression 	{ 
				$1.nd = mknode(NULL, NULL, $1.name); 
				$$.nd = mknode($1.nd, $3.nd, "="); 
			}
			
| ID aop expression 	{ 
				$1.nd = mknode(NULL, NULL, $1.name); 
				$$.nd = mknode($1.nd, $3.nd, $2.name); 
			}
			
| ID UNARY 		{ 
				$1.nd = mknode(NULL, NULL, $1.name); 
				$2.nd = mknode(NULL, NULL, $2.name); 
				$$.nd = mknode($1.nd, $2.nd, "ITERATOR"); 
			}

| UNARY ID 		{ 
				$1.nd = mknode(NULL, NULL, $1.name); 
				$2.nd = mknode(NULL, NULL, $2.name); 
				$$.nd = mknode($1.nd, $2.nd, "ITERATOR"); 
			}
;

assgn : '=' val { $$.nd = $2.nd; }
| { $$.nd = mknode(NULL, NULL, "NULL"); }
;

expression : expression arithmetic expression { $$.nd = mknode($1.nd, $3.nd, $2.name); }
| val { $$.nd = $1.nd; }
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

val : NUMBER 	{ 
			push('C'); 
			$$.nd = mknode(NULL, NULL, $1.name); 
		}

| FLOAT_NUM 	{ 
			push('C'); 
			$$.nd = mknode(NULL, NULL, $1.name); 
		}

| CHARACTER 	{ 
			push('C'); 
			$$.nd = mknode(NULL, NULL, $1.name); 
		}

| ID 		{ 
			$$.nd = mknode(NULL, NULL, $1.name); 
		}
;

return : RETURN { push('K'); } val ';' 	{ 
						$1.nd = mknode(NULL, NULL, "return"); 
						$$.nd = mknode($1.nd, $3.nd, "RETURN"); 
					}
					
| { $$.nd = NULL; }
;

%%

int main() {
    yyparse();
    
	printf("\nSYNTAX ANALYSIS ...\n\n");
	printtree(head); 
	printf("\n\n");
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

struct node* mknode(struct node *left, struct node *right, char *token) {	
	struct node *new_node = (struct node *)malloc(sizeof(struct node));
	char *new_str = (char *)malloc(strlen(token)+1);
	strcpy(new_str, token);
	new_node->left = left;
	new_node->right = right;
	new_node->token = new_str;
	return(new_node);
}

void printtree(struct node* tree) {
	printf("\n\nParse Tree (Inorder Traversal) :- \n\n");
	printInorder(tree);
	printf("\n\n");
}

void printInorder(struct node *tree) {
	int i;
	if (tree->left) {
		printInorder(tree->left);
	}
	printf("%s, ", tree->token);
	if (tree->right) {
		printInorder(tree->right);
	}
}

void insert_type() {
	strcpy(type, yytext);		//Adding the Datatype
}

void yyerror(const char* msg) {		//Error message if Parsing not succesful
	printf("\nError!\n");
	fprintf(stderr, "%s\n", msg);
}
