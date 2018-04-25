/*  Parser de Xml para notas fiscais, parte YACC
 *
 *  Rodrigo Caus - 186807
 *	Victor Santolim - 187888
 */


%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(char *c);
int yylex(void);

double valorIss = -1.0;
double valorServico = -1.0;
char municipioTomador[100];
char municipioPrestador[100];

%}

%define parse.error verbose

%token ANTCIDTOM DEPCIDTOM ANTCIDPREST DEPCIDPREST
%token AREATOM FIMAREATOM AREAPREST FIMAREAPREST
%token ANTCEP DEPCEP ANTVSERV DEPVSERV ANTVISS DEPVISS
%token STRING DOUBLE

%left ANTCIDTOM DEPCIDTOM ANTCIDPREST DEPCIDPREST
%left AREATOM FIMAREATOM AREAPREST FIMAREAPREST
%left ANTCEP DEPCEP ANTVSERV DEPVSERV ANTVISS DEPVISS
%left STRING DOUBLE

%union {
    double doubleValue;
    char *stringValue;
}

%%

PROGRAMA:
    PROGRAMA INFORMACAO
    |
    ;

INFORMACAO:
    ANTVISS DOUBLE DEPVISS {
        valorIss = $<doubleValue>2;
    }
    | ANTVSERV DOUBLE DEPVSERV {
        valorServico = $<doubleValue>2;
    }
    | ANTCIDTOM STRING DEPCIDTOM {
        strcpy(municipioTomador, $<stringValue>2);
        free($<stringValue>2);
    }
    | ANTCIDPREST STRING DEPCIDPREST {
        strcpy(municipioPrestador, $<stringValue>2);
        free($<stringValue>2);
    }
    | AREATOM DADO ANTCEP STRING DEPCEP DADO FIMAREATOM {
        strcpy(municipioTomador, $<stringValue>4);
        free($<stringValue>4);
    }
    | AREAPREST DADO ANTCEP STRING DEPCEP DADO FIMAREAPREST {
        strcpy(municipioPrestador, $<stringValue>4);
        free($<stringValue>4);
    }
    | INFORMACAO INFORMACAO
    | INFORMACAO DADO
    | DADO INFORMACAO
    ;

DADO:
    STRING {
        free($<stringValue>1);
    }
    | DOUBLE
    | DADO DADO
    |
    ;

%%

void yyerror(char *s) {
    printf("%s\n", s);
}

int main() {

    // Inicializa as strings como vazias
    strcpy(municipioTomador, "-");
    strcpy(municipioPrestador, "-");

    yyparse();

    printf("%s,%s,%.2lf,%.2lf\n", municipioTomador, municipioPrestador
                            , valorServico, valorIss);

    return 0;
}
