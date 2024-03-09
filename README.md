# **Creating a C Compiler Using LEX and YACC**
## What is LEX?
Lex in compiler design is a program used to generate scanners or lexical analyzers, also called tokenizers. These tokenizers identify the lexical pattern in the input program and convert the input text into the sequence of tokens. It is used with the YACC parser generator.

## What is YACC?
YACC stands for Yet Another Compiler Compiler. It provides a tool to produce a parser for a given grammar. It is used to produce the source code of the syntactic analyzer of the language produced by grammar. The input of YACC is the rule or grammar and the output is a C program.

## Compiler Features / Stages
1. Lexical Analyser
2. Parser with Grammar rules
3. Symbol Table
4. Parse Tree Generation
5. Semantic Analysis
6. Intermediate Code Generation

## Design of the Compiler

The compiler designed process the following constructs :-
* Simple C programs with declaration, assignment, printf, scanf and arithmetic operations.
* Simple for loops and if-else statements.
* Nested for loops and if-else statements.
* Simple datatypes like int, float and char.


The following is considered while taking an input file for the compiler :-
* Body of all if-else statements must be enclosed within parenthesis'.
* Only simple datatypes are considered.
* Scope of all variables is same.

## Compiler Outputs for an input code

Let us try to run the various stages of the compiler for the following input code

https://github.com/sricharan2901/C-Compiler-CD/blob/5667efc7acfd52f235df2c0401d01b54ee2657bc/inp1.c




