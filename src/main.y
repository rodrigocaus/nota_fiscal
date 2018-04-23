/*  Parser de Xml para notas fiscais, parte Lex
 *
 *  Rodrigo Caus - 186807
 *	Victor Santolim - 187888
 */


%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(char *c);
int yylex(void);

double valorIss = 0.0;

%}

%token ANTTOMCID DEPTOMCID ANTPRESTCID DEPPRESTCID
%token AREATOM FIMAREATOM AREAPREST FIMAREAPREST
%token ANTCID DEPCID ANTVSERV DEPVSERV ANTVISS DEPVISS
%token STRING DOUBLE

%left ANTTOMCID ANTPRESTCID AREATOM AREAPREST ANTCID ANTVSERV ANTVISS

%union {
    double doubleValue;
    char *stringValue;
}

%%

PROGRAMA:
    PROGRAMA INFORMACAO {printf("ok\n");}
    |
    ;

INFORMACAO:
    ANTVISS DOUBLE DEPVISS {
        valorIss = $<doubleValue>2;
        printf("%lf\n", valorIss);
    }
    ;

%%

void yyerror(char *s) {
    printf("Nao foi possivel ler o arquivo\n");
}

int main() {
    yyparse();
    return 0;
}
